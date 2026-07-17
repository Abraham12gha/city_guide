import 'package:city_guide/screens/app_screen/Trip_screen.dart';
import 'package:city_guide/screens/app_screen/explore_screen.dart';
import 'package:city_guide/screens/app_screen/profile_screen.dart';
import 'package:city_guide/screens/app_screen/saved_attraction.dart';
import '../../services/notification_service.dart';
import 'package:flutter/material.dart';
import '../../appbar.dart';
import '../../navigationBar.dart';
import 'home_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int selectedIndex = 0;

  DateTime? lastBackPressTime;

  final pages =  [
    HomeScreen(),
    Tripscreen(),
    ExploreMapScreen(),
    SavedAttraction(),
    ProfileScreen(),
  ];

  NotificationService notificationService = NotificationService();
  @override
  void initState() {
    super.initState();

    notificationService.requestPermission();
    notificationService.initializeFCM();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (selectedIndex != 0) {
          setState(() {
            selectedIndex = 0;
          });
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: Navigationbar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
