import 'package:city_guide/admin_app/list_cities.dart';
import 'package:flutter/material.dart';
import 'admin_bottomNavigationBar.dart';
import 'admin_home_screen.dart';
import 'admin_appbar.dart';
import 'admin_profile.dart';
import 'list_attraction.dart';
import 'list_category.dart';
class AdminMainHome extends StatefulWidget {
  const AdminMainHome({super.key});

  @override
  State<AdminMainHome> createState() => _AdminMainHomeState();
}

int selectedIndex = 0;

final pages =  [
  AdminHomeScreen(),
  ListCategory(),
  ListAttraction(),
  ListCities(),
  AdminProfileScreen(),
];

class _AdminMainHomeState extends State<AdminMainHome> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: selectedIndex == 0,

      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (selectedIndex != 0) {
          setState(() {
            selectedIndex = 0;
          });
        }
      },
      child: Scaffold(
        appBar: const AdminAppbar(),
        body:  IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: AdminBottomnavigationbar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            }
        ),
      ),
    );
  }
}
