import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  final String id;
  final String name;
  final String profileUrl;
  CurrentUser({
    this.id,
    this.name,
    this.profileUrl,
  });

  CurrentUser copyWith({
    String id,
    String name,
    String profileUrl,
  }) {
    return CurrentUser(
      id: id ?? this.id,
      name: name ?? this.name,
      profileUrl: profileUrl ?? this.profileUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'profileUrl': profileUrl,
    };
  }

  factory CurrentUser.fromDoc(DocumentSnapshot doc) {
    if (doc == null) return null;

    return CurrentUser(
      id: doc.id,
      name: doc.data()['name'],
      profileUrl: doc.data()['profile_url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrentUser.fromJson(String source) =>
      CurrentUser.fromDoc(json.decode(source));

  @override
  String toString() => 'User(id: $id, name: $name, profileUrl: $profileUrl)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CurrentUser &&
        o.id == id &&
        o.name == name &&
        o.profileUrl == profileUrl;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ profileUrl.hashCode;
}
