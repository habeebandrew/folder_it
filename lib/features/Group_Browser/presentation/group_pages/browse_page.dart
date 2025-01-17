import 'package:flutter/material.dart';
import 'package:folder_it/features/Group_Browser/presentation/group_pages/file_log.dart';
import 'package:folder_it/features/Group_Browser/presentation/group_pages/upload_files_page.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;
import 'dart:convert';

import 'package:intl/intl.dart';
import '../../../../core/databases/cache/cache_helper.dart';
import '../../../../localization/localization.dart';

class BrowsePage extends StatefulWidget {
  final int groupId;
  final int userId;
  final int folderId;

  BrowsePage(
      {super.key,
        required this.groupId,
        required this.userId,
        required this.folderId});

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  Map<String, dynamic>? currentResponse;
  dynamic expandedElement; // العنصر المفتوح
  List<Map<String, dynamic>> history = [];
  List<int> selectedFiles = [];
  bool loading = false;

  Future<Map<String, dynamic>> fetchFolderContent(
      {required int parentId}) async {
    if (currentResponse != null) {
      return currentResponse!;
    } // استخدام البيانات المحملة مسبقاً

    final String? token = CacheHelper().getData(key: 'token');
    if (token == null) {
      throw Exception('Token is missing!');
    }

    final url = Uri.parse(
        'http://localhost:8091/folder/content?parentId=$parentId&userId=${widget.userId}');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load folder content: ${response.statusCode}');
    }
  }

  void navigateToFolder(int folderId) async {
    try {
      final newResponse = await fetchFolderContent(parentId: folderId);
      setState(() {
        if (currentResponse != null) {
          history.add(currentResponse!);
        }
        currentResponse = newResponse;
        expandedElement = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void goBack() {
    if (history.isNotEmpty) {
      setState(() {
        currentResponse = history.removeLast();
        expandedElement = null;
      });
    }
  }

  Future<void> checkInSelectedFiles() async {
    if (selectedFiles.isEmpty) return;
    setState(() {
      loading = true;
    });
    final url = Uri.parse('http://localhost:8091/document/check-in');
    final int myId = CacheHelper().getData(key: "myid") ?? 1;
    final String? token = CacheHelper().getData(key: 'token');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    };

    final request = http.MultipartRequest('POST', url); // أضف `userId`

    // Append each file ID to the formatted string
    for (int i = 0; i < selectedFiles.length; i++) {
      request.fields.addAll({'id${i + 1}': selectedFiles[i].toString()});
    }
    request.fields.addAll({'userId': myId.toString()});

    print(request.fields);

    request.headers.addAll(headers);

    try {
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        setState(() {
          loading = false;
          for (final fileId in selectedFiles) {
            final document = currentResponse!['documents']
                .firstWhere((doc) => doc['id'] == fileId, orElse: () => null);
            if (document != null) {
              document['locked'] = true;
            }
          }
          selectedFiles.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Files checked in successfully!'),
              backgroundColor: Colors.green),
        );
      } else {
        //throw Exception('Failed to check in files: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to check in files')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<String> getTempFile(String vsId) async {
    final int myId = CacheHelper().getData(key: "myid") ?? 1;
    final String? token = CacheHelper().getData(key: 'token');
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://127.0.0.1:8091/document/temp?userId=$myId&vsId=$vsId'
        )
    );
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var res =await response.stream.bytesToString();
    print(res);
    if (response.statusCode == 200) {
      return res;
    } else {
      return 'something went wrong';
    }
  }

  Future<void> downloadFile(String fileName) async {
    final String? token = CacheHelper().getData(key: 'token');

    final url = Uri.parse('http://localhost:8091/document/files/$fileName');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final blob = html.Blob([response.bodyBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..download = fileName
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      print("Error: ${response.reasonPhrase}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          Tooltip(
            message: AppLocalization.of(context)!.translate("Add_new_file") ?? "Add_new_file",
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadFilesPage(
                        groupId: widget.groupId,
                        folderId: widget.folderId,
                        vsId: '',
                        fileName: '',
                      ),
                    ),
                  ).then((_) {
                    setState(() {
                      currentResponse = null;
                    });
                  });
                },
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    AppLocalization.of(context)!.translate("Add_new_file") ?? "Add_new_file",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.grey[400]!),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchFolderContent(parentId: widget.folderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          } else {
            currentResponse = snapshot.data;

            return LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedFiles = List<int>.from(
                                    currentResponse!['documents']
                                        .where((doc) => doc['locked'] == false)
                                        .map((doc) => doc['id']),
                                  );
                                });
                              },
                              child:  Text(AppLocalization.of(context)!.translate("Select_All") ?? "Select_All",),//
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedFiles.clear();
                                });
                              },
                              child:  Text(AppLocalization.of(context)!.translate("Undo_Select") ?? "Undo_Select",),//
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          ...currentResponse!['folders'].map<Widget>((folder) {
                            final isExpanded = expandedElement == folder;
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () => navigateToFolder(folder['id']),
                                  child: ListTile(
                                    leading: Icon(Icons.folder, color: Colors.yellow[700]),
                                    title: Text(folder['folderName']),
                                  ),
                                ),
                                if (isExpanded)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text('Folder details here'),
                                  ),
                              ],
                            );
                          }).toList(),
                          ...currentResponse!['documents'].map<Widget>((document) {
                            final isExpanded = expandedElement == document;
                            final isSelected = selectedFiles.contains(document['id']);
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      expandedElement = isExpanded ? null : document;
                                    });
                                  },
                                  child: ListTile(
                                    leading: document['locked'] == false
                                        ? Checkbox(
                                      value: isSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          if (value == true) {
                                            selectedFiles.add(document['id']);
                                          } else {
                                            selectedFiles.remove(document['id']);
                                          }
                                        });
                                      },
                                    )
                                        : null,
                                    title: document['locked'] == false
                                        ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            document['subject'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: document['locked']
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            getTempFile(document['vsid']).then((value) {
                                              if (value != 'something went wrong') {
                                                downloadFile(value);
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Cannot download file'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // تقليل الحشو الداخلي
                                            minimumSize: const Size(10, 30), // تحديد الحد الأدنى للأبعاد
                                          ),                                          icon: const Icon(Icons.download_outlined),
                                          label:  Text(AppLocalization.of(context)!.translate("Download") ?? "Download",),


                                        )
                                        ,
                                      ],
                                    )
                                        : Text(
                                      document['subject'],
                                      style: TextStyle(
                                        color: document['locked'] ? Colors.red : Colors.green,
                                      ),
                                    ),
                                    trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                                  ),
                                ),
                                if (isExpanded)
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Details: ${document['note'] ?? 'No details available'}',
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Date modified: ${DateFormat('yyyy-MM-dd – hh:mm a').format(DateTime.parse(document['creationDate']))}',
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: selectedFiles.isNotEmpty
          ? FloatingActionButton.extended(
        onPressed: () => checkInSelectedFiles(),
        label: Text(loading == false ? AppLocalization.of(context)!.translate("Check_In_Selected") ?? "Check_In_Selected" :AppLocalization.of(context)!.translate("Checking_in") ?? "Checking_in",),//
        icon: const Icon(Icons.check_circle),
      )
          : null,
    );
  }

}
