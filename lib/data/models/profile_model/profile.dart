// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Profile {
  final String id;
  final String name;
  final String? bio;
  final String? profilePictureUrl;
  Profile({
    required this.id,
    required this.name,
    required this.bio,
    this.profilePictureUrl,
  });
  

  Profile copyWith({
    String? id,
    String? name,
    String? bio,
    String? profilePictureUrl,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'bio': bio,
      'profile_picture_url': profilePictureUrl,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as String,
      name: map['name'] as String,
      bio: map['bio'] as String,
      profilePictureUrl: map['profilePictureUrl'] != null ? map['profilePictureUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) => Profile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Profile(id: $id, name: $name, bio: $bio, profilePictureUrl: $profilePictureUrl)';
  }

  @override
  bool operator ==(covariant Profile other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.bio == bio &&
      other.profilePictureUrl == profilePictureUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      bio.hashCode ^
      profilePictureUrl.hashCode;
  }
}
