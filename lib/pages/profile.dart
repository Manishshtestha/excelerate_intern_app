import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final courses = ['Flutter Basics', 'Dart Fundamentals', 'State Management'];
  final progress = ['Complete', 'In Progress', 'In Progress'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              print('You selected: $value'); //Needs to be updated
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(
                      'https://i.pinimg.com/1200x/67/2c/d6/672cd616936e481ef2632306731a87cd.jpg',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Sophia Carter', //Needs to be Dynamic
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Joined 2 years ago', //Needs to be Dynamic
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Courses',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            // SizedBox(height: 10),
            ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: courses.length,
              shrinkWrap: true, // 👈 tells it to take only the needed space
              physics: NeverScrollableScrollPhysics(),
              
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.book),
                  title: Text(courses[index]),
                  subtitle: Text(progress[index],style: TextStyle(color: Colors.blue),),
                  
                  onTap: () {
                    print('Tapped on ${courses[index]}');
                  },
                  
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
