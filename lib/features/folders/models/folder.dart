class Folder {
  final String id;
  final String title;
  final int videoCount;
  final String? thumbnailPath;

  Folder({
    required this.id,
    required this.title,
    required this.videoCount,
    this.thumbnailPath,
  });
}
