import 'package:city_guide/screens/app_screen/InAppNotification_screen.dart';
import 'package:flutter/material.dart';

import 'map/services/location_service.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _CustomAppBarState extends State<CustomAppBar> {

  final LocationService _locationService = LocationService();

  String city = "Getting location...";

  @override
  void initState() {
    super.initState();
    _loadCity();
  }

  Future<void> _loadCity() async {
    final result = await _locationService.getCurrentCity();

    if (!mounted) return;

    setState(() {
      city = result ?? "Enable Location";
    });
  }

  @override
  Widget build(BuildContext context) {
    return  AppBar(
        titleSpacing: 0,
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Image.asset("assets/images/logo-new.png", fit: BoxFit.contain, width: 40,),
        title: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black45,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.red),
                    SizedBox(width: 4),
                    Text(
                      "${city}",
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ),


        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none,
              size: 28,
              color: Colors.black,
            ),
          ),
        ],
      );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(70);
}
