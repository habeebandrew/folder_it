// lib/presentation/pages/home_page.dart
// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:folder_it/features/Home/data/models/file_DataModel.dart';
import 'package:folder_it/core/Util/general_widgets/DropZoneWidget.dart';
import 'package:folder_it/core/Util/general_widgets/DroppedFileWidget.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

class UploadFilesPage extends StatefulWidget {
  final int groupId;
  
  final int folderId;

  const UploadFilesPage({super.key,required this.groupId,required this.folderId});

  @override
  State<UploadFilesPage> createState() => _MyFilePageState();
}

class _MyFilePageState extends State<UploadFilesPage> {
  File_Data_Model?file ;

  Future<void> uploadBlobFileToServer({required int userId,required String note,required int groupId,required int folderId,required File_Data_Model file}) async {
  try {
   
    final url = Uri.parse('http://127.0.0.1:8091/document/upload'); 

    final html.Blob blob = await html.window.fetch(file.url).then((response) => response.blob());

    
    final reader = html.FileReader();
    reader.readAsArrayBuffer(blob);

  
    await reader.onLoadEnd.first;

    final Uint8List fileBytes = reader.result as Uint8List;
    
    String token= CacheHelper().getData(key: 'token');
    print(userId);
    print(token);

    
    var headers = {
     'Authorization': 'Bearer $token',
     'Content-Type': 'application/x-www-form-urlencoded',
     'Accept': 'application/json',
    };
    var request = http.MultipartRequest('POST', url);
    
    request.fields.addAll({
      'creatorId': '$userId',
      'note': note,
      'folderId': '$folderId',
      'groupId': '$groupId'
    });
    // إضافة الملف باستخدام fromBytes
    request.files.add(
      http.MultipartFile.fromBytes(
        'file', 
        fileBytes,
        filename: file.name, 
      ),
    );
    request.headers.addAll(headers);
    
    http.StreamedResponse response = await request.send();
    var res =await response.stream.bytesToString();
    
    if (response.statusCode == 200) {
      print(res);
      print('File uploaded successfully');
    } else {
      print(res);
      print('Failed to upload file: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading file: $e');
  }
}
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
                  onDroppedFiles: (file) => setState(() => this.file=file)),
                ),
              const SizedBox(height: 20),
               DroppedFileWidget(
                file: file,
                onSendFile: (){
                  if (file != null) {
                    uploadBlobFileToServer(userId:CacheHelper().getData(key: 'myid'),note:'upload my file' ,groupId:widget.groupId ,folderId:widget.folderId ,file: file!);
                 }
                },
                onCancelFile: (){
                    setState(() {
                     file = null;
                    });
                },
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
