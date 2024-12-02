import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:folder_it/features/Home/data/models/file_DataModel.dart';

class DroppedFileWidget extends StatelessWidget {
  final File_Data_Model? file;
  final VoidCallback? onSendFile;
  final VoidCallback? onCancelFile;

  const DroppedFileWidget({
    super.key, 
    required this.file, 
    required this.onSendFile, 
    required this.onCancelFile,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: file == null
            ? buildEmptyFile('No Selected File')
            : buildFileWithActions(context),
      ),
    );
  }

  Widget buildFileWithActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildFileDetail(file, context),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: onSendFile,
              icon: const Icon(Icons.cloud_upload, color: Colors.white),
              label: const Text(
                'Send File',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            ElevatedButton.icon(
              onPressed: onCancelFile,
              icon: const Icon(Icons.cancel, color: Colors.white),
              label: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ],
        ),
      ],
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

  Widget buildFileDetail(File_Data_Model? file, BuildContext context) {
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
