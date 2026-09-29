import 'package:flutter/material.dart';
import '../../models/news_item.dart';
import '../../services/rss_service.dart';
import '../../widgets/news_card.dart';
import '../detail_screen.dart';

/// Tab 3: Hiển thị 10 tin mới nhất
class LatestNewsTab extends StatefulWidget {
  const LatestNewsTab({super.key});

  @override
  State<LatestNewsTab> createState() => _LatestNewsTabState();
}

class _LatestNewsTabState extends State<LatestNewsTab> {
  late Future<List<NewsItem>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() {
    // Giới hạn đúng 10 tin mới nhất theo yêu cầu PDF
    _newsFuture = RssService.fetchNews(RssService.latestFeedUrl, limit: 10);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadNews();
        await _newsFuture;
      },
      child: FutureBuilder<List<NewsItem>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lỗi: ${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _loadNews, child: const Text('Thử lại')),
                ],
              ),
            );
          }
          final news = snapshot.data ?? [];
          if (news.isEmpty) return const Center(child: Text('Không có tin'));
          return ListView.builder(
            itemCount: news.length,
            itemBuilder: (context, index) {
              return NewsCard(
                news: news[index],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailScreen(news: news[index])),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
