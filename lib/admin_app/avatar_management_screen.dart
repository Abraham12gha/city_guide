// import 'package:flutter/material.dart';
//
// import '../screens/app_models/avatar_model.dart';
// import '../services/avatar_service.dart';
// import 'add_avatar.dart';
//
// class AvatarManagementScreen extends StatelessWidget {
//   const AvatarManagementScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Avatar Management"),
//         backgroundColor: Colors.white,
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFF14B8A6),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const AddAvatar(),
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: StreamBuilder<List<AvatarModel>>(
//         stream: AvatarService.instance.streamAvatars(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(snapshot.error.toString()),
//             );
//           }
//
//           final avatars = snapshot.data ?? [];
//
//           if (avatars.isEmpty) {
//             return const Center(
//               child: Text("No avatars found"),
//             );
//           }
//
//           return GridView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: avatars.length,
//             gridDelegate:
//             const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//               childAspectRatio: .8,
//             ),
//             itemBuilder: (context, index) {
//               final avatar = avatars[index];
//
//               return Card(
//                 elevation: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8),
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: ClipOval(
//                           child: Image.network(
//                             avatar.imageUrl,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 8),
//
//                       Row(
//                         mainAxisAlignment:
//                         MainAxisAlignment.spaceEvenly,
//                         children: [
//                           IconButton(
//                             icon: const Icon(
//                               Icons.edit,
//                               color: Color(0xFF14B8A6),
//                             ),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) =>
//                                       AddAvatar(avatar: avatar),
//                                 ),
//                               );
//                             },
//                           ),
//
//                           IconButton(
//                             icon: const Icon(
//                               Icons.delete,
//                               color: Colors.red,
//                             ),
//                             onPressed: () async {
//                               final confirm =
//                               await showDialog<bool>(
//                                 context: context,
//                                 builder: (_) => AlertDialog(
//                                   title: const Text(
//                                       "Delete Avatar"),
//                                   content: const Text(
//                                     "Are you sure you want to delete this avatar?",
//                                   ),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () =>
//                                           Navigator.pop(
//                                               context, false),
//                                       child:
//                                       const Text("Cancel"),
//                                     ),
//                                     ElevatedButton(
//                                       onPressed: () =>
//                                           Navigator.pop(
//                                               context, true),
//                                       child:
//                                       const Text("Delete"),
//                                     ),
//                                   ],
//                                 ),
//                               );
//
//                               if (confirm == true) {
//                                 await AvatarService.instance
//                                     .deleteAvatar(
//                                   avatar.id,
//                                 );
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

import '../screens/app_models/avatar_model.dart';
import '../services/avatar_service.dart';
import 'add_avatar.dart';

class AvatarManagementScreen extends StatelessWidget {
  const AvatarManagementScreen({super.key});

  static const primaryColor = Color(0xFF14B8A6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          "Avatar Management",
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        elevation: 3,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddAvatar(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
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
              child: Padding(
                padding: const EdgeInsets.all(24),
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
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
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
                    "No avatars found",
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
            padding: const EdgeInsets.all(16),
            itemCount: avatars.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: .78,
            ),
            itemBuilder: (context, index) {
              final avatar = avatars[index];

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              avatar.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            color: primaryColor,
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFFF0FDFA),
                              padding: const EdgeInsets.all(8),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddAvatar(avatar: avatar),
                                ),
                              );
                            },
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete, size: 18),
                            color: Colors.red.shade400,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red.shade50,
                              padding: const EdgeInsets.all(8),
                            ),
                            onPressed: () async {
                              final confirm =
                              await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(16),
                                  ),
                                  title: const Text(
                                    "Delete Avatar",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Text(
                                    "Are you sure you want to delete this avatar?",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(
                                              context, false),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(
                                              context, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        Colors.red.shade400,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await AvatarService.instance
                                    .deleteAvatar(
                                  avatar.id,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}