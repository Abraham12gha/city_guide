import 'package:flutter/material.dart';

import '../Comming _soon_screen.dart';
class HelpSupport extends StatelessWidget {
  const HelpSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,),
      body: const ComingSoonView(
        title: 'Help & Support feature "Coming Soon"',
        description:
        'We are working hard to bring this feature to life. Stay tuned for upcoming updates.',
      ),
    );
  }
}
