import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tab 4: Cài đặt - giao diện sáng/tối + thông tin (Lớp, MSSV, Họ tên)
class SettingsTab extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;
  const SettingsTab({super.key, required this.themeModeNotifier});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  String _name = 'Nguyễn Thành Vũ';
  String _mssv = '2224801030339';
  String _className = 'D22_TH05';

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? 'Nguyễn Thành Vũ';
      _mssv = prefs.getString('mssv') ?? '2224801030339';
      _className = prefs.getString('class') ?? 'D22_TH05';
    });
  }

  Future<void> _saveInfo(String name, String mssv, String className) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('mssv', mssv);
    await prefs.setString('class', className);
    setState(() {
      _name = name;
      _mssv = mssv;
      _className = className;
    });
  }

  void _editInfo() {
    final nameCtrl = TextEditingController(text: _name);
    final mssvCtrl = TextEditingController(text: _mssv);
    final classCtrl = TextEditingController(text: _className);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cập nhật thông tin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Họ tên')),
            TextField(controller: mssvCtrl, decoration: const InputDecoration(labelText: 'MSSV')),
            TextField(controller: classCtrl, decoration: const InputDecoration(labelText: 'Lớp')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              _saveInfo(nameCtrl.text, mssvCtrl.text, classCtrl.text);
              Navigator.pop(ctx);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeModeNotifier.value == ThemeMode.dark;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Thiết lập giao diện sáng/tối
        Card(
          child: SwitchListTile(
            title: const Text('Chế độ tối (Dark Mode)'),
            subtitle: Text(isDark ? 'Đang bật giao diện tối' : 'Đang bật giao diện sáng'),
            secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            value: isDark,
            onChanged: (val) async {
              widget.themeModeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('is_dark', val);
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 16),
        // Thông tin ứng dụng (Lớp, MSSV, Họ tên)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Thông tin ứng dụng',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.edit), onPressed: _editInfo),
                  ],
                ),
                const Divider(),
                _infoRow('Họ tên', _name),
                _infoRow('MSSV', _mssv),
                _infoRow('Lớp', _className),
                _infoRow('Nguồn RSS', 'VnExpress (vnexpress.net)'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
