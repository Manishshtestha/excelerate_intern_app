import 'package:flutter/material.dart';
import 'package:excelerate_intern_app/widgets/course_card.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  bool visibleSearch = false;
  String searchQuery = '';
  String selectedCategory = 'All';

  final List<Map<String, dynamic>> allCourses = [
    {
      'title': 'Flutter Basics',
      'subtitle': 'Learn the Fundamentals of Flutter',
      'ImgURL':
          'https://d2ms8rpfqc4h24.cloudfront.net/What_is_Flutter_f648a606af.png',
      'status': 'In Progress',
      'category': 'Mobile',
      'featured': true,
    },
    {
      'title': 'Dart Fundamentals',
      'subtitle': 'Master the Dart Programming Language',
      'ImgURL':
          'https://swansoftwaresolutions.com/wp-content/uploads/2020/02/08.20.20-What-is-Dart-and-how-is-it-used-1.jpg',
      'status': 'Complete',
      'category': 'Mobile',
      'featured': true,
    },
    {
      'title': 'Python Basics',
      'subtitle': 'Learn the Fundamentals of Python',
      'ImgURL':
          'https://4kwallpapers.com/images/wallpapers/python-programming-3840x2160-16102.jpg',
      'status': 'In Progress',
      'category': 'Backend',
      'featured': true,
    },
    {
      'title': 'HTML & CSS',
      'subtitle': 'Build beautiful web pages',
      'ImgURL': 'https://img-c.udemycdn.com/course/750x422/5852582_cafb_3.jpg',
      'status': 'Upcoming',
      'category': 'Frontend',
      'featured': false,
    },
    {
      'title': 'Node.js Essentials',
      'subtitle': 'Backend development using Node.js',
      'ImgURL': 'https://images.ctfassets.net/aq13lwl6616q/7cS8gBoWulxkWNWEm0FspJ/c7eb42dd82e27279307f8b9fc9b136fa/nodejs_cover_photo_smaller_size.png?w=500&fm=webp',
      'status': 'In Progress',
      'category': 'Backend',
      'featured': false,
    },
  ];

  List<Map<String, dynamic>> get filteredCourses {
    return allCourses.where((course) {
      final matchesSearch =
          searchQuery.isEmpty ||
          course['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          course['subtitle'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory =
          selectedCategory == 'All' || course['category'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

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
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: visibleSearch
                  ? Container(
                      key: const ValueKey('searchField'),
                      margin: const EdgeInsets.all(16),
                      child: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: 'Search Courses',
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) =>
                            setState(() => searchQuery = value),
                      ),
                    )
                  : const SizedBox(height: 20, key: ValueKey('emptySpace')),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Featured Courses',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    for (var course in allCourses)
                      Padding(
                        padding: const EdgeInsets.only(right: 12, bottom: 10),
                        child: SizedBox(
                          height: 200,
                          child: CourseCard(
                            title: course['title'] as String,
                            subtitle: course['subtitle'] as String,
                            imageUrl: course['ImgURL'] as String,
                            isVerticalLayout: true,
                            onTap: () => print('Tapped: ${course['title']}'),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories
                      .map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: selectedCategory == category,
                            onSelected: (selected) =>
                                setState(() => selectedCategory = category),
                            selectedColor: Colors.blue[50],
                            backgroundColor: Colors.grey[100],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            filteredCourses.isEmpty
                ? const Center(child: Text('No courses found'))
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Courses',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      for (var course in filteredCourses)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                            bottom: 10,
                          ),
                          child: SizedBox(
                            height: 130,
                            width: double.infinity,
                            child: CourseCard(
                              title: course['title'] as String,
                              subtitle: course['subtitle'] as String,
                              imageUrl: course['ImgURL'] as String,
                              isVerticalLayout: false,
                              onTap: () => print('Tapped: ${course['title']}'),
                            ),
                          ),
                        ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
