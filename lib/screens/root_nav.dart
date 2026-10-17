import 'package:flutter/material.dart';

import 'create_report_screen.dart';
import 'home_feed_screen.dart';
import 'my_reports_screen.dart';
import 'profile_screen.dart';

/// المضيف الرئيسي للتنقّل عبر شريط سفلي (Bottom Navigation).
/// التبويبات: الرئيسية، بلاغاتي، حسابي — مع زر عائم لإنشاء بلاغ.
class RootNav extends StatefulWidget {
  const RootNav({super.key});

  @override
  State<RootNav> createState() => _RootNavState();
}

class _RootNavState extends State<RootNav> {
  int _index = 0;

  static const _pages = [
    HomeFeedScreen(),
    MyReportsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      // في الواجهة العربية (RTL) تكون جهة البداية = اليمين.
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      // زر «إبلاغ» يظهر في الرئيسية وبلاغاتي فقط، ويختفي في «حسابي».
      floatingActionButton: _index == 2
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreateReportScreen()),
                );
              },
              icon: const Icon(Icons.add_a_photo),
              label: const Text('إبلاغ'),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'الرئيسية'),
          NavigationDestination(
              icon: Icon(Icons.list_alt_outlined),
              selectedIcon: Icon(Icons.list_alt),
              label: 'بلاغاتي'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'حسابي'),
        ],
      ),
    );
  }
}
