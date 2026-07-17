import 'package:flutter/material.dart';

import 'Comming _soon_screen.dart';
class Tripscreen extends StatelessWidget {
  const Tripscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const ComingSoonView(
        title: 'Coming Soon',
        description:
        'We are working hard to bring this feature to life. Stay tuned for upcoming updates.',
      ),
    );
  }
}
