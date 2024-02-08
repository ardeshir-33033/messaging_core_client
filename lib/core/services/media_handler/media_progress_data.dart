class MediaProgressData {
  final int count;
  final int total;
  final String contentId;

  const MediaProgressData({
    required this.contentId,
    required this.total,
    required this.count,
  });
}