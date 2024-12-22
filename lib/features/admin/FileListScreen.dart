import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

import 'FileDetailsScreen.dart';
//Todo:تحسين تصميم
class FileListScreen extends StatefulWidget {
  @override
  _FileListScreenState createState() => _FileListScreenState();
}

class _FileListScreenState extends State<FileListScreen> {
  int _currentPage = 0;
  int _pageSize = 3; // عدد العناصر الجديدة لكل تحميل
  bool _isLoading = false;
  bool _hasMore = true;
  List<dynamic> _files = [];

  Future<void> _fetchFiles() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    final response = await http.get(Uri.parse(
        'http://localhost:8091/document/fetch-all-files?size=$_pageSize&start=$_currentPage'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> fetchedFiles = data['list'];

      setState(() {
        _currentPage += _pageSize;
        _files.addAll(fetchedFiles);
        _hasMore = fetchedFiles.length == _pageSize; // إذا كان العدد أقل من _pageSize يعني انتهاء البيانات
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _fetchFiles();
  }

  void _viewDetails(String vsid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FileDetailsScreen(vsid: vsid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'File List',
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _files.isEmpty && !_isLoading
            ? Center(
          child: Text(
            'No files available.',
            style: GoogleFonts.roboto(fontSize: 16),
          ),
        )
            : ListView.builder(
          itemCount: _files.length + 1, // +1 للزر "Load More"
          itemBuilder: (context, index) {
            if (index == _files.length) {
              // العنصر الأخير هو زر "Load More"
              return _hasMore
                  ? Center(
                child: ElevatedButton(
                  onPressed: _fetchFiles,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text('Load More'),
                ),
              )
                  : const SizedBox(); // إخفاء الزر عند انتهاء البيانات
            }

            return _buildFileCard(_files[index]);
          },
        ),
      ),
    );
  }

  Widget _buildFileCard(dynamic file) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: ListTile(
        title: Text(
          file['subject'],
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          file['note'],
          style: GoogleFonts.roboto(fontSize: 14),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _viewDetails(file['vsid']),
      ),
    );
  }
}
