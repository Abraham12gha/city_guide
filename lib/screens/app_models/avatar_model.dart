import 'package:cloud_firestore/cloud_firestore.dart';

class AvatarModel {
  final String id;
  final String imageUrl;
  final bool isActive;
  final Timestamp? createdAt;

  const AvatarModel({
    required this.id,
    required this.imageUrl,
    required this.isActive,
    this.createdAt,
  });

  factory AvatarModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AvatarModel(
      id: doc.id,
      imageUrl: data['imageUrl'] ?? '',
      isActive: data['isActive'] ?? true,
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'imageUrl': imageUrl,
      'isActive': isActive,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  AvatarModel copyWith({
    String? id,
    String? imageUrl,
    bool? isActive,
    Timestamp? createdAt,
  }) {
    return AvatarModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}