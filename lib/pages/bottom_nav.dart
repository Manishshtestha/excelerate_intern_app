import 'package:excelerate_intern_app/pages/catalog.dart';
import 'package:excelerate_intern_app/pages/profile.dart';
import 'package:excelerate_intern_app/pages/progress.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  bool visibleSearch = false;
  int selectedIndex = 0;

  final List<Widget> pages = [
    Center(child: CatalogPage()),
    Center(child: ProgressPage()),
    Center(child: ProfilePage()),
  ];

  void onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap:onItemTap,
        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.list),label: 'Catalog'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph),label:'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.person),label:'Profile'),
        ]
      ),
    );
  }
}
