import 'package:flutter/material.dart';
import 'package:folder_it/features/Group_Browser/presentation/group_pages/upload_files_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../../core/databases/cache/cache_helper.dart';

class BrowsePage extends StatefulWidget {
  final int groupId;
  final int userId;
  final int folderId;

  BrowsePage({super.key, required this.groupId, required this.userId, required this.folderId});

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  Map<String, dynamic>? currentResponse;
  dynamic expandedElement; // العنصر المفتوح
  List<Map<String, dynamic>> history = [];

  Future<Map<String, dynamic>> fetchFolderContent({required int parentId}) async {
    if (currentResponse != null) return currentResponse!; // استخدام البيانات المحملة مسبقاً

    final String? token = CacheHelper().getData(key: 'token');
    if (token == null) {
      throw Exception('Token is missing!');
    }

    final url = Uri.parse('http://localhost:8091/folder/content?parentId=$parentId&userId=${widget.userId}');
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

  Future<void> checkInFile(int fileId) async {
    final url = Uri.parse('http://localhost:8091/document/check-in');
    final int myId = CacheHelper().getData(key: "myid") ?? 1;
    final String? token = CacheHelper().getData(key: 'token');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    };

    final request = http.MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..fields['id'] = fileId.toString()
      ..fields['userId'] = myId.toString();

    try {
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        setState(() {
          expandedElement['locked'] = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File checked in successfully!'), backgroundColor: Colors.green),
        );
      } else {
        throw Exception('Failed to check in file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to check in file');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,

        actions: [
          Tooltip(message: "add new file",
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UploadFilesPage(groupId: widget.groupId, folderId: widget.folderId),
                  ),
                );
              },
              icon: const Icon(Icons.add_box_outlined, color: Colors.white),
              label: const Text('Add file', style: TextStyle(color: Colors.white)),
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

            return ListView(
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
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            expandedElement = isExpanded ? null : document;
                          });
                        },
                        child: ListTile(
                          leading: Icon(
                            Icons.insert_drive_file,
                            color: document['locked'] == true ? Colors.red : Colors.green,
                          ),
                          title: Text(document['subject']),
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
                                style:  TextStyle(color: Theme.of(context).primaryColor,fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Date modified: ${DateFormat('yyyy-MM-dd – hh:mm a').format(DateTime.parse(document['creationDate']))}',
                                style:  TextStyle(color: Theme.of(context).primaryColor,fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    document['locked'] ? Icons.lock : Icons.lock_open,
                                    color: document['locked'] ? Colors.red : Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    document['locked'] ? 'File is locked' : 'File is not locked',
                                    style: TextStyle(
                                      color: document['locked'] ? Colors.red : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              if (document['locked'] == false)
                                ElevatedButton.icon(
                                  onPressed: () {
                                    checkInFile(document['id']);
                                  },
                                  icon: const Icon(Icons.check_circle_outline),
                                  label: const Text('Check In'),
                                ),
                            ],
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ],
            );
          }
        },
      ),
    );
  }
}
