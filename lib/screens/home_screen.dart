import 'package:flutter/material.dart';
import 'tabs/general_news_tab.dart';
import 'tabs/category_news_tab.dart';
import 'tabs/latest_news_tab.dart';
import 'tabs/settings_tab.dart';

/// Màn hình chính: AppBar "ĐỌC BÁO ONLINE" + nút refresh + 4 tab bottom navigation
class HomeScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;
  const HomeScreen({super.key, required this.themeModeNotifier});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _generalKey = GlobalKey<GeneralNewsTabState>();

  @override
  Widget build(BuildContext context) {
    final pages = [
      GeneralNewsTab(key: _generalKey),
      const CategoryNewsTab(),
      const LatestNewsTab(),
      SettingsTab(themeModeNotifier: widget.themeModeNotifier),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ĐỌC BÁO ONLINE',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          // Nút refresh (giống hình mẫu PDF - icon C xoay ở góc phải)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_currentIndex == 0) {
                _generalKey.currentState?.refresh();
              } else {
                setState(() {}); // rebuild tab hiện tại
              }
            },
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      // Bottom navigation 4 tab đúng hình PDF: Tin tổng hợp, Chủ đề, Tin mới nhất, Cài đặt
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Tin tổng hợp'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Chủ đề'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Tin mới nhất'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
        ],
      ),
    );
  }
}
