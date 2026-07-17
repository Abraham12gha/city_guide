import 'package:city_guide/admin_app/add_cities.dart';
import 'package:flutter/material.dart';

import '../services/firestore.dart';
import '../services/notification_service.dart';
import 'models/city_model.dart';

class ListCities extends StatefulWidget {
  const ListCities({super.key});

  @override
  State<ListCities> createState() => _ListCitiesState();
}

class _ListCitiesState extends State<ListCities> {
  final TextEditingController _searchController = TextEditingController();

  final cityService = CityService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cities",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
              ),

              const Text(
                "Manage cities available in your application.",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),

              SizedBox(height: height * 0.01),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search attractions...",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF14B8A6),
                            width: 1.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.01),

              SizedBox(
                height: height * 0.067,
                width: width * 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddCities()),
                    );
                  },
                  child: const Text(
                    "Create",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              SizedBox(height: height * 0.01),

              Expanded(
                child: StreamBuilder<List<CityModel>>(
                  stream: cityService.getCities(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No Cities Found"));
                    }

                    final cities = snapshot.data!;

                    return ListView.builder(
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        return CityCard(city: cities[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CityCard extends StatelessWidget {
  final CityModel city;

  const CityCard({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      // padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                city.imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    // city.country,
                    "Pakistan",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Color(0xFF14B8A6)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddCities(
                          city: city,
                        ),
                      ),
                    );
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () async {
                    // final confirm = await showDialog<bool>(
                    //   context: context,
                    //   builder: (_) => AlertDialog(
                    //     title: const Text("Delete City"),
                    //     content: const Text(
                    //       "Are you sure you want to delete this city?",
                    //     ),
                    //     actions: [
                    //       TextButton(
                    //         onPressed: () => Navigator.pop(context, false),
                    //         child: const Text("Cancel"),
                    //       ),
                    //       ElevatedButton(
                    //         onPressed: () => Navigator.pop(context, true),
                    //         child: const Text("Delete"),
                    //       ),
                    //     ],
                    //   ),
                    // );
                    //
                    // if (confirm == true) {
                    //   await CityService().deleteCity(city.id);
                    // }

                    Future<bool?> showDeleteDialog(BuildContext context) {
                      return showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                    size: 50,
                                  ),

                                  const SizedBox(height: 15),

                                  const Text(
                                    "Delete Attraction?",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  const Text(
                                    "Are you sure you want to delete this City? This action cannot be undone.",
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 20),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text("Delete"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    final confirm = await showDeleteDialog(context);

                    if (confirm == true) {
                      await CityService().deleteCity(city.id);

                      await NotificationService().addNotification(
                        title: "City Deleted",
                        message: "${city.name} has been deleted.",
                        type: "city_deleted",
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
  }
}
