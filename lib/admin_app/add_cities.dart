import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/cloudinary.dart';
import '../services/firestore.dart';
import '../services/notification_service.dart';
import 'models/city_model.dart';

class AddCities extends StatefulWidget {
  final CityModel? city;

  const AddCities({super.key, this.city});

  @override
  State<AddCities> createState() => _AddCitiesState();
}

class _AddCitiesState extends State<AddCities> {
  bool isLoading = false;

  final _cityName = TextEditingController();
  final _discription = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.city != null) {
      _cityName.text = widget.city!.name;
      _discription.text = widget.city!.description;
      existingImageUrl = widget.city!.imageUrl;
    }
  }

  File? selectedImage;
  String? existingImageUrl;

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

  Future<void> saveCity() async {
    try {
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

      if (widget.city == null) {


        await CityService().addCity(
          name: _cityName.text.trim(),
          description: _discription.text.trim(),
          imageUrl: imageUrl,
        );

        await NotificationService().addNotification(
          title: "New City Added",
          message:
          "${_cityName.text.trim()} has been added.",
          type: "city_created",
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("City Added Successfully")),
        );
      } else {


        await CityService().updateCity(
          id: widget.city!.id,
          name: _cityName.text.trim(),
          description: _discription.text.trim(),
          imageUrl: imageUrl,
        );

        await NotificationService().addNotification(
          title: "City Updated",
          message: "${_cityName.text.trim()} has been updated.",
          type: "city_updated",
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("City Updated Successfully")),
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
    _cityName.dispose();
    _discription.dispose();
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
                widget.city == null ? "Add City" : "Update City",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: height * 0.04),

              //   inputs
              TextFormField(
                controller: _cityName,
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

              TextFormField(
                controller: _discription,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Description",
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
                            Icon(Icons.cloud_upload_outlined),
                            SizedBox(height: 12),
                            Text("Upload an image"),
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
                          await saveCity();
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
                      : Text(widget.city == null ? "Add City" : "Update City"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
