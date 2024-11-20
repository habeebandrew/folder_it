import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:folder_it/features/Home/data/models/file_DataModel.dart';

class DroppedFileWidget extends StatelessWidget {
  final File_Data_Model? file;
  const DroppedFileWidget({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: file == null ? buildEmptyFile('No Selected File') : buildFile(context),
      ),
    );
  }

  Widget buildFile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (file != null) buildFileDetail(file),
        const SizedBox(height: 20),
        if (file!.mime.contains('pdf') || file!.mime.contains('text'))
          buildFileActions(context),
        if (file!.mime.contains('image')) buildImagePreview(context),
      ],
    );
  }

  Widget buildFileActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'File Actions:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () async {
            html.window.open(
              'viewer.html?file=${Uri.encodeComponent(file!.url)}','_blank',
            );
          },
          icon: const Icon(Icons.open_in_new, color: Colors.white),
          label: const Text('Open File',style: TextStyle(color: Colors.white),),

          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: Colors.blueAccent,
            
          ),
        ),
      ],
    );
  }

  Widget buildImagePreview(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        file!.url,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, _) => buildEmptyFile('No Preview Available'),
      ),
    );
  }

  Widget buildEmptyFile(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildFileDetail(File_Data_Model? file) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected File Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('Name: ${file?.name}', style: const TextStyle(fontSize: 16)),
            Text('Type: ${file?.mime}', style: const TextStyle(fontSize: 16)),
            Text('Size: ${file?.size}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            SelectableText(
              'URL: ${file?.url}',
              style: const TextStyle(color: Colors.blue, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}