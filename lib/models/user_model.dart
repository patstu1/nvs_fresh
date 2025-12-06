// lib/models/user_model.dart
// Legacy User Model for NVS Quantum Architecture
// Compatibility bridge for existing features

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.age,
    required this.location,
    required this.distance,
    this.isOnline = false,
    this.lastSeen,
    this.compatibility,
    this.interests = const <String>[],
    this.bio,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      age: json['age'] ?? 0,
      location: json['location'] ?? '',
      distance: (json['distance'] ?? 0).toDouble(),
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'],
      compatibility: json['compatibility']?.toDouble(),
      interests: List<String>.from(json['interests'] ?? <dynamic>[]),
      bio: json['bio'],
    );
  }
  final String id;
  final String name;
  final String avatarUrl;
  final int age;
  final String location;
  final double distance;
  final bool isOnline;
  final String? lastSeen;
  final double? compatibility;
  final List<String> interests;
  final String? bio;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'age': age,
      'location': location,
      'distance': distance,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'compatibility': compatibility,
      'interests': interests,
      'bio': bio,
    };
  }
}
