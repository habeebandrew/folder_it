import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

import 'FileDetailsScreen.dart';

class FileListScreen extends StatefulWidget {
  @override
  _FileListScreenState createState() => _FileListScreenState();
}

class _FileListScreenState extends State<FileListScreen> {
  int _currentPage = 0;
  int _pageSize = 3;
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
        _hasMore = fetchedFiles.length == _pageSize;
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
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

        title: Text(
          'File List',
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: _files.isEmpty && !_isLoading
              ? Center(
            child: Text(
              'No files available.',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.blueGrey,
              ),
            ),
          )
              : ListView.builder(
            itemCount: _files.length + 1,
            itemBuilder: (context, index) {
              if (index == _files.length) {
                return _hasMore
                    ? Center(
                  child: OutlinedButton(
                    onPressed: _fetchFiles,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.blue,
                    )
                        : Text(
                      'Load More',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                    : const SizedBox();
              }
              return _buildFileCard(_files[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFileCard(dynamic file) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _viewDetails(file['vsid']),
        child: Row(
          children: [
            // صورة مصغرة
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/icons/favicon.png'), // ضع هنا مسار الصورة الصحيح
                  fit: BoxFit.fill, // لجعل الصورة تغطي الحاوية بالكامل
                ),
              ),
            ),

            // تفاصيل الملف
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file['subject'],
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      file['note'],
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // أيقونة
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
