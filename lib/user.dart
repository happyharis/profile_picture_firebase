import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  final String id;
  final String name;
  final String photoUrl;
  CurrentUser({
    this.id,
    this.name,
    this.photoUrl,
  });

  CurrentUser copyWith({
    String id,
    String name,
    String photoUrl,
  }) {
    return CurrentUser(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
    };
  }

  factory CurrentUser.fromDoc(DocumentSnapshot doc) {
    if (doc == null) return null;

    return CurrentUser(
      id: doc.id,
      name: doc.data()['name'],
      photoUrl: doc.data()['photo_url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrentUser.fromJson(String source) =>
      CurrentUser.fromMap(json.decode(source));

  @override
  String toString() => 'CurrentUser(id: $id, name: $name, photoUrl: $photoUrl)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CurrentUser &&
        o.id == id &&
        o.name == name &&
        o.photoUrl == photoUrl;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ photoUrl.hashCode;

  factory CurrentUser.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CurrentUser(
      id: map['id'],
      name: map['name'],
      photoUrl: map['photoUrl'],
    );
  }
}
