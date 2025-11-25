// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedItemAdapter extends TypeAdapter<SavedItem> {
  @override
  final int typeId = 0;

  @override
  SavedItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedItem(
      id: fields[0] as String,
      title: fields[1] as String,
      url: fields[2] as String,
      platform: fields[3] as String,
      thumbnailPath: fields[4] as String?,
      date: fields[5] as DateTime,
      isBookmarked: fields[6] as bool,
      aiSummary: fields[7] as String?,
      userId: fields[8] as String?,
      createdAt: fields[9] as DateTime?,
      description: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SavedItem obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.platform)
      ..writeByte(4)
      ..write(obj.thumbnailPath)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.isBookmarked)
      ..writeByte(7)
      ..write(obj.aiSummary)
      ..writeByte(8)
      ..write(obj.userId)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedItem _$SavedItemFromJson(Map<String, dynamic> json) => SavedItem(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      platform: json['platform'] as String,
      thumbnailPath: json['thumbnail_path'] as String?,
      date: DateTime.parse(json['date'] as String),
      isBookmarked: json['is_bookmarked'] as bool? ?? false,
      aiSummary: json['ai_summary'] as String?,
      userId: json['user_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$SavedItemToJson(SavedItem instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'platform': instance.platform,
      'thumbnail_path': instance.thumbnailPath,
      'date': instance.date.toIso8601String(),
      'is_bookmarked': instance.isBookmarked,
      'ai_summary': instance.aiSummary,
      'user_id': instance.userId,
      'created_at': instance.createdAt?.toIso8601String(),
      'description': instance.description,
    };
