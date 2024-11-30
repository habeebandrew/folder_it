import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BrowsePage extends StatefulWidget {
  BrowsePage({super.key});
  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  final Map<String, dynamic> initialResponse = {
    "folders": [
      {
        "id": 10,
        "parentId": 9,
        "folderName": "second folder",
        "creator": 1,
        "restricted": false,
        "creationDate": "2024-11-22T12:45:35.019+0000"
      },
      {
        "id": 11,
        "parentId": 9,
        "folderName": "first folder",
        "creator": 1,
        "restricted": false,
        "creationDate": "2024-11-22T12:45:35.019+0000"
      }
    ],
    "documents": [
      {
        "id": 4,
        "subject": "file",
        "mimeType": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "note": "upload my file",
        "creator": 1,
        "majorVersion": 1,
        "minorVersion": 0,
        "currentVersion": true,
        "isVersion": true,
        "locked": false,
        "lockedBy": null,
        "modifiedBy": null,
        "creationDate": "2024-11-22T12:46:56.470+0000",
        "modifiedDate": null,
        "finishedDate": null,
        "recordStatus": true,
        "vsid": "5c16a33a-79a2-466c-8b3e-602fcc1b1ef3"
      },
      {
        "id": 5,
        "subject": "file",
        "mimeType": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "note": "upload my second file",
        "creator": 1,
        "majorVersion": 1,
        "minorVersion": 0,
        "currentVersion": true,
        "isVersion": true,
        "locked": false,
        "lockedBy": null,
        "modifiedBy": null,
        "creationDate": "2024-11-22T12:47:56.470+0000",
        "modifiedDate": null,
        "finishedDate": null,
        "recordStatus": true,
        "vsid": "7d7b8a88-25b2-4a2e-8765-d59a1acb08a4"
      }
    ]
  };

  Map<String, dynamic>? currentResponse;
  dynamic selectedElement;
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    currentResponse = initialResponse;
  }

  void navigateToFolder(int folderId) {
    Map<String, dynamic> newResponse = {
      "folders": [
        {
          "id": 20,
          "parentId": folderId,
          "folderName": "subfolder 1",
          "creator": 2,
          "restricted": false,
          "creationDate": "2024-11-23T12:45:35.019+0000"
        },
        {
          "id": 21,
          "parentId": folderId,
          "folderName": "subfolder 2",
          "creator": 2,
          "restricted": false,
          "creationDate": "2024-11-23T12:45:35.019+0000"
        }
      ],
      "documents": [
        {
          "id": 6,
          "subject": "subfile",
          "mimeType": "application/pdf",
          "note": "subfile details",
          "creator": 2,
          "majorVersion": 1,
          "minorVersion": 0,
          "currentVersion": true,
          "isVersion": true,
          "locked": false,
          "lockedBy": null,
          "modifiedBy": null,
          "creationDate": "2024-11-23T12:46:56.470+0000",
          "modifiedDate": null,
          "finishedDate": null,
          "recordStatus": true,
          "vsid": "8e16b33a-79a2-466c-8b3e-602fcc1b1ef4"
        }
      ]
    };

    setState(() {
      history.add(currentResponse!);
      currentResponse = newResponse;
      selectedElement = null;
    });
  }

  void goBack() {
    if (history.isNotEmpty) {
      setState(() {
        currentResponse = history.removeLast();
        selectedElement = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                  "Folders & Files",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // المحتوى الرئيسي
          Expanded(
            child: Row(
              children: [
                // الشجرة الجانبية
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
                              return InkWell(
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
                        : Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: // داخل تفاصيل الملف في حالة وجود عنصر محدد:
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedElement['subject'] ?? selectedElement['folderName'],
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                              'Details: ${selectedElement['note'] ?? 'No details available'}'),
                          const SizedBox(height: 8),
                          Text(
                            'Created on: ${DateFormat('yyyy-MM-dd – hh:mm a').format(DateTime.parse(selectedElement['creationDate']))}',
                          ),
                          const SizedBox(height: 16),
                          // إضافة حالة الحجز
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
      ),
    );
  }
}
