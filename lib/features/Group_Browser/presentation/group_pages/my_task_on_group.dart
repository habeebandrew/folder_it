// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:folder_it/features/Group_Browser/presentation/group_pages/upload_files_page.dart';
import 'package:http/http.dart' as http;

import '../../../../localization/localization.dart';

class MyTaskOnGroup extends StatefulWidget {
  final int userId;
  final int groupId;
  final int folderId;

  const MyTaskOnGroup(
      {super.key,
      required this.userId,
      required this.groupId,
      required this.folderId});

  @override
  State<MyTaskOnGroup> createState() => _MyTaskOnGroupState();
}

class _MyTaskOnGroupState extends State<MyTaskOnGroup> {
  List<dynamic> documents = [];
  int currentPage = 0;
  bool isLoading = false;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    fetchInitialDocuments();
  }

  Future<Map<String, dynamic>> fetchLockedDocuments({
    required int userId,
    required int groupId,
    required int size,
    required int start,
  }) async {
    final String token = CacheHelper().getData(key: 'token');

    final url = Uri.parse(
        'http://localhost:8091/document/fetch-my-locked-document?userId=$userId&groupId=$groupId&size=$size&start=$start');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> parsedList =
          responseData['list'].map((item) => item['document']).toList();
      print('doc: $parsedList');
      return {
        'extraData': responseData['extraData'],
        'list': parsedList,
      };
    } else {
      throw Exception('Failed to fetch documents: ${response.statusCode}');
    }
  }

  Future<void> fetchInitialDocuments({bool reset = false}) async {
    try {
      if (reset) {
        setState(() {
          documents = [];
          currentPage = 0;
          hasMoreData = true;
        });
      }

      setState(() {
        isLoading = true;
      });

      final data = await fetchLockedDocuments(
        userId: widget.userId,
        groupId: widget.groupId,
        size: 3,
        start: currentPage,
      );

      setState(() {
        documents.addAll(data['list']);
        hasMoreData = documents.length < data['extraData'];
        currentPage += 1;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> cancelCheckIn(String fileId, String vsId) async {
    final String token = CacheHelper().getData(key: 'token');
    final int userId = CacheHelper().getData(key: "myid");
    print(token);
    print(userId.toString());
    var headers = {
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest(
        'GET',
        Uri.parse(
            'http://localhost:8091/document/cancel-check-in?vsId=$vsId&userId=$userId'));

    request.fields.addAll({'id': fileId, 'userId': '$userId'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var res = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return json.decode(res)['message'];
    } else {
      return 'something went wrong';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Text(''),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: documents.isEmpty && isLoading
            ? const Center(child: CircularProgressIndicator())
            : documents.isEmpty
                ? const Center(child: Text('no documntes'))
                : ListView.builder(
                    itemCount: documents.length + (hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < documents.length) {
                        final document = documents[index];
                        return ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                document['subject'],
                                style: const TextStyle(color: Colors.red),
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UploadFilesPage(
                                        groupId: widget.groupId,
                                        folderId: widget.folderId,
                                        vsId: document['vsid'],
                                        fileName: document['subject'],
                                      ),
                                    ),
                                  );
                                  if (result == true) {
                                    fetchInitialDocuments(reset: true);
                                  }
                                },
                                icon: Icon(
                                  Icons.check_circle_outline,
                                  size: 18, // تصغير حجم الأيقونة
                                ),
                                label: Text(
                                  AppLocalization.of(context)!.translate("Check_out") ?? "Check_out",
                                  style: const TextStyle(fontSize: 20), // تصغير حجم النص
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // تقليل الحشو الداخلي
                                  minimumSize: const Size(10, 30), // تحديد الحد الأدنى للأبعاد
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Container(
                              alignment: AlignmentDirectional.centerStart,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 10.0),
                              color: Theme.of(context).cardColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    document['note'] ?? 'No note',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  const Row(
                                    children: [
                                      Icon(Icons.lock, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text(
                                        'File is locked',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    style: Theme.of(context)
                                        .elevatedButtonTheme
                                        .style,
                                    onPressed: () async {
                                      await cancelCheckIn(
                                              document['id'].toString(),
                                              document['vsid'].toString())
                                          .then((value) {
                                        if (value ==
                                            'Canceled Check In Successfully.') {
                                          setState(() {
                                            documents.removeAt(index);
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(value),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(value),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.cancel,
                                    ),
                                    label:  Text(AppLocalization.of(context)!.translate("Cancel_Check_in") ?? "Cancel_Check_in",),//AppLocalization.of(context)!.translate("invite_new_member") ?? "invite_new_member",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        // زر تحميل المزيد
                        return Center(
                          child: TextButton(
                            onPressed: fetchInitialDocuments,
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Load More'),
                          ),
                        );
                      }
                    },
                  ));
  }
}
