// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InAppNotification _$InAppNotificationFromJson(Map<String, dynamic> json) =>
    InAppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String? ?? 'info',
      isActive: json['is_active'] as bool? ?? true,
      actionUrl: json['action_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$InAppNotificationToJson(InAppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
      'is_active': instance.isActive,
      'action_url': instance.actionUrl,
      'created_at': instance.createdAt.toIso8601String(),
    };
