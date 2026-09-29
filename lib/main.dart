import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('is_dark') ?? false;
  final themeNotifier = ValueNotifier<ThemeMode>(isDark ? ThemeMode.dark : ThemeMode.light);

  runApp(NewsApp(themeModeNotifier: themeNotifier));
}

class NewsApp extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;
  const NewsApp({super.key, required this.themeModeNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Ứng Dụng Đọc Báo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
            brightness: Brightness.dark,
          ),
          themeMode: themeMode,
          home: HomeScreen(themeModeNotifier: themeModeNotifier),
        );
      },
    );
  }
}
