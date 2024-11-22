import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:folder_it/features/Home/data/models/file_DataModel.dart';

class DropZoneWidget extends StatefulWidget {
  final ValueChanged<List<File_Data_Model>> onDroppedFiles;

  const DropZoneWidget({super.key, required this.onDroppedFiles});

  @override
  State<DropZoneWidget> createState() => _DropZoneWidgetState();
}

class _DropZoneWidgetState extends State<DropZoneWidget> {
  late DropzoneViewController controller;
  bool highlight = false;

  @override
  Widget build(BuildContext context) {
    return buildDecoration(
      child: Stack(
        children: [
          DropzoneView(
            
            onCreated: (controller) => this.controller = controller,
            onDropFiles:  (value)=>UploadedFiles(value!) ,
            onHover: () => setState(() => highlight = true),
            onLeave: () => setState(() => highlight = false),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_upload_outlined, size: 80, color: Colors.grey),
                const Text(
                  'Drop Files Here',
                  style: TextStyle(color: Colors.grey, fontSize: 24),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    final events = await controller.pickFiles(multiple: true);
                    if (events.isEmpty) return;
                    UploadedFiles(events);
                  },
                  icon: const Icon(Icons.search,color: Colors.white,),
                  label: Text('Choose Files',style: Theme.of(context).textTheme.bodyMedium,),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    backgroundColor: highlight ? const Color(0xFF2E5F76) : const Color(0Xff0b3153),
                    shape: const RoundedRectangleBorder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future UploadedFiles(List<dynamic> events) async {
    List<File_Data_Model> droppedFiles = [];

    for (var event in events) {
      final name = event.name;
      final mime = await controller.getFileMIME(event);
      final byte = await controller.getFileSize(event);
      final url = await controller.createFileUrl(event);

      print('Name: $name');
      print('Mime: $mime');
      print('Size: ${byte / (1024 * 1024)} MB');
      print('URL: $url');

      droppedFiles.add(File_Data_Model(name: name, mime: mime, bytes: byte, url: url));
    }

    widget.onDroppedFiles(droppedFiles);
    setState(() {
      highlight = false;
    });
  }

  Widget buildDecoration({required Widget child}) {
    final colorBackground = highlight ? const Color(0xFF2E5F76) : Colors.white;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: colorBackground,
        child: DottedBorder(
          borderType: BorderType.RRect,
          color: const Color(0Xff0b3153),
          strokeWidth: 3,
          dashPattern: const [8, 4],
          radius: const Radius.circular(10),
          padding: EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}
