import 'package:excelerate_intern_app/pages/catalog_page.dart';
import 'package:excelerate_intern_app/pages/profile_page.dart';
import 'package:excelerate_intern_app/pages/progress_page.dart';
import 'package:flutter/material.dart';

// A StatefulWidget that manages bottom navigation between pages
class BottomNav extends StatefulWidget {
  const BottomNav({super.key});
 
  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  bool visibleSearch = false; // (Currently unused) — could control search bar visibility
  int selectedIndex = 0; // Tracks which tab is currently selected

  // List of pages displayed for each bottom navigation tab
  final List<Widget> pages = [
    Center(child: CatalogPage()),  // Page 0 → Catalog
    Center(child: ProgressPage()), // Page 1 → Progress
    Center(child: ProfilePage()),  // Page 2 → Profile
  ];

  // Handles tap on bottom navigation bar items
  void onItemTap(int index) {
    setState(() {
      selectedIndex = index; // Update currently selected tab
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the page that matches the selected index
      body: pages[selectedIndex],

      // Bottom navigation bar with 3 items
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex, // Highlight the active tab
        onTap: onItemTap, // Handle user taps on items
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          // Catalog tab
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Catalog',
          ),
          // Progress tab
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: 'Progress',
          ),
          // Profile tab
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
