class Folder {
  final String id;
  final String title;
  final int videoCount;
  final String? thumbnailPath;
  final List<String> previewImages;

  Folder({
    required this.id,
    required this.title,
    required this.videoCount,
    this.thumbnailPath,
    this.previewImages = const [],
  });
}
