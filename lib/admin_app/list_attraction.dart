import 'dart:io';

import 'package:city_guide/admin_app/add_attractions.dart';
import 'package:flutter/material.dart';

import '../services/attraction_firestore.dart';
import '../services/notification_service.dart';
import 'models/attraction_model.dart';

class ListAttraction extends StatefulWidget {
  ListAttraction({super.key});

  @override
  State<ListAttraction> createState() => _ListAttractionState();
}

class _ListAttractionState extends State<ListAttraction> {
  final _searchController = TextEditingController();

  final attractionService = AttractionService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: .start,
              children: [
                Text(
                  "Attractions",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                ),

                Text(
                  "Manage attractions and help travelers discover amazing destinations.",
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
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAttractions(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF14B8A6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Create",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.01),
                Expanded(
                  child: StreamBuilder<List<AttractionModel>>(
                    stream: AttractionService().getAttractions(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("No Attractions Found"),
                        );
                      }

                      final attractions = snapshot.data!;

                      return ListView.builder(
                        itemCount: attractions.length,
                        itemBuilder: (context, index) {
                          return AttractionCard(attraction: attractions[index]);
                        },
                      );
                    },
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

class AttractionCard extends StatelessWidget {
  final AttractionModel attraction;

  const AttractionCard({super.key, required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
                attraction.imageUrl,
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
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      attraction.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          attraction.cityName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          attraction.categoryName,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 15,
                          ),

                          const SizedBox(width: 2),

                          Text(
                            attraction.averageRating.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),

                          Text(
                            " (${attraction.totalReviews})",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),

            Column(
              children: [
                IconButton(
                  onPressed: () async {
                    await AttractionService().updateAttraction(attraction);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddAttractions(
                          attraction: attraction,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF14B8A6),
                  ),
                  visualDensity: VisualDensity.compact,
                  tooltip: "Edit",
                ),

                //
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: () async {
                    // custom alert dialog

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
                                    "Are you sure you want to delete this attraction? This action cannot be undone.",
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 20),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text("Cancel", style: TextStyle(color: Colors.black),),
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

                      await AttractionService().deleteAttraction(
                        attraction.id,
                      );

                      await NotificationService().addNotification(
                        title: "Attraction Deleted",
                        message: "${attraction.name} has been deleted.",
                        type: "attraction_deleted",
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
