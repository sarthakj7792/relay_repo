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

  Folder({
    required this.id,
    required this.title,
    required this.videoCount,
    this.thumbnailPath,
    this.previewImages = const [],
  });
}
