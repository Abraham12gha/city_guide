// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../../../services/auth.dart';
// import '../../../services/avatar_service.dart';
// import '../../app_models/avatar_model.dart';
//
// class AvatarSelectionScreen extends StatefulWidget {
//   const AvatarSelectionScreen({super.key});
//
//   @override
//   State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
// }
//
// class _AvatarSelectionScreenState extends State<AvatarSelectionScreen> {
//   String? selectedAvatarId;
//   final authService = Auth();
//
//
//   @override
//   void initState() {
//     super.initState();
//     loadCurrentAvatar();
//   }
//
//   Future<void> loadCurrentAvatar() async {
//     final uid = FirebaseAuth.instance.currentUser!.uid;
//
//     final doc = await FirebaseFirestore.instance
//         .collection("users")
//         .doc(uid)
//         .get();
//
//     setState(() {
//       selectedAvatarId = doc.data()?["avatarId"];
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text("Choose Avatar"),
//         centerTitle: true,
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SizedBox(
//           height: 55,
//           child: ElevatedButton(
//             onPressed: selectedAvatarId == null ? null : () async {
//
//               await authService.updateUserAvatar(selectedAvatarId!);
//               if (mounted) {
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text("Save Changes"),
//           ),
//         ),
//       ),
//         body: StreamBuilder<List<AvatarModel>>(
//           stream: AvatarService.instance.streamAvatars(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//
//             if (snapshot.hasError) {
//               return const Center(
//                 child: Text("Failed to load avatars"),
//               );
//             }
//
//             final avatars = snapshot.data ?? [];
//
//             if (avatars.isEmpty) {
//               return const Center(
//                 child: Text("No avatars available"),
//               );
//             }
//
//             return GridView.builder(
//               padding: const EdgeInsets.all(20),
//               itemCount: avatars.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//               ),
//               itemBuilder: (context, index) {
//                 final avatar = avatars[index];
//
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedAvatarId = avatar.id;
//                     });
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: selectedAvatarId == avatar.id
//                             ? Colors.teal
//                             : Colors.transparent,
//                         width: 3,
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(3),
//                       child: ClipOval(
//                         child: Image.network(
//                           avatar.imageUrl,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//
//         ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../services/auth.dart';
import '../../../services/avatar_service.dart';
import '../../app_models/avatar_model.dart';

class AvatarSelectionScreen extends StatefulWidget {
  const AvatarSelectionScreen({super.key});

  @override
  State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends State<AvatarSelectionScreen> {
  static const primaryColor = Color(0xFF14B8A6);

  String? selectedAvatarId;
  final authService = Auth();


  @override
  void initState() {
    super.initState();
    loadCurrentAvatar();
  }

  Future<void> loadCurrentAvatar() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    setState(() {
      selectedAvatarId = doc.data()?["avatarId"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          "Choose Avatar",
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 55,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: selectedAvatarId == null ? null : () async {

              await authService.updateUserAvatar(selectedAvatarId!);
              if (mounted) {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              disabledBackgroundColor: Colors.grey.shade300,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Save Changes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),

      body: StreamBuilder<List<AvatarModel>>(
        stream: AvatarService.instance.streamAvatars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.grey.shade400,
                    size: 46,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Failed to load avatars",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          final avatars = snapshot.data ?? [];

          if (avatars.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.face_retouching_natural_outlined,
                    color: Colors.grey.shade400,
                    size: 46,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No avatars available",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: avatars.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final avatar = avatars[index];
              final isSelected = selectedAvatarId == avatar.id;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAvatarId = avatar.id;
                  });
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? primaryColor
                              : Colors.grey.shade200,
                          width: isSelected ? 3 : 2,
                        ),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                            : [],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: ClipOval(
                          child: Image.network(
                            avatar.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    if (isSelected)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },

      ),
    );
  }
}