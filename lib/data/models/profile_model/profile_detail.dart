// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:clean_app/data/models/profile_model/profile.dart';

class ProfileDetail extends Profile {
  ProfileDetail({
    required String id,
    required String name,
    String? bio,
    String? profilePictureUrl,
    this.locationsContributed,
    this.locationsAltered,
  }) : super(
          id: id,
          name: name,
          bio: bio,
          profilePictureUrl: profilePictureUrl,
        );

  int? locationsContributed;
  int? locationsAltered;

  @override
  ProfileDetail copyWith({
    String? id,
    String? name,
    String? bio,
    String? profilePictureUrl,
    int? locationsContributed,
    int? locationsAltered,
  }) {
    return ProfileDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      locationsAltered: locationsAltered ?? this.locationsAltered,
      locationsContributed: locationsContributed ?? this.locationsContributed,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'bio': bio,
      'profilePictureUrl': profilePictureUrl,
      'locationsContributed': locationsContributed,
      'locationsAltered': locationsAltered,
    };
  }

  factory ProfileDetail.fromMap(Map<String, dynamic> map) {
    return ProfileDetail(
      id: map['id'] as String,
      name: map['name'] as String,
      bio: map['bio'] as String,
      profilePictureUrl: map['profilePictureUrl'] != null
          ? map['profilePictureUrl'] as String
          : null,
      locationsAltered: map['locationsAltered'],
      locationsContributed: map['locationsContributed'],
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory ProfileDetail.fromJson(String source) =>
      ProfileDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      "ProfileDetail(id: $id, name: $name, bio: $bio, profilePictureUrl: $profilePictureUrl, locationsContributed: $locationsContributed, locationsAltered: $locationsAltered)";

  @override
  bool operator ==(covariant ProfileDetail other) {
    if (identical(this, other)) return true;

    return other.locationsContributed == locationsContributed &&
        other.locationsAltered == locationsAltered;
  }

  @override
  int get hashCode => locationsContributed.hashCode ^ locationsAltered.hashCode;

  static ProfileDetail fromData(Map<String, dynamic> data) {
    log("profile detail: ${data['locationContributed']}");

    var sample = ProfileDetail(
      id: data['id'] as String,
      name: data['name'] as String,
      bio: data['bio'] as String?,
      profilePictureUrl: data['profile_picture_url'] as String?,
    );

    sample.locationsContributed = data['locationscontributed'];
    sample.locationsAltered = data['locationsAltered'];

    // return ProfileDetail(
    //   id: data['id'] as String,
    //   name: data['name'] as String,
    //   bio: data['bio'] as String?,
    //   profilePictureUrl: data['profile_picture_url'] as String?,
    //   locationsAltered: (data['locationAltered'] ?? 0) as int,
    //   locationsContributed: (data['locationContributed'] ?? 0) as int,
    // );

    return sample;
  }
}
