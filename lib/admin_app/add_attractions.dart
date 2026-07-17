import 'dart:io';
import '../services/attraction_firestore.dart';
import '../services/cloudinary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/notification_service.dart';
import 'models/attraction_model.dart';

class AddAttractions extends StatefulWidget {
  @override
  State<AddAttractions> createState() => _AddAttractionsState();

  final AttractionModel? attraction;

  const AddAttractions({super.key, this.attraction});
}

class _AddAttractionsState extends State<AddAttractions> {
  bool get isEdit => widget.attraction != null;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _openingHoursController = TextEditingController();

  bool isLoading = false;
  File? selectedImage;

  String? selectedCityId;
  String? selectedCityName;

  String? selectedCategoryId;
  String? selectedCategoryName;

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

  Future<void> saveAttraction() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter attraction name")),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter description")));
      return;
    }

    if (selectedCityId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a city")));
      return;
    }

    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a category")));
      return;
    }

    if (!isEdit && selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select an image")));
      return;
    }

    final latitude = double.tryParse(_latitudeController.text.trim());

    final longitude = double.tryParse(_longitudeController.text.trim());

    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid latitude or longitude")),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      String imageUrl = widget.attraction?.imageUrl ?? '';

      if (selectedImage != null) {
        final uploadedUrl = await CloudinaryService().uploadImage(
          selectedImage!,
        );

        if (uploadedUrl == null) return;

        imageUrl = uploadedUrl;
      }

      if (isEdit) {
        await AttractionService().updateAttraction(
          AttractionModel(
            id: widget.attraction!.id,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            imageUrl: imageUrl,
            address: _addressController.text.trim(),

            cityId: selectedCityId!,
            cityName: selectedCityName!,

            categoryId: selectedCategoryId!,
            categoryName: selectedCategoryName!,

            phoneNumber: _phoneController.text.trim(),
            website: _websiteController.text.trim(),
            openingHours: _openingHoursController.text.trim(),

            latitude: latitude,
            longitude: longitude,

            averageRating: widget.attraction!.averageRating,
            totalReviews: widget.attraction!.totalReviews,
          ),
        );
        await NotificationService().addNotification(
          title: "Attraction Updated",
          message: "${_nameController.text.trim()} has been updated.",
          type: "attraction_updated",
        );
      } else {
        await AttractionService().addAttraction(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),

          cityId: selectedCityId!,
          cityName: selectedCityName!,

          categoryId: selectedCategoryId!,
          categoryName: selectedCategoryName!,

          address: _addressController.text.trim(),

          latitude: latitude,
          longitude: longitude,

          phoneNumber: _phoneController.text.trim(),

          website: _websiteController.text.trim(),

          openingHours: _openingHoursController.text.trim(),

          imageUrl: imageUrl,
        );
        await NotificationService().addNotification(
          title: "New Attraction Added",
          message: "${_nameController.text.trim()} has been added.",
          type: "attraction_created",
        );
      }

      setState(() {
        _nameController.clear();
        _descriptionController.clear();

        _latitudeController.clear();
        _longitudeController.clear();

        _addressController.clear();

        _phoneController.clear();

        _websiteController.clear();

        _openingHoursController.clear();

        selectedCityId = null;
        selectedCityName = null;

        selectedCategoryId = null;
        selectedCategoryName = null;

        selectedImage = null;
      });

      SnackBar(
        content: Text(
          isEdit
              ? "Attraction Updated Successfully"
              : "Attraction Added Successfully",
        ),
      );
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.attraction != null) {
      final attraction = widget.attraction!;

      _nameController.text = attraction.name;
      _descriptionController.text = attraction.description;

      _latitudeController.text = attraction.latitude.toString();

      _longitudeController.text = attraction.longitude.toString();

      _addressController.text = attraction.address;

      _phoneController.text = attraction.phoneNumber;

      _websiteController.text = attraction.website;

      _openingHoursController.text = attraction.openingHours;

      selectedCityId = attraction.cityId;
      selectedCityName = attraction.cityName;

      selectedCategoryId = attraction.categoryId;
      selectedCategoryName = attraction.categoryName;

      // We will handle city/category IDs separately
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _openingHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .start,
            children: [
              Text(
                isEdit ? "Edit Attraction" : " Add Attraction",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: height * 0.04),

              //   inputs
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Attraction Name*",
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
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Description*",
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

              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('cities')
                    .snapshots(),

                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final cities = snapshot.data!.docs;

                  return DropdownButtonFormField<String>(
                    value: selectedCityId,

                    decoration: InputDecoration(
                      labelText: "Select City*",
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

                    items: cities.map((city) {
                      return DropdownMenuItem<String>(
                        value: city.id,
                        child: Text(city['name']),
                      );
                    }).toList(),

                    onChanged: (value) {
                      final city = cities.firstWhere((doc) => doc.id == value);

                      setState(() {
                        selectedCityId = city.id;
                        selectedCityName = city['name'];
                      });
                    },
                  );
                },
              ),

              SizedBox(height: height * 0.01),

              // TextFormField(
              //
              //   decoration: InputDecoration(
              //     labelText: "Category",
              //     labelStyle: const TextStyle(
              //       fontWeight: FontWeight.w700,
              //     ),
              //
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //       borderSide: BorderSide(
              //         color: Colors.grey.shade300,
              //         width: 1.5,
              //       ),
              //     ),
              //
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //       borderSide: const BorderSide(
              //         color: Color(0xFFBDBDBD),
              //         width: 2,
              //       ),
              //     ),
              //
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //       borderSide: BorderSide(
              //         color: Colors.grey.shade300,
              //         width: 1.5,
              //       ),
              //     ),
              //   ),
              // ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('categories')
                    .snapshots(),

                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final categories = snapshot.data!.docs;

                  return DropdownButtonFormField<String>(
                    value: selectedCategoryId,

                    decoration: InputDecoration(
                      labelText: "Select Category*",
                      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
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

                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category['name']),
                      );
                    }).toList(),

                    onChanged: (value) {
                      final category = categories.firstWhere(
                        (doc) => doc.id == value,
                      );

                      setState(() {
                        selectedCategoryId = category.id;
                        selectedCategoryName = category['name'];
                      });
                    },
                  );
                },
              ),

              SizedBox(height: height * 0.01),

              TextFormField(
                controller: _longitudeController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: "Longitude*",
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
                controller: _latitudeController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),

                decoration: InputDecoration(
                  labelText: "Latitude*",
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
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: "Address",
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
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
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
                controller: _websiteController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: "Website",
                  hintText: "https://example.com",
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
                controller: _openingHoursController,
                decoration: InputDecoration(
                  labelText: "Opening Hours",
                  hintText: "Mon-Sun 9AM - 6PM",
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
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        )
                      : widget.attraction != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.attraction!.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload_outlined),
                            Text('Upload an image'),
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
                          await saveAttraction();
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
                      : Text(isEdit ? "Update Attraction" : "Add Attraction"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
