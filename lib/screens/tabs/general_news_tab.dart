import 'package:flutter/material.dart';
import '../../models/news_item.dart';
import '../../services/rss_service.dart';
import '../../widgets/news_card.dart';
import '../detail_screen.dart';

/// Tab 1: Tin tổng hợp (Màn hình chính - giống hình PDF)
class GeneralNewsTab extends StatefulWidget {
  const GeneralNewsTab({super.key});

  @override
  State<GeneralNewsTab> createState() => GeneralNewsTabState();
}

class GeneralNewsTabState extends State<GeneralNewsTab> {
  late Future<List<NewsItem>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() {
    _newsFuture = RssService.fetchNews(RssService.generalFeedUrl);
    setState(() {});
  }

  Future<void> refresh() async {
    _loadNews();
    await _newsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
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
                  const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text('Không tải được tin tức\n${snapshot.error}',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _loadNews, child: const Text('Thử lại')),
                ],
              ),
            );
          }
          final news = snapshot.data ?? [];
          if (news.isEmpty) {
            return const Center(child: Text('Không có tin tức'));
          }
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
