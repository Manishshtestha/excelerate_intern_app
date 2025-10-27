import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excelerate_intern_app/widgets/course_card.dart';
import 'package:excelerate_intern_app/pages/CourseDetailPage.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  bool visibleSearch = false;
  String searchQuery = '';
  String selectedCategory = 'All';

  List<String> get categories => ['All', 'Mobile', 'Backend', 'Frontend'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => setState(() => visibleSearch = !visibleSearch),
            icon: const Icon(Icons.search),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔍 Search bar
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

            // 🗂 Category filter
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No courses found'));
                }

                // Parse Firestore data
                List<Map<String, dynamic>> allCourses = snapshot.data!.docs.map(
                  (doc) {
                    return {
                      'id': doc.id,
                      ...doc.data() as Map<String, dynamic>,
                    };
                  },
                ).toList();

                // Separate featured courses
                final featuredCourses = allCourses
                    .where((course) => course['isFeatured'] == true)
                    .toList();

                // Apply search filter
                List<Map<String, dynamic>> filteredCourses = allCourses.where((
                  course,
                ) {
                  final matchesSearch =
                      searchQuery.isEmpty ||
                      (course['title'] ?? '').toString().toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      ) ||
                      (course['subtitle'] ?? '')
                          .toString()
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());

                  final matchesCategory =
                      selectedCategory == 'All' ||
                      (course['category'] ?? '') == selectedCategory;

                  return matchesSearch && matchesCategory;
                }).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🌟 Featured Courses (only if not searching)
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
                                      child: CourseCard(
                                        title: course['title'] ?? 'Untitled',
                                        subtitle: course['subtitle'] ?? '',
                                        imageUrl: course['imageUrl'] ?? '',
                                        isVerticalLayout: true,
                                        onTap: () {
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

                    // 📚 All Courses (Vertical list)
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

                    if (filteredCourses.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('No matching courses found'),
                        ),
                      )
                    else
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
