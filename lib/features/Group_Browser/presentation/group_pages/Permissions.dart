import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../core/databases/cache/cache_helper.dart';

class Permissions extends StatefulWidget {
  final int groupId;
  const Permissions({super.key, required this.groupId});

  @override
  State<Permissions> createState() => _PermissionsState();
}

class _PermissionsState extends State<Permissions> {
  late Future<List<DocumentModel>> _documents;

  @override
  void initState() {
    super.initState();
    _documents = fetchDocuments(widget.groupId);
  }

  Future<List<DocumentModel>> fetchDocuments(int groupId) async {
    String mytoken = CacheHelper().getData(key: 'token');

    final url =
        'http://localhost:8091/document-folder/fetch-documents-unaccepted-yet?groupId=$groupId';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': "Bearer $mytoken",
    });

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => DocumentModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load documents');
    }
  }

  Future<void> updateDocumentStatus(int id, int status) async {
    String mytoken = CacheHelper().getData(key: 'token');

    final url = 'http://localhost:8091/document-folder/accept-or-reject-document';

    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers['Authorization'] = "Bearer $mytoken"
      ..fields['id'] = id.toString()
      ..fields['statusDocument'] = status.toString();

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Document updated successfully');
        setState(() {
          _documents = fetchDocuments(widget.groupId);
        });
      } else {
        print('Failed to update document: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder<List<DocumentModel>>(
        future: _documents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No documents found'));
          }

          final documents = snapshot.data!;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${document.id}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Creation Date: ${document.creationDate}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Document Subject: ${document.document.subject}'),
                      const SizedBox(height: 8),
                      Text('Note: ${document.document.note}'),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,

                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                  updateDocumentStatus(document.id, 2);
                              },
                              child: const Text('Approve'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                updateDocumentStatus(document.id, 3);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Reject'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DocumentModel {
  final int id;
  final String creationDate;
  final int groupId;
  final DocumentDetails document;

  DocumentModel({
    required this.id,
    required this.creationDate,
    required this.groupId,
    required this.document,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      creationDate: json['creationDate'],
      groupId: json['groupId'],
      document: DocumentDetails.fromJson(json['document']),
    );
  }
}

class DocumentDetails {
  final int id;
  final String subject;
  final String note;

  DocumentDetails({
    required this.id,
    required this.subject,
    required this.note,
  });

  factory DocumentDetails.fromJson(Map<String, dynamic> json) {
    return DocumentDetails(
      id: json['id'],
      subject: json['subject'],
      note: json['note'],
    );
  }
}
