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

  BrowsePage({super.key, required this.groupId, required this.userId,required this.folderId});

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  Map<String, dynamic>? currentResponse;
  dynamic selectedElement;
  List<Map<String, dynamic>> history = [];

  Future<Map<String, dynamic>> fetchFolderContent({required int parentId}) async {

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
        selectedElement = null;
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
        selectedElement = null;
      });
    }
  }
//Todo:check in
  Future<void> checkInFile(int fileId) async {
    final url = Uri.parse('http://localhost:8091/document/check-in');
    final int myId = CacheHelper().getData(key: "myid") ?? 1;
    final String? token = CacheHelper().getData(key: 'token');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    };

    // بناء الطلب باستخدام MultipartRequest
    final request = http.MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..fields['id'] = fileId.toString()
      ..fields['userId'] = myId.toString();

    try {
      final response = await request.send();

      // انتظر استجابة الطلب
      final responseData = await http.Response.fromStream(response);

      print(response.statusCode);
      print(responseData.body);

      if (response.statusCode == 200) {
        setState(() {
          selectedElement['locked'] = true; // تحديث الحالة إلى محجوزة
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File checked in successfully!'),backgroundColor: Colors.green,),
        );
      } else {
        throw Exception('Failed to check in file: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to check in file');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchFolderContent(parentId: widget.folderId), // تحميل المحتوى الأساسي
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          } else {
            currentResponse = snapshot.data;

            return Column(
              children: [
                Container(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      if (history.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: goBack,
                        ),
                      const SizedBox(width: 8),
                      const Text(
                        "Files",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Tooltip(
                          message: 'Add new file',
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context)=>UploadFilesPage(groupId: widget.groupId, folderId: widget.folderId),
                              ));
                            },
                            icon: Icon(
                              Icons.add_box_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                            label: Text( 'Add file',
                                style: Theme.of(context).textTheme.displayMedium),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
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
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 250,
                        padding: const EdgeInsets.all(16),
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  ...currentResponse!["folders"].map<Widget>((folder) {
                                    return InkWell(
                                      onTap: () => navigateToFolder(folder['id']),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                        child: Row(
                                          children: [
                                            Icon(Icons.folder, color: Colors.yellow[700]),
                                            const SizedBox(width: 8),
                                            Text(folder['folderName'],
                                                style: const TextStyle(color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  const Divider(color: Colors.white),
                                  ...currentResponse!["documents"].map<Widget>((document) {
                                    return Tooltip(
                                      message: "press to show details",
                                      child: InkWell(
                                        onTap: () => setState(() {
                                          selectedElement = document;
                                        }),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.insert_drive_file, color: Colors.white),
                                              const SizedBox(width: 8),
                                              Text(document['subject'],
                                                  style: const TextStyle(color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // التفاصيل
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
          // الكود المعدل
          child: selectedElement == null
          ? currentResponse!["folders"].isEmpty &&
          currentResponse!["documents"].isEmpty
          ? const Center(
          child: Text(
          "This folder is empty",
          style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold),
          ),
          )
              : const Center(
          child: Text(
          "Select a folder or file to view details",
          style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold),
          ),
          )
              :Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عرض أيقونة وفوقها اسم الملف أو اسم المجلد
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          selectedElement['folderName'] != null
                              ? Icons.folder
                              : Icons.insert_drive_file,
                          color: selectedElement['folderName'] != null
                              ? Colors.yellow[700]
                              : Colors.grey,
                          size: 64,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          selectedElement['subject'] ?? selectedElement['folderName'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // عرض تفاصيل عامة
                  const Divider(),
                  Text(
                    'Details:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedElement['note'] ?? 'No details available',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),


                  const SizedBox(height: 16),
                  Text(
                    'Date modified:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('yyyy-MM-dd – hh:mm a')
                        .format(DateTime.parse(selectedElement['creationDate'])),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  // حالة القفل
                  if (selectedElement['locked'] != null)
                    Row(
                      children: [
                        Icon(
                          selectedElement['locked']
                              ? Icons.lock
                              : Icons.lock_open,
                          color: selectedElement['locked'] ? Colors.red : Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          selectedElement['locked']
                              ? 'File is currently locked'
                              : 'File is not locked',
                          style: TextStyle(
                            color: selectedElement['locked'] ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  // زر Check In
                  if (selectedElement['locked'] == false)
                    ElevatedButton.icon(
                      onPressed: () {print(selectedElement['id']);

                      // وظيفة Check In
                        checkInFile(selectedElement['id']);
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Check In'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),

                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
