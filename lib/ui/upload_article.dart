import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:slicing_ios_article_app/services/authservices.dart';
import 'package:slicing_ios_article_app/services/database_services.dart';
import 'package:slicing_ios_article_app/services/firebase_api.dart';
import 'package:slicing_ios_article_app/streamcontroller/stream_page_controller.dart';

class STFUploadPage extends StatefulWidget {
  final User user;
  UploadTask? task;
  File? file;

  STFUploadPage({required this.user});
  @override
  _STFUploadPageState createState() => _STFUploadPageState();
}

class _STFUploadPageState extends State<STFUploadPage> {
  @override
  Widget build(BuildContext context) {
    final filename = widget.file != null ? widget.file?.path : "None selected";
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: firestore.title,
              decoration: InputDecoration(
                  hintText: "Title..", border: InputBorder.none),
            ),
            SizedBox(
              height: 500,
              child: TextField(
                controller: firestore.body,
                maxLines: 150,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Write your article here...",
                  border: InputBorder.none,
                ),
              ),
            ),
            FlatButton(
              child: Text("Select Image"),
              onPressed: selectImage,
            ),
            Text(filename!),
            FlatButton(
              child: Text("Upload"),
              onPressed: () async {
                try {
                  uploadImage();
                  String url = await uploadImage();
                  firestore.saveArticle(
                      title: firestore.title.text,
                      body: firestore.body.text,
                      url: url,
                      noPost: userActive!.noPost as dynamic,
                      authorEmail: widget.user.email.toString());
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                            child: Column(
                              children: [
                                Text("Sukses"),
                                FlatButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Finish"))
                              ],
                            ),
                          ));
                } catch (e) {}
              },
            ),
            widget.task == null
                ? Container()
                : uploadProgress(widget.task as dynamic),
          ],
        ),
      ),
    );
  }

  Widget uploadProgress(UploadTask task) {
    return StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snapdata = snapshot.data;

            return Text(
              (snapdata!.bytesTransferred / snapdata.totalBytes).toString(),
            );
          } else
            return Container();
        });
  }

  Future uploadImage() async {
    if (widget.file == null) return;

    final filename = path.basename(widget.file!.path);
    final destination = 'article/$filename';

    widget.task = FirebaseApi.uploadFile(
        file: widget.file as dynamic, destination: destination);

    if (widget.task == null) return;

    final snapshot = await widget.task!.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;

    setState(() => widget.file = File(path as dynamic));
  }
}

class UploadPage extends StatelessWidget {
  final User user;
  UploadTask? task;
  File? file;
  StreamController myFileStream = StreamController();
  UploadPage({required this.user});
  @override
  Widget build(BuildContext context) {
    String filename = "None selected";

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: firestore.title,
              decoration: InputDecoration(
                  hintText: "Title..", border: InputBorder.none),
            ),
            SizedBox(
              height: 500,
              child: TextField(
                controller: firestore.body,
                maxLines: 150,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Write your article here...",
                  border: InputBorder.none,
                ),
              ),
            ),
            FlatButton(
              child: Text("Select Image"),
              onPressed: selectImage,
            ),
            StreamBuilder(
                stream: myFileStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    filename = snapshot.data.toString();
                    return Text(filename);
                  } else
                    return Text(filename);
                }),
            FlatButton(
              child: Text("Upload"),
              onPressed: () async {
                try {
                  uploadImage();
                  String url = await uploadImage();
                  firestore.saveArticle(
                      title: firestore.title.text,
                      body: firestore.body.text,
                      url: url,
                      noPost: userActive!.noPost as dynamic,
                      authorEmail: user.email.toString());
                  myFileStream.close();
                  StreamState.move(StateEvent.to_home);
                } catch (e) {}
              },
            ),
            task == null ? Container() : uploadProgress(task as dynamic),
          ],
        ),
      ),
    );
  }

  Widget uploadProgress(UploadTask task) {
    return StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snapdata = snapshot.data;

            return Text(
              (snapdata!.bytesTransferred / snapdata.totalBytes).toString(),
            );
          } else
            return Container();
        });
  }

  Future uploadImage() async {
    if (file == null) return;

    final filename = path.basename(file!.path);
    final destination = 'article/$filename';

    task =
        FirebaseApi.uploadFile(file: file as dynamic, destination: destination);

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;

    file = File(path as dynamic);
    streamAdd(file as dynamic);
  }

  streamAdd(File file) {
    myFileStream.sink.add(file);
  }
}
