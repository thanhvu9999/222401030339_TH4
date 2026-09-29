import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_item.dart';

/// Màn hình chi tiết: hiển thị sau khi tap vào tin
class DetailScreen extends StatelessWidget {
  final NewsItem news;
  const DetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi Tiết Tin Tức')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề
            Text(
              news.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.3),
            ),
            const SizedBox(height: 8),
            // Nguồn và ngày
            Text(
              news.formattedDate,
              style: const TextStyle(color: Color(0xFF1A73E8), fontSize: 14),
            ),
            const SizedBox(height: 14),
            // Ảnh lớn
            if (news.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  news.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
              ),
            const SizedBox(height: 14),
            // Tóm tắt
            if (news.description.isNotEmpty)
              Text(
                news.description,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            const SizedBox(height: 20),
            // Nút mở bài gốc
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.tryParse(news.link);
                  if (uri != null) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.open_in_browser),
                label: const Text('Đọc bài viết trên VnExpress'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
