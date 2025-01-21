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

  // خريطة لتحويل قيمة action إلى النص المطلوب
  final Map<int, String> _actionDescriptions = {
    1: 'CheckIn',
    2: 'CancelCheckIn',
    3: 'CheckOut',
    4: 'ViewDocument',
    5: 'CreateNewDocument',
  };

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
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'File Details',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
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
                  // الحصول على الوصف بناءً على قيمة action
                  final actionValue = int.tryParse(log['action'].toString()) ?? 0;
                  final actionDescription =
                      _actionDescriptions[actionValue] ?? 'Unknown Action';

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF121212),
                        child: Icon(
                          Icons.event_note,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        'Action: $actionDescription',
                        style: GoogleFonts.roboto(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        'User: ${log['relatedUser']}\nDate: ${log['creationDate']}',
                        style: GoogleFonts.roboto(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            if (_hasMore && !_isLoading)
              ElevatedButton.icon(
                onPressed: _fetchLogs,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF121212),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Load More'),
              ),
            if (!_hasMore)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'You have reached the end of the logs.',
                  style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
