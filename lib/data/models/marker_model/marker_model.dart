// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:latlong2/latlong.dart';

class CleanMarker {
  String id;
  String userId;
  String createdAt;
  String imageUrl;
  String typeMarker;
  String address;
  String? description;
  LatLng location;
  String? locationAlteredBy;
  String storageFile;
  CleanMarker(
      {required this.id,
      required this.userId,
      required this.createdAt,
      required this.imageUrl,
      required this.typeMarker,
      this.description,
      required this.location,
      this.locationAlteredBy,
      required this.address,
      required this.storageFile});

  static CleanMarker create(
      String creatorId,
      String imageUrl,
      String typeMarker,
      String description,
      LatLng location,
      String address,
      String createAt,
      String storageFile) {
    return CleanMarker(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        userId: creatorId,
        createdAt: createAt,
        imageUrl: imageUrl,
        typeMarker: typeMarker,
        location: location,
        address: address,
        description: description,
        locationAlteredBy: null,
        storageFile: storageFile);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'image_url': imageUrl,
      'type_marker': typeMarker,
      'description': description,
      'location': LatLngToString(location),
      'location_altered_by': locationAlteredBy,
      'address': address,
      'created_at': createdAt,
      'storage_file': storageFile
    };
  }

  factory CleanMarker.fromMap(Map<String, dynamic> map) {
    return CleanMarker(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        createdAt: map['created_at'] as String,
        imageUrl: map['image_url'] as String,
        typeMarker: map['type_marker'] as String,
        description:
            map['description'] != null ? map['description'] as String : null,
        location: stringToLatLng(map['location'] as String),
        address: map['address'] as String,
        locationAlteredBy: map['location_altered_by'] != null
            ? map['location_altered_by'] as String
            : null,
        storageFile: map['storage_file'] as String);
  }

  // ignore: non_constant_identifier_names
  static String LatLngToString(LatLng latLng) {
    //log("LatLngToString : $latLng");

    var temp = "${latLng.latitude},${latLng.longitude}";

    //log("LatLngToString : $temp");
    return temp;
  }

  static LatLng stringToLatLng(String point) {
    //log("markerModel.stringToLatlng: ");
    final spit = point.split(',');

    //log("markerModel.stringToLatlng:spit ${spit[0]} ${spit[1]} ");

    double lat = double.parse(spit[0]);
    double lng = double.parse(spit[1]);

    var temp = LatLng(lat, lng);

    //log("markerModel.stringToLatlng:temp $temp");

    return temp;
  }

  static List<CleanMarker> markersFromMap({
    required List<dynamic> data,
  }) {
    //log("markermodel.markersFromMap: ");
    return data
        .map<CleanMarker>(
          (row) => CleanMarker(
              id: row['id'] as String,
              imageUrl: row['image_url'] as String,
              description: row['description'] != null
                  ? row['description'] as String
                  : null,
              userId: row['user_id'] as String,
              location: stringToLatLng(row['location'] as String),
              createdAt: row['created_at'] as String,
              address: row['address'] as String,
              typeMarker: row['type_marker'] as String,
              storageFile: row['storage_file'] as String),
        )
        .toList();
  }

  String toJson() => json.encode(toMap());

  factory CleanMarker.fromJson(String source) =>
      CleanMarker.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CleanMarker(id: $id, userId: $userId, createdAt: $createdAt, imageUrl: $imageUrl, typeMarker: $typeMarker, description: $description, location: $location, locationAlteredBy: $locationAlteredBy storageFile: $storageFile)';
  }

  @override
  bool operator ==(covariant CleanMarker other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.createdAt == createdAt &&
        other.imageUrl == imageUrl &&
        other.typeMarker == typeMarker &&
        other.address == address &&
        other.description == description &&
        other.location == location &&
        other.locationAlteredBy == locationAlteredBy;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        createdAt.hashCode ^
        imageUrl.hashCode ^
        typeMarker.hashCode ^
        address.hashCode ^
        description.hashCode ^
        location.hashCode ^
        locationAlteredBy.hashCode;
  }
}

class CleanMarkerMaker {
  String userId;
  File image;
  String typeMarker;
  String? description;
  LatLng location;
  String address;
  String? locationAlteredBy;
  String createAt;
  String? storageFile;

  CleanMarkerMaker(
      {required this.userId,
      required this.image,
      required this.typeMarker,
      this.description,
      required this.location,
      required this.address,
      this.locationAlteredBy,
      required this.createAt});

  @override
  String toString() {
    return 'CleanMarkerMaker(userId: $userId, image: $image, typeMarker: $typeMarker, description: $description, location: $location, address: $address, locationAlteredBy: $locationAlteredBy createdat: $createAt)';
  }
}
