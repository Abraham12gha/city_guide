// import 'package:flutter/material.dart';
//
// class Navigationbar extends StatefulWidget {
//   const Navigationbar({super.key});
//
//   @override
//   State<Navigationbar> createState() => _NavigationbarState();
// }
//
// class _NavigationbarState extends State<Navigationbar> {
//   int selectedIndex = 0;
//
//   final List<Widget> pages = [
//     const Center(child: Text("Home Screen")),
//     const Center(child: Text("Trips Screen")),
//     const Center(child: Text("Explore Screen")),
//     const Center(child: Text("Favorites Screen")),
//     const Center(child: Text("Profile Screen")),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return NavigationBar(
//       backgroundColor: Colors.white,
//       height: 80,
//       elevation: 0,
//       selectedIndex: selectedIndex,
//       onDestinationSelected: (index) {
//         setState(() {
//           selectedIndex = index;
//         });
//       },
//       destinations: [
//         NavigationDestination(icon: Icon(Icons.home), label: "Home"),
//         NavigationDestination(icon: Icon(Icons.map_outlined), label: "Trips"),
//         NavigationDestination(icon: Icon(Icons.explore), label: "Explore"),
//         NavigationDestination(icon: Icon(Icons.favorite_border), label: "Favs"),
//         NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class Navigationbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const Navigationbar({
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
          icon: Icon(Icons.map_outlined),
          label: "Trips",
        ),
        NavigationDestination(
          icon: Icon(Icons.explore),
          label: "Explore",
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border),
          label: "Saved",
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}