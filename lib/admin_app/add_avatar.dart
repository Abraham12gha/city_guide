import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../screens/app_models/avatar_model.dart';
import '../services/avatar_service.dart';
import '../services/cloudinary.dart';

class AddAvatar extends StatefulWidget {
  final AvatarModel? avatar;

  const AddAvatar({super.key, this.avatar});

  @override
  State<AddAvatar> createState() => _AddAvatarState();
}

class _AddAvatarState extends State<AddAvatar> {
  bool isLoading = false;

  File? selectedImage;
  String? existingImageUrl;

  @override
  void initState() {
    super.initState();

    if (widget.avatar != null) {
      existingImageUrl = widget.avatar!.imageUrl;
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> saveAvatar() async {
    if (selectedImage == null && existingImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an avatar image."),
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      String imageUrl = existingImageUrl ?? "";

      if (selectedImage != null) {
        final uploadedImage = await CloudinaryService().uploadImage(
          selectedImage!,
        );

        if (uploadedImage == null) {
          throw Exception("Image upload failed");
        }

        imageUrl = uploadedImage;
      }

      if (widget.avatar == null) {
        await AvatarService.instance.addAvatar(
          imageUrl: imageUrl,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Avatar added successfully"),
          ),
        );
      } else {
        await AvatarService.instance.updateAvatar(
          id: widget.avatar!.id,
          imageUrl: imageUrl,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Avatar updated successfully"),
          ),
        );
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.avatar == null ? "Add Avatar" : "Update Avatar",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: selectedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    selectedImage!,
                    fit: BoxFit.cover,
                  ),
                )
                    : existingImageUrl != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    existingImageUrl!,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 45,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Tap to choose avatar",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF14B8A6),
                  foregroundColor: Colors.white,
                ),
                onPressed: isLoading ? null : saveAvatar,
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : Text(
                  widget.avatar == null
                      ? "Add Avatar"
                      : "Update Avatar",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}