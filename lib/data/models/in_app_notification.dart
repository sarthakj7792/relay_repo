import 'package:json_annotation/json_annotation.dart';

part 'in_app_notification.g.dart';

@JsonSerializable()
class InAppNotification {
  final String id;
  final String title;
  final String message;
  final String type; // 'info', 'warning', 'error'
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'action_url')
  final String? actionUrl;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  InAppNotification({
    required this.id,
    required this.title,
    required this.message,
    this.type = 'info',
    this.isActive = true,
    this.actionUrl,
    required this.createdAt,
  });

  factory InAppNotification.fromJson(Map<String, dynamic> json) =>
      _$InAppNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$InAppNotificationToJson(this);
}
