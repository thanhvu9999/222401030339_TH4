class NewsItem {
  final String title;
  final String link;
  final String pubDate;
  final String description;
  final String imageUrl;

  const NewsItem({
    required this.title,
    required this.link,
    required this.pubDate,
    required this.description,
    required this.imageUrl,
  });

  /// Hiển thị dạng "VnExpress  •  21 Apr 2026" (giống hình mẫu PDF)
  String get formattedDate {
    if (pubDate.isEmpty) return 'VnExpress';
    try {
      // pubDate RSS dạng: "Mon, 28 Sep 2026 17:14:07 +0700"
      final parts = pubDate.split(' ');
      if (parts.length >= 4) {
        final day = parts[1];
        final month = parts[2];
        final year = parts[3];
        return 'VnExpress  •  $day $month $year';
      }
    } catch (_) {}
    return 'VnExpress  •  $pubDate';
  }
}
