import 'package:flutter/material.dart';
import 'package:excelerate_intern_app/widgets/course_card.dart';
import 'package:excelerate_intern_app/pages/course_detail_page.dart';

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
      'mentor': 'John Doe',
      'modules': {
        'Introduction': 'Completed',
        'Widgets': 'In Progress',
        'State Management': 'Not Started',
      },
      'description':
          'This course covers the basics of Flutter development, including widgets, layouts, and state management.',
      'comments': [
        {
          'user': 'Alice',
          'comment': 'Great course! Really enjoying the content so far.',
        },
      ],
    },
    {
      'title': 'Dart Fundamentals',
      'subtitle': 'Master the Dart Programming Language',
      'ImgURL':
          'https://swansoftwaresolutions.com/wp-content/uploads/2020/02/08.20.20-What-is-Dart-and-how-is-it-used-1.jpg',
      'status': 'Complete',
      'category': 'Mobile',
      'mentor': 'Alicia Decker',
      'modules': {
        'Syntax and Basics': 'Completed',
        'OOP in Dart': 'Completed',
        'Asynchronous Programming': 'Completed',
      },
      'description':
          'Learn the fundamentals of Dart programming language, which is essential for Flutter development.',
      'comments': [
        {
          'user': 'Bob',
          'comment':
              'The Dart course was very informative and well-structured.',
        },
      ],
    },
    {
      'title': 'Python Basics',
      'subtitle': 'Learn the Fundamentals of Python',
      'ImgURL':
          'https://4kwallpapers.com/images/wallpapers/python-programming-3840x2160-16102.jpg',
      'status': 'In Progress',
      'category': 'Backend',
      'mentor': 'Jane Smith',
      'modules': {
        'Introduction to Python': 'Completed',
        'Data Structures': 'In Progress',
        'Functions and Modules': 'Not Started',
      },
      'description':
          'This course introduces the basics of Python programming, covering syntax, data structures, and functions.',
      'comments': [
        {
          'user': 'Charlie',
          'comment': 'Python is such a versatile language. Loving the course!',
        },
      ],
    },
    {
      'title': 'HTML & CSS',
      'subtitle': 'Build beautiful web pages',
      'ImgURL': 'https://img-c.udemycdn.com/course/750x422/5852582_cafb_3.jpg',
      'status': 'Upcoming',
      'category': 'Frontend',
      'mentor': 'Andrew Wilson',
      'modules': {
        'HTML Basics': 'Not Started',
        'CSS Fundamentals': 'Not Started',
        'Responsive Design': 'Not Started',
      },
      'description':
          'Learn how to create stunning web pages using HTML and CSS, covering everything from basic tags to advanced styling techniques.',
      'comments': [],
    },
    {
      'title': 'Node.js Essentials',
      'subtitle': 'Backend development using Node.js',
      'ImgURL':
          'https://images.ctfassets.net/aq13lwl6616q/7cS8gBoWulxkWNWEm0FspJ/c7eb42dd82e27279307f8b9fc9b136fa/nodejs_cover_photo_smaller_size.png?w=500&fm=webp',
      'status': 'In Progress',
      'category': 'Backend',
      'mentor': 'Brian Lee',
      'modules': {
        'Getting Started with Node.js': 'Completed',
        'Working with Express': 'In Progress',
        'Database Integration': 'Not Started',
      },
      'description':
          'This course covers the essentials of backend development using Node.js, including server setup, routing, and database integration.',
      'comments': [
        {
          'user': 'Diana',
          'comment':
              'Node.js course is very practical and hands-on. Loving it!',
        },
      ],
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
                          // labelText: 'Search Courses',
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
                            borderSide: const BorderSide(
                              color: Color(0xFF6A5ACD),
                            ), // Optional custom color
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
            const SizedBox(height: 10),
            if (searchQuery.isEmpty)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Featured Courses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
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
                              padding: const EdgeInsets.only(
                                right: 12,
                                bottom: 10,
                              ),
                              child: SizedBox(
                                height: 200,
                                child: CourseCard(
                                  title: course['title'] as String,
                                  subtitle: course['subtitle'] as String,
                                  imageUrl: course['ImgURL'] as String,
                                  isVerticalLayout: true,
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
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            else
              const SizedBox.shrink(),
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
                        ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
