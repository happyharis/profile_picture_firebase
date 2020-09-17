import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
              onPressed: () {},
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

  @override
  Widget build(BuildContext context) {
    final _currentUser = Provider.of<CurrentUser>(context);
    if (_currentUser == null) return Center(child: CircularProgressIndicator());

    return CircleAvatar(
      radius: 48,
      child: Icon(
        Icons.people_alt_rounded,
      ),
    );
  }
}

Stream<CurrentUser> userStream() {
  return FirebaseFirestore.instance
      .collection('users')
      .doc('JtcAlXoD8DVWduTeqS2F')
      .snapshots()
      .map((doc) => CurrentUser.fromDoc(doc));
}
