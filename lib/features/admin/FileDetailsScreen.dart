import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FileDetailsScreen extends StatefulWidget {
  final String vsid;

  const FileDetailsScreen({required this.vsid});

  @override
  _FileDetailsScreenState createState() => _FileDetailsScreenState();
}

class _FileDetailsScreenState extends State<FileDetailsScreen> {
  int _currentPage = 0;
  int _pageSize = 4;
  bool _isLoading = false;
  bool _hasMore = true;
  List<dynamic> _logs = [];

  Future<void> _fetchLogs() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    final response = await http.get(Uri.parse(
        'http://localhost:8091/document-log/log-document-admin?vsId=${widget.vsid}&size=$_pageSize&start=$_currentPage'));

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
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _logs.isEmpty && !_isLoading
            ? Center(
          child: Text(
            'No logs available.',
            style: GoogleFonts.roboto(fontSize: 16),
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        'Action: ${log['action']}',
                        style: GoogleFonts.roboto(fontSize: 16),
                      ),
                      subtitle: Text(
                        'User: ${log['relatedUser']}',
                        style: GoogleFonts.roboto(fontSize: 14),
                      ),
                      trailing: Text(
                        log['creationDate'],
                        style: GoogleFonts.roboto(fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_hasMore)
              ElevatedButton(
                onPressed: _fetchLogs,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Load More'),
              ),
          ],
        ),
      ),
    );
  }
}
