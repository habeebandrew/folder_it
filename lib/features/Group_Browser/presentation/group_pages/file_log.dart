import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'dart:convert';

enum FileActions {
  checkIn,
  cancelCheckIn,
  checkOut,
  viewDocument,
  createNewDocument,
}

class FileLog extends StatefulWidget {
  final String vsid;
  final String fileName;

  const FileLog({super.key, required this.vsid, required this.fileName});

  @override
  State<FileLog> createState() => _FileLogState();
}

class _FileLogState extends State<FileLog> {
  int _currentPage = 0;
  final int _pageSize = 4;
  bool _isLoading = false;
  bool _hasMore = true;
  final List<dynamic> _logs = [];

  Future<void> _fetchLogs() async {
    final String? token = CacheHelper().getData(key: 'token');
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    final response = await http.get(
        Uri.parse(
            'http://localhost:8091/document-log/log-document?vsId=${widget.vsid}&size=$_pageSize&start=$_currentPage'),
        headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> fetchedLogs = data['list'];

      setState(() {
        _currentPage += _pageSize;
        _logs.addAll(fetchedLogs);
        _hasMore = fetchedLogs.length == _pageSize;
      });
    }

    setState(() => _isLoading = false);
  }

  void exportToCSV(List<dynamic> logs) {
    List<List<dynamic>> rows = [];
    rows.add(["Action", "User", "Date"]);

    for (var log in logs) {
      rows.add([log['action'] == 1 ? FileActions.values[0].name : log['action'] == 2 ? FileActions.values[1].name : log['action'] == 3 ? FileActions.values[2].name : log['action'] == 4 ? FileActions.values[3].name :log['action'] == 5 ? FileActions.values[4].name:'', log['relatedUser'], log['creationDate']]);
    }

    String csv = const ListToCsvConverter().convert(rows);
    final blob = html.Blob([csv], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url);
    anchor.setAttribute('download', '${widget.fileName} log.csv');
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
              pw.Text('${widget.fileName} Log', style: const pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ["Action", "User", "Date"],
                data: logs
                    .map((log) => [
                          log['action'] == 1 ? FileActions.values[0].name : log['action'] == 2 ? FileActions.values[1].name : log['action'] == 3 ? FileActions.values[2].name : log['action'] == 4 ? FileActions.values[3].name :log['action'] == 5 ? FileActions.values[4].name:'',
                          log['relatedUser'],
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
      anchor.setAttribute('download', '${widget.fileName} logs.pdf');
      anchor.click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'File Details',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'export option',
            offset: const Offset(0, 40), 
            onSelected: (value) {
              if (value == 'csv' && _logs.isNotEmpty) {
                exportToCSV(_logs);
              } else if (value == 'pdf' && _logs.isNotEmpty) {
                exportToPDF(_logs);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _logs.isEmpty && !_isLoading
            ? Center(
                child: Text(
                  'No logs available.',
                  style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        final log = _logs[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(
                                Icons.event_note,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              'Action: ${log['action'] == 1 ? FileActions.values[0].name : log['action'] == 2 ? FileActions.values[1].name : log['action'] == 3 ? FileActions.values[2].name : log['action'] == 4 ? FileActions.values[3].name :log['action'] == 5 ? FileActions.values[4].name:''}',
                              style: GoogleFonts.roboto(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              'User: ${log['relatedUser']}\nDate: ${DateFormat('yyyy-MM-dd – hh:mm a').format(DateTime.parse(log['creationDate']))}',
                              style: GoogleFonts.roboto(fontSize: 14),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (_hasMore && !_isLoading)
                    ElevatedButton.icon(
                      onPressed: _fetchLogs,
                      style: Theme.of(context).elevatedButtonTheme.style,
                      icon: const Icon(Icons.add),
                      label: const Text('Load More'),
                    ),
                  // if (_logs.isNotEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 16.0),
                  //     child: Card(
                  //       elevation: 6,
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(16.0),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //           children: [
                  //             ElevatedButton.icon(
                  //               onPressed: () {
                  //                 exportToCSV(_logs);
                  //               },
                  //               style:
                  //                   Theme.of(context).elevatedButtonTheme.style,
                  //               icon: const Icon(Icons.download),
                  //               label: const Text('Export to CSV'),
                  //             ),
                  //             ElevatedButton.icon(
                  //               onPressed: () {
                  //                 exportToPDF(_logs);
                  //               },
                  //               style:
                  //                   Theme.of(context).elevatedButtonTheme.style,
                  //               icon: const Icon(Icons.picture_as_pdf),
                  //               label: const Text('Export to PDF'),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  if (!_hasMore)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'You have reached the end of the logs.',
                        style: GoogleFonts.roboto(
                            fontSize: 14, color: Colors.grey),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
