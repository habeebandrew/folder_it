import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';

class MembersLog extends StatefulWidget {
  final int userId;
  final String userName;
  final int groupId;

  const MembersLog({super.key, required this.userId, required this.userName, required this.groupId});

  @override
  State<MembersLog> createState() => _MembersLogState();
}

class _MembersLogState extends State<MembersLog> {
  final int pageSize = 3; // عدد الأسطر في كل صفحة
  int currentPage = 0; // الصفحة الحالية
  List<dynamic> logs = [];
  int totalRows = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserLogs();
  }

  Future<void> fetchUserLogs() async {
    final String token = CacheHelper().getData(key: 'token');
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        'http://localhost:8091/user-log/user-log-owner?size=$pageSize&start=$currentPage&userId=${widget.userId}&groupId=${widget.groupId}');
    try {
      final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalRows = data['extraData'];
          logs.addAll(data['list']);
        });
      } else {
        throw Exception('Failed to load user logs');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void loadMore() {
    if (logs.length < totalRows) {
      currentPage++;
      fetchUserLogs();
    }
  }
    void exportToCSV(List<dynamic> logs) {
    List<List<dynamic>> rows = [];
    rows.add(["Action" , "Date"]);

    for (var log in logs) {
      rows.add([log['logNote'] , log['creationDate']]);
    }

    String csv = const ListToCsvConverter().convert(rows);
    final blob = html.Blob([csv], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url);
    anchor.setAttribute('download', '${widget.userName} log.csv');
    anchor.click();
    html.Url.revokeObjectUrl(url);
  }

  void exportToPDF(List<dynamic> logs) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('${widget.userName} Log', style: const pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ["Action","Date"],
                data: logs
                    .map((log) => [
                          log['logNote'],
                          log['creationDate']
                        ])
                    .toList(),
              ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url);
      anchor.setAttribute('download', '${widget.userName} logs.pdf');
      anchor.click();
    html.Url.revokeObjectUrl(url);
  }

  Widget buildLogCard(Map<String, dynamic> log) {
    String formattedDate = DateFormat('yyyy-MM-dd – hh:mm a')
        .format(DateTime.parse(log['creationDate']));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4, // Add shadow for a better look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.event_note,
                  color: Colors.blue.shade700,
                ),
              ],
            ),
            const Divider(), // Add a divider for better separation
            const SizedBox(height: 8),
            Text(
              'Date: $formattedDate',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Note: ${log['logNote'] ?? "No notes available"}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('${widget.userName} Log'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'export option',
            offset: const Offset(0, 40), 
            onSelected: (value) {
              if (value == 'csv' && logs.isNotEmpty) {
                exportToCSV(logs);
              } else if (value == 'pdf' && logs.isNotEmpty) {
                exportToPDF(logs);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                 PopupMenuItem<String>(
                  value: 'csv',
                  child: Row(
                    children: [
                      Icon(Icons.file_copy_outlined,color: Theme.of(context).primaryColor,),
                      const Text('Export to CSV'),
                    ],
                  ),
                ),
                 PopupMenuItem<String>(
                  value: 'pdf',
                  child: Row(
                    children: [
                      Icon(Icons.picture_as_pdf_outlined,color: Theme.of(context).primaryColor,),
                      const Text('Export to PDF'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: logs.isEmpty && isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: logs.length + (logs.length < totalRows ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < logs.length) {
                        return buildLogCard(logs[index]);
                      } else {
                        return Center(
                          child: ElevatedButton(
                            onPressed: isLoading ? null : loadMore,
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Load More'),
                          ),
                        );
                      }
                    },
                  ),
                ),
                //if (isLoading) const CircularProgressIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }
}
