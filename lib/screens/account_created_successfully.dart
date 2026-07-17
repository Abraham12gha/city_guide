import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../navigationBar.dart';
import 'app_screen/Main_screen.dart';

class AccountCreatedSuccessfully extends StatelessWidget {
  const AccountCreatedSuccessfully({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/AccountCreatedSuccessfullySVG.svg',
                  width: width * 0.8,
                  // height: height * 0.4,
                ),
                SizedBox(height: height * 0.06),

                
                FittedBox(
                  child: Text(
                    "Account Created Successfully!",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
                  ),
                ),
                
                
        
                SizedBox(height: height * 0.01),
                Text(
                  "Welcome to City Compass! Discover top attractions, local favorites, and hidden gems around you. Explore the city and uncover new experiences wherever you go.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black45),
                ),
        
                SizedBox(height: height * 0.02),
                SizedBox(
                  height: 55,
                  width: width * .9,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF14B8A6),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context)=> const MainScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
