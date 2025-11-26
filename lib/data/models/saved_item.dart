import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saved_item.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class SavedItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String url;

  @HiveField(3)
  final String platform; // 'youtube', 'instagram', etc.

  @HiveField(4)
  @JsonKey(name: 'thumbnail_path')
  final String? thumbnailPath;

  @HiveField(5)
  @JsonKey(name: 'date')
  final DateTime date;

  @HiveField(6)
  @JsonKey(name: 'is_bookmarked')
  final bool isBookmarked;

  @HiveField(7)
  @JsonKey(name: 'ai_summary')
  final String? aiSummary;

  @HiveField(8)
  @JsonKey(name: 'user_id')
  final String? userId;

  @HiveField(9)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @HiveField(10)
  final String? description;

  @HiveField(11)
  @JsonKey(name: 'folder_id')
  final String? folderId;

  @HiveField(12)
  @JsonKey(name: 'notes')
  final String? notes;

  SavedItem({
    required this.id,
    required this.title,
    required this.url,
    required this.platform,
    this.thumbnailPath,
    required this.date,
    this.isBookmarked = false,
    this.aiSummary,
    this.userId,
    this.createdAt,
    this.description,
    this.folderId,
    this.notes,
  });

  factory SavedItem.fromJson(Map<String, dynamic> json) =>
      _$SavedItemFromJson(json);
  Map<String, dynamic> toJson() => _$SavedItemToJson(this);

  SavedItem copyWith({
    String? id,
    String? title,
    String? url,
    String? platform,
    String? thumbnailPath,
    DateTime? date,
    bool? isBookmarked,
    String? aiSummary,
    String? userId,
    DateTime? createdAt,
    String? description,
    String? folderId,
    String? notes,
  }) {
    return SavedItem(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      platform: platform ?? this.platform,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      date: date ?? this.date,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      aiSummary: aiSummary ?? this.aiSummary,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      folderId: folderId ?? this.folderId,
      notes: notes ?? this.notes,
    );
  }
}
