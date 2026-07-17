import 'package:flutter/material.dart';

class AdminBottomnavigationbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AdminBottomnavigationbar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.white,
      height: 80,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        NavigationDestination(
          icon: Icon(Icons.category),
          label: "Category",
        ),
        NavigationDestination(
          icon: Icon(Icons.attractions),
          label: "Attraction",
        ),
        NavigationDestination(
          icon: Icon(Icons.location_city),
          label: "City",
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}