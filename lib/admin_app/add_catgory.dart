import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/category_firestore.dart';
import '../services/cloudinary.dart';
import '../services/notification_service.dart';
import 'models/category_model.dart';

class AddCategory extends StatefulWidget {
  final CategoryModel? category;

  const AddCategory({super.key, this.category});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  String? existingImageUrl;
  @override
  void initState() {
    super.initState();

    if (widget.category != null) {
      _categoryName.text = widget.category!.name;

      existingImageUrl = widget.category!.imageUrl;
    }
  }

  final _categoryName = TextEditingController();
  bool isLoading = false;

  File? selectedImage;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    print("Picked File: $pickedFile");

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });

      print("Image selected: ${selectedImage!.path}");
    }
  }

  Future<void> saveCategory() async {
    try {
      if (_categoryName.text.trim().isEmpty) return;

      setState(() {
        isLoading = true;
      });

      String imageUrl = existingImageUrl ?? "";

      if (selectedImage != null) {
        final uploadedImage = await CloudinaryService().uploadImage(
          selectedImage!,
        );

        if (uploadedImage != null) {
          imageUrl = uploadedImage;
        }
      }

      if (widget.category == null) {
        await CategoryService().addCategory(
          name: _categoryName.text.trim(),
          imageUrl: imageUrl,
        );
        await NotificationService().addNotification(
          title: "New Category Added",
          message: "${_categoryName.text.trim()} has been added.",
          type: "category_created",
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Category Added Successfully")),
        );
      } else {
        await CategoryService().updateCategory(
          id: widget.category!.id,
          name: _categoryName.text.trim(),
          imageUrl: imageUrl,
        );
        await NotificationService().addNotification(
          title: "Category Updated",
          message: "${_categoryName.text.trim()} has been updated.",
          type: "category_updated",
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Category Updated Successfully")),
        );
      }

      Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _categoryName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                widget.category == null ? "Add Category" : "Update Category",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: height * 0.04),

              //   inputs
              TextFormField(
                controller: _categoryName,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFFBDBDBD),
                      width: 2,
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.01),

              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  //   child: selectedImage != null
                  //     ? ClipRRect(
                  //   borderRadius: BorderRadius.circular(12),
                  //   child: Image.file(
                  //     selectedImage!,
                  //     width: double.infinity,
                  //     height: double.infinity,
                  //     fit: BoxFit.cover,
                  //   ),
                  // )
                  //     : const Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Icon(
                  //       Icons.cloud_upload_outlined,
                  //       size: 50,
                  //       color: Colors.black87,
                  //     ),
                  //     SizedBox(height: 12),
                  //     Text(
                  //       'Upload an image',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //     SizedBox(height: 4),
                  //     Text(
                  //       'PNG, JPG up to 5MB',
                  //       style: TextStyle(
                  //         color: Colors.grey,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            selectedImage!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : existingImageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            existingImageUrl!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload_outlined, size: 50),
                            SizedBox(height: 12),
                            Text("Upload an image"),
                            SizedBox(height: 4),
                            Text(
                              'PNG, JPG up to 5MB',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                ),
              ),

              SizedBox(height: height * 0.05),

              SizedBox(
                height: height * 0.067,
                width: width * .9,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLoading
                        ? Colors.grey.shade400
                        : const Color(0xFF14B8A6),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  onPressed: isLoading
                      ? null
                      : () async {
                          await saveCategory();
                        },

                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          widget.category == null
                              ? "Add Category"
                              : "Update Category",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
