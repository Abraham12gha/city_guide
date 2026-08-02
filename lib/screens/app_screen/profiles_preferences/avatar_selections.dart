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
  String? selectedAvatarId;
  final authService = Auth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Choose Avatar"),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            onPressed: selectedAvatarId == null ? null : () async {

              await authService.updateUserAvatar(selectedAvatarId!);
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text("Save Changes"),
          ),
        ),
      ),
        body: StreamBuilder<List<AvatarModel>>(
          stream: AvatarService.instance.streamAvatars(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text("Failed to load avatars"),
              );
            }

            final avatars = snapshot.data ?? [];

            if (avatars.isEmpty) {
              return const Center(
                child: Text("No avatars available"),
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

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAvatarId = avatar.id;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedAvatarId == avatar.id
                            ? Colors.teal
                            : Colors.transparent,
                        width: 3,
                      ),
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
                );
              },
            );
          },

        ),
    );
  }
}