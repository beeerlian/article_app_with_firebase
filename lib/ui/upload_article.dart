import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:slicing_ios_article_app/api/firebase_api.dart';

class UploadPage extends StatefulWidget {
  UploadTask? task;
  File? file;
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  Widget build(BuildContext context) {
    final filename = widget.file != null ? widget.file?.path : "None selected";
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              child: Text("Select Image"),
              onPressed: selectImage,
            ),
            Text(filename!),
            FlatButton(
              child: Text("Upload"),
              onPressed: (){
                uploadImage();
              },
            
            ),
            widget.task==null? Container(): uploadProgress(widget.task as dynamic),
          ],
        ),
      ),
    );
  }
  Widget uploadProgress(UploadTask task) {
    return StreamBuilder<TaskSnapshot>(stream: task.snapshotEvents,builder: (context, snapshot){
      if(snapshot.hasData){
        final snapdata = snapshot.data;

        return Text((snapdata!.bytesTransferred/snapdata.totalBytes).toString(),);
      }
      else return Container();
    });
  }

  Future uploadImage() async {
    if (widget.file == null) return;

    final filename = path.basename(widget.file!.path);
    final destination = 'article/$filename';

    widget.task = FirebaseApi.uploadFile(
        file: widget.file as dynamic, destination: destination);
    
    if (widget.task==null) return;

    final snapshot = await widget.task!.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    print(downloadUrl);
  }

  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;

    setState(() => widget.file = File(path as dynamic));
  }
}
