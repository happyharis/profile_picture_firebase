import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'dart:html';

import 'package:profile_picture_firebase/user.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<CurrentUser>(
      create: (context) => userStream(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProfilePage(),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _currentUser = Provider.of<CurrentUser>(context);
    if (_currentUser == null) return Center(child: CircularProgressIndicator());
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            ProfilePicture(),
            SizedBox(height: 20),
            OutlineButton(
              onPressed: () {
                buildUploadImage(_currentUser);
              },
              child: Text('Update Profile Picture'),
            )
          ],
        ),
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key key,
  }) : super(key: key);

  Future<Uri> buildDownloadURL(CurrentUser user) {
    return fb
        .storage()
        .refFromURL('gs://happy-haris-play.appspot.com/')
        .child(user.profileUrl)
        .getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    final _currentUser = Provider.of<CurrentUser>(context);
    if (_currentUser == null) return Center(child: CircularProgressIndicator());

    return SizedBox(
      height: 96,
      width: 96,
      child: StreamBuilder<Uri>(
        stream: Stream.fromFuture(buildDownloadURL(_currentUser)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot?.data == null)
            return CircleAvatar(
              child: Icon(
                Icons.people_alt_rounded,
                size: 96,
              ),
            );
          return CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.network(
              snapshot?.data?.toString(),
              height: 96,
              width: 96,
            ),
          );
        },
      ),
    );
  }
}

buildUploadImage(CurrentUser user) {
  uploadImage(onSelected: (file) {
    final userId = user.id;
    final dateTime = DateTime.now();
    final path = '$userId/$dateTime';

    fb
        .storage()
        .refFromURL('gs://happy-haris-play.appspot.com/')
        .child(path)
        .put(file)
        .future
        .then((_) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .update({'profile_url': path});
    });
  });
}

/// A "select file/folder" window will appear. User will have to choose a file.
/// This file will be then read, and uploaded to firebase storage;
uploadImage({@required Function(File) onSelected}) async {
  // HTML input element
  InputElement uploadInput = FileUploadInputElement()..accept = 'image/*';
  uploadInput.click();

  uploadInput.onChange.listen(
    (changeEvent) {
      final file = uploadInput.files.first;
      final reader = FileReader();
      // The FileReader object lets web applications asynchronously read the
      // contents of files (or raw data buffers) stored on the user's computer,
      // using File or Blob objects to specify the file or data to read.
      // Source: https://developer.mozilla.org/en-US/docs/Web/API/FileReader

      reader.readAsDataUrl(file);
      // The readAsDataURL method is used to read the contents of the specified Blob or File.
      //  When the read operation is finished, the readyState becomes DONE, and the loadend is
      // triggered. At that time, the result attribute contains the data as a data: URL representing
      // the file's data as a base64 encoded string.
      // Source: https://developer.mozilla.org/en-US/docs/Web/API/FileReader/readAsDataURL

      reader.onLoadEnd.listen(
        // After file finiesh reading and loading, it will be uploaded to firebase storage
        (loadEndEvent) async {
          onSelected(file);
        },
      );
    },
  );
}

Stream<CurrentUser> userStream() {
  return FirebaseFirestore.instance
      .collection('users')
      .doc('JtcAlXoD8DVWduTeqS2F')
      .snapshots()
      .map((doc) => CurrentUser.fromDoc(doc));
}
