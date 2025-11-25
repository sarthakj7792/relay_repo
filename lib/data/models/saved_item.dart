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
  final String? thumbnailPath;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final bool isBookmarked;

  @HiveField(7)
  final String? aiSummary;

  @HiveField(8)
  @JsonKey(name: 'user_id')
  final String? userId;

  @HiveField(9)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @HiveField(10)
  final String? description;

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
    );
  }
}
