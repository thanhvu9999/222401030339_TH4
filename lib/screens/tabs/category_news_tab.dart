import 'package:flutter/material.dart';
import '../../models/news_item.dart';
import '../../services/rss_service.dart';
import '../../widgets/news_card.dart';
import '../detail_screen.dart';

/// Tab 2: Phân loại theo chủ đề
class CategoryNewsTab extends StatefulWidget {
  const CategoryNewsTab({super.key});

  @override
  State<CategoryNewsTab> createState() => _CategoryNewsTabState();
}

class _CategoryNewsTabState extends State<CategoryNewsTab> {
  int _selectedIndex = 0;
  late Future<List<NewsItem>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  void _loadCategory() {
    _newsFuture = RssService.fetchNews(RssService.categories[_selectedIndex].rssUrl);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Thanh chọn chủ đề cuộn ngang
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: RssService.categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected = index == _selectedIndex;
              return ChoiceChip(
                label: Text(RssService.categories[index].title),
                selected: isSelected,
                onSelected: (_) {
                  _selectedIndex = index;
                  _loadCategory();
                },
                showCheckmark: false,
              );
            },
          ),
        ),
        // Danh sách tin theo chủ đề
        Expanded(
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
                      ElevatedButton(onPressed: _loadCategory, child: const Text('Thử lại')),
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
        ),
      ],
    );
  }
}
