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

  @HiveField(13)
  @JsonKey(name: 'is_watched')
  final bool isWatched;

  @HiveField(14)
  @JsonKey(name: 'watched_at')
  final DateTime? watchedAt;

  @HiveField(15)
  @JsonKey(name: 'duration')
  final Duration? duration;

  @HiveField(16)
  @JsonKey(name: 'watched_duration')
  final Duration? watchedDuration;

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
    this.isWatched = false,
    this.watchedAt,
    this.duration,
    this.watchedDuration,
  });

  factory SavedItem.fromJson(Map<String, dynamic> json) {
    return SavedItem(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      platform: json['platform'] as String,
      thumbnailPath: json['thumbnail_path'] as String?,
      date: DateTime.parse(json['date'] as String),
      isBookmarked: json['is_bookmarked'] as bool? ?? false,
      aiSummary: json['ai_summary'] as String?,
      userId: json['user_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      description: json['description'] as String?,
      folderId: json['folder_id'] as String?,
      notes: json['notes'] as String?,
      isWatched: json['is_watched'] as bool? ?? false,
      watchedAt: json['watched_at'] != null
          ? DateTime.parse(json['watched_at'] as String)
          : null,
      duration: json['duration'] != null
          ? Duration(seconds: json['duration'] as int)
          : null,
      watchedDuration: json['watched_duration'] != null
          ? Duration(seconds: json['watched_duration'] as int)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'platform': platform,
      'thumbnail_path': thumbnailPath,
      'date': date.toIso8601String(),
      'is_bookmarked': isBookmarked,
      'ai_summary': aiSummary,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'description': description,
      'folder_id': folderId,
      'notes': notes,
      'is_watched': isWatched,
      'watched_at': watchedAt?.toIso8601String(),
      'duration': duration?.inSeconds,
      'watched_duration': watchedDuration?.inSeconds,
    };
  }

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
    bool? isWatched,
    DateTime? watchedAt,
    Duration? duration,
    Duration? watchedDuration,
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
      isWatched: isWatched ?? this.isWatched,
      watchedAt: watchedAt ?? this.watchedAt,
      duration: duration ?? this.duration,
      watchedDuration: watchedDuration ?? this.watchedDuration,
    );
  }
}
