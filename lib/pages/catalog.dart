import 'package:excelerate_intern_app/widgets/input_field.dart';
import 'package:flutter/material.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  bool visibleSearch = false;
  int selectedIndex = 0;

  final List<Widget> pages = [
    Center(child: Text('Homepage'),),
    Center(child: Text('Catalog Page'),),
    Center(child: Text('Profile'),),
  ];

  void onItemTap(int index){
    setState((){
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalog'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                visibleSearch = !visibleSearch; // 👈 invert the bool
              });
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: visibleSearch
                ? InputField(
                    key: const ValueKey('searchField'),
                    label: 'Search',
                    hint: 'Search...',
                    autoFocus: true,
                    icon: Icons.search,
                  )
                : const SizedBox(height: 10, key: ValueKey('emptySpace')),
          ),
          Expanded(child: Column(children: [
              
            ],
          )),
        ],
      ),
    );
  }
}
