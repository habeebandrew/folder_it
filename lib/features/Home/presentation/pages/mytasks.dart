import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:folder_it/features/Group_Browser/presentation/group_pages/upload_files_page.dart';
import 'package:http/http.dart' as http;
import '../../../../localization/localization.dart';

class MyTasks extends StatefulWidget {
  const MyTasks({super.key});

  @override
  State<MyTasks> createState() => _MyTaskOnGroupState();
}

class _MyTaskOnGroupState extends State<MyTasks> {
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
    required int size,
    required int start,
  }) async {
    final String token = CacheHelper().getData(key: 'token');
    final url = Uri.parse(
        'http://localhost:8091/document/fetch-my-locked-document?userId=$userId&size=$size&start=$start');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> parsedList = responseData['list']
          .map((item) => {
        'document': item['document'],
        'groupName': item['groupName'],
      })
          .toList();

      return {
        'extraData': responseData['extraData'],
        'list': parsedList,
      };
    } else {
      throw Exception(
          '${AppLocalization.of(context)?.translate("fetch_failed")} ${response.statusCode}');
    }
  }

  Future<void> fetchInitialDocuments({bool reset = false}) async {
    final int userId = CacheHelper().getData(key: 'myid');
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
        userId: userId,
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
        SnackBar(
            content: Text(AppLocalization.of(context)
                ?.translate("fetch_error") ??
                "Error: $error")),
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
    var headers = {'Authorization': 'Bearer $token'};
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
      return AppLocalization.of(context)?.translate("cancel_failed") ??
          'Something went wrong';
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
          ? Center(
        child: Text(AppLocalization.of(context)?.translate("loading") ??
            "Loading..."),
      )
          : documents.isEmpty
          ? Center(
        child: Text(AppLocalization.of(context)
            ?.translate("no_documents") ??
            "No documents"),
      )
          : ListView.builder(
        itemCount: documents.length + (hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < documents.length) {
            final document = documents[index]['document'];
            final groupName = documents[index]['groupName'];
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
                            groupId: 0,
                            folderId: 0,
                            vsId: document['vsid'],
                            fileName: document['subject'],
                          ),
                        ),
                      );
                      if (result == true) {
                        fetchInitialDocuments(reset: true);
                      }
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(AppLocalization.of(context)
                        ?.translate("check_out") ??
                        "Check out"),
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
                        document['note'] ??
                            AppLocalization.of(context)
                                ?.translate("no_note") ??
                            "No note",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.lock, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalization.of(context)!.translate(
                                "locked_in_group")
                               ,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Text(groupName,   style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),)
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
                                AppLocalization.of(context)
                                    ?.translate("cancel_success")) {
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
                        label: Text(AppLocalization.of(context)
                            ?.translate("cancel_check_in") ??
                            "Cancel Check-in"),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: TextButton(
                onPressed: fetchInitialDocuments,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(AppLocalization.of(context)
                    ?.translate("load_more") ??
                    "Load More"),
              ),
            );
          }
        },
      ),
    );
  }
}
