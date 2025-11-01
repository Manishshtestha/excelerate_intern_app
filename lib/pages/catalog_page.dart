import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excelerate_intern_app/widgets/course_card.dart';
import 'package:excelerate_intern_app/pages/CourseDetailPage.dart';

/// CatalogPage — Displays a searchable, categorized list of all available courses.
/// Integrates Firestore to fetch live course data and provides navigation to detailed course pages.
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  bool visibleSearch = false; // Toggles visibility of search bar
  String searchQuery = '';    // Stores current search text input
  String selectedCategory = 'All'; // Tracks selected course category

  // List of available course categories (for filtering)
  List<String> get categories => ['All', 'Mobile', 'Backend', 'Frontend'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ---------- App Bar ----------
      appBar: AppBar(
        title: const Text('Catalog'),
        centerTitle: true,
        actions: [
          // Search icon — toggles visibility of search bar
          IconButton(
            onPressed: () => setState(() => visibleSearch = !visibleSearch),
            icon: const Icon(Icons.search),
          ),
        ],
      ),

      // ---------- Main Content ----------
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔍 Search Bar (Animated show/hide)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: visibleSearch
                  ? Container(
                      key: const ValueKey('searchField'),
                      margin: const EdgeInsets.all(16),
                      child: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              // Clear text and hide search bar
                              setState(() {
                                searchQuery = '';
                                visibleSearch = false;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                        onChanged: (value) =>
                            setState(() => searchQuery = value),
                      ),
                    )
                  : const SizedBox(height: 20, key: ValueKey('emptySpace')),
            ),

            // 🗂 Category Filter (Horizontal scroll)
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: selectedCategory == category,
                        onSelected: (selected) =>
                            setState(() => selectedCategory = category),
                        selectedColor: Colors.blue[50],
                        backgroundColor: Colors.grey[100],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 📡 Fetch courses from Firestore
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('courses')
                  .snapshots(),
              builder: (context, snapshot) {
                // Show loading spinner while data is loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                // Handle case when no data is available
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No courses found'));
                }

                // Parse Firestore data into a list of course maps
                List<Map<String, dynamic>> allCourses = snapshot.data!.docs.map(
                  (doc) {
                    return {
                      'id': doc.id,
                      ...doc.data() as Map<String, dynamic>,
                    };
                  },
                ).toList();

                // 🌟 Separate Featured Courses
                final featuredCourses = allCourses
                    .where((course) => course['isFeatured'] == true)
                    .toList();

                // 🔍 Apply Search & Category Filters
                List<Map<String, dynamic>> filteredCourses = allCourses.where((
                  course,
                ) {
                  // Check search match
                  final matchesSearch =
                      searchQuery.isEmpty ||
                      (course['title'] ?? '').toString().toLowerCase().contains(
                            searchQuery.toLowerCase(),
                          ) ||
                      (course['subtitle'] ?? '')
                          .toString()
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());

                  // Check category match
                  final matchesCategory =
                      selectedCategory == 'All' ||
                      (course['category'] ?? '') == selectedCategory;

                  return matchesSearch && matchesCategory;
                }).toList();

                // ---------- Course List Display ----------
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🌟 Featured Courses (Only show when no search active)
                    if (searchQuery.isEmpty && featuredCourses.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              'Featured Courses',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: featuredCourses.map((course) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: SizedBox(
                                      height: 200,
                                      // CourseCard widget — reusable course UI component
                                      child: CourseCard(
                                        title: course['title'] ?? 'Untitled',
                                        subtitle: course['subtitle'] ?? '',
                                        imageUrl: course['imageUrl'] ?? '',
                                        isVerticalLayout: true,
                                        onTap: () {
                                          // Navigate to detailed course page with fade animation
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              transitionDuration:
                                                  const Duration(
                                                    milliseconds: 350,
                                                  ),
                                              pageBuilder: (_, __, ___) =>
                                                  CourseDetailPage(
                                                    course: course,
                                                  ),
                                              transitionsBuilder:
                                                  (_, animation, __, child) =>
                                                      FadeTransition(
                                                        opacity: animation,
                                                        child: child,
                                                      ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),

                    // 📚 All Courses (Vertical List)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        'All Courses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Show message if no filtered results
                    if (filteredCourses.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('No matching courses found'),
                        ),
                      )
                    else
                      // Display list of filtered courses vertically
                      ListView.builder(
                        itemCount: filteredCourses.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final course = filteredCourses[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: SizedBox(
                              height: 130,
                              child: CourseCard(
                                title: course['title'] ?? 'Untitled',
                                subtitle: course['subtitle'] ?? '',
                                imageUrl: course['imageUrl'] ?? '',
                                isVerticalLayout: false,
                                onTap: () {
                                  // Navigate to detailed course page
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(
                                        milliseconds: 350,
                                      ),
                                      pageBuilder: (_, __, ___) =>
                                          CourseDetailPage(course: course),
                                      transitionsBuilder:
                                          (_, animation, __, child) =>
                                              FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
