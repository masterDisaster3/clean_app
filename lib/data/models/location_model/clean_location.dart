// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:latlong2/latlong.dart';

class CleanLocation {
  String? address;

  LatLng? coordinates;
  CleanLocation({
    this.address,
    this.coordinates,
  });

  CleanLocation copyWith({
    String? address,
    LatLng? coordinates,
  }) {
    return CleanLocation(
      address: address ?? this.address,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'address': address,
  //     'coordinates': coordinates?.toMap(),
  //   };
  // }

  // factory CleanLocation.fromMap(Map<String, dynamic> map) {
  //   return CleanLocation(
  //     address: map['address'] != null ? map['address'] as String : null,
  //     coordinates: map['coordinates'] != null ? LatLng.fromMap(map['coordinates'] as Map<String,dynamic>) : null,
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory CleanLocation.fromJson(String source) => CleanLocation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      '$address';

  @override
  bool operator ==(covariant CleanLocation other) {
    if (identical(this, other)) return true;

    return other.address == address && other.coordinates == coordinates;
  }

  @override
  int get hashCode => address.hashCode ^ coordinates.hashCode;
}
