import 'package:flutter_test/flutter_test.dart';
import 'package:lab5_ung_dung_doc_bao/services/rss_service.dart';

void main() {
  test('Tải tin tổng hợp từ VnExpress RSS thời gian thật', () async {
    final news = await RssService.fetchNews(RssService.generalFeedUrl, limit: 10);
    expect(news.isNotEmpty, true);
    expect(news.length, 10);
    for (var i = 0; i < news.length; i++) {
      // ignore: avoid_print
      print('[${i + 1}] ${news[i].title}');
      // ignore: avoid_print
      print('    ${news[i].formattedDate}');
    }
  });

  test('Tải 10 tin nổi bật (mới nhất) từ VnExpress RSS', () async {
    final news = await RssService.fetchNews(RssService.latestFeedUrl, limit: 10);
    expect(news.isNotEmpty, true);
    expect(news.length, 10);
    // ignore: avoid_print
    print('Tin nổi bật: ${news.length} tin');
  });

  test('Tải tin theo chủ đề Thời sự', () async {
    final news = await RssService.fetchNews(RssService.categories[0].rssUrl, limit: 5);
    expect(news.isNotEmpty, true);
    // ignore: avoid_print
    print('Chủ đề ${RssService.categories[0].title}: ${news.length} tin');
  });
}
