// lib/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:folder_it/features/Home/data/models/file_DataModel.dart';
import 'package:folder_it/core/Util/general_widgets/DropZoneWidget.dart';
import 'package:folder_it/core/Util/general_widgets/DroppedFileWidget.dart';

class MyFilePage extends StatefulWidget {
  const MyFilePage({super.key});

  @override
  State<MyFilePage> createState() => _MyFilePageState();
}

class _MyFilePageState extends State<MyFilePage> {
  File_Data_Model?file;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body:  SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: DropZoneWidget(
                  onDroppedFiles: (droppedFiles) => setState(() => droppedFiles)),
                ),
              
              const SizedBox(height: 20),
             // DroppedFileWidget(file: file),
              
            ],
          ),
        ),
      ),
    );
  }
}
