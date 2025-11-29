import 'package:hive/hive.dart';

part 'folder.g.dart';

@HiveType(typeId: 1)
class Folder {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int videoCount;

  @HiveField(3)
  final String? thumbnailPath;

  @HiveField(4)
  final List<String> previewImages;

  @HiveField(5)
  final String iconPath;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final String? ownerId;

  @HiveField(8)
  final List<String> sharedWith;

  Folder({
    required this.id,
    required this.title,
    this.videoCount = 0,
    this.thumbnailPath,
    this.previewImages = const [],
    required this.iconPath,
    required this.createdAt,
    this.ownerId,
    this.sharedWith = const [],
  });

  Folder copyWith({
    String? id,
    String? title,
    int? videoCount,
    String? thumbnailPath,
    List<String>? previewImages,
    String? iconPath,
    DateTime? createdAt,
    String? ownerId,
    List<String>? sharedWith,
  }) {
    return Folder(
      id: id ?? this.id,
      title: title ?? this.title,
      videoCount: videoCount ?? this.videoCount,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      previewImages: previewImages ?? this.previewImages,
      iconPath: iconPath ?? this.iconPath,
      createdAt: createdAt ?? this.createdAt,
      ownerId: ownerId ?? this.ownerId,
      sharedWith: sharedWith ?? this.sharedWith,
    );
  }

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'] as String,
      title: json['title'] as String,
      videoCount: json['video_count'] as int? ?? 0,
      thumbnailPath: json['thumbnail_path'] as String?,
      previewImages: (json['preview_images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      iconPath: json['icon_path'] as String? ?? 'assets/icons/folder.png',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      ownerId: json['owner_id'] as String?,
      sharedWith: (json['shared_with'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'video_count': videoCount,
      'thumbnail_path': thumbnailPath,
      'preview_images': previewImages,
      'icon_path': iconPath,
      'created_at': createdAt.toIso8601String(),
      'owner_id': ownerId,
      'shared_with': sharedWith,
    };
  }
}
