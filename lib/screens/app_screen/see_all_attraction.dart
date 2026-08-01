import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../map/widget/shimmer loading/attraction_card_shimmer.dart';

import '../../services/home_firestore.dart';
import 'attraction_detail.dart';

class SeeAllAttractions extends StatefulWidget {
  const SeeAllAttractions({super.key});

  @override
  State<SeeAllAttractions> createState() => _SeeAllAttractionsState();
}

class _SeeAllAttractionsState extends State<SeeAllAttractions> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  HomeFirestore homeFirestore = HomeFirestore();

  List<QueryDocumentSnapshot> attractions = [];

  QueryDocumentSnapshot? lastDocument;
  bool isInitialLoading = true;
  Set<String> favoriteIds = {};
  bool isLoading = false;
  bool hasMore = true;

  static const int firstLoad = 8;
  static const int nextLoad = 6;

  String searchText = "";

  String? city;
  String? selectedCategory;
  double? minRating;
  bool favoritesOnly = false;

  Future<void> loadFavorites() async {
    favoriteIds = await homeFirestore.loadFavorites();

    if (mounted) {
      setState(() {});
    }
  }

  bool isAttractionOpen(String openingHours) {
    try {
      final parts = openingHours.split('-');

      if (parts.length != 2) return false;

      final now = DateTime.now();

      TimeOfDay parseTime(String timeStr) {
        timeStr = timeStr.trim().toLowerCase();

        final isPm = timeStr.contains('pm');
        final isAm = timeStr.contains('am');

        timeStr = timeStr.replaceAll('am', '').replaceAll('pm', '');

        final timeParts = timeStr.split(':');

        int hour = int.parse(timeParts[0]);
        int minute = int.parse(timeParts[1]);

        if (isPm && hour != 12) hour += 12;
        if (isAm && hour == 12) hour = 0;

        return TimeOfDay(hour: hour, minute: minute);
      }

      final start = parseTime(parts[0]);
      final end = parseTime(parts[1]);

      final nowMinutes = now.hour * 60 + now.minute;

      final startMinutes = start.hour * 60 + start.minute;

      final endMinutes = end.hour * 60 + end.minute;

      return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
    } catch (_) {
      return false;
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Filters",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 25),

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("cities")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }

                          return DropdownButtonFormField<String>(
                            value: city,
                            decoration: InputDecoration(
                              labelText: "City",
                              prefixIcon: const Icon(
                                Icons.location_on_outlined,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            items: snapshot.data!.docs.map((doc) {
                              return DropdownMenuItem<String>(
                                value: doc["name"],
                                child: Text(doc["name"]),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setModalState(() {
                                city = value;
                              });
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 18),

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("categories")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }

                          return DropdownButtonFormField<String>(
                            value: selectedCategory,
                            decoration: InputDecoration(
                              labelText: "Category",
                              prefixIcon: const Icon(Icons.category_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            items: snapshot.data!.docs.map((doc) {
                              return DropdownMenuItem<String>(
                                value: doc["name"],
                                child: Text(doc["name"]),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setModalState(() {
                                selectedCategory = value;
                              });
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 18),

                      DropdownButtonFormField<double>(
                        value: minRating,
                        decoration: InputDecoration(
                          labelText: "Minimum Rating",
                          prefixIcon: const Icon(Icons.star_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 3, child: Text("3+ Stars")),

                          DropdownMenuItem(value: 4, child: Text("4+ Stars")),

                          DropdownMenuItem(
                            value: 4.5,
                            child: Text("4.5+ Stars"),
                          ),
                        ],
                        onChanged: (value) {
                          setModalState(() {
                            minRating = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.favorite, color: Colors.red),

                            const SizedBox(width: 12),

                            const Expanded(
                              child: Text(
                                "Favorites Only",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),

                            Switch(
                              activeColor: const Color(0xff14B8A6),
                              value: favoritesOnly,
                              onChanged: (value) {
                                setModalState(() {
                                  favoritesOnly = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  city = null;
                                  selectedCategory = null;
                                  minRating = null;
                                  favoritesOnly = false;
                                });

                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text("Reset"),
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {});

                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff14B8A6),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text("Apply"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> loadAttractions({bool firstTime = false}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    Query query = FirebaseFirestore.instance
        .collection("attractions")
        .orderBy("name");

    if (firstTime) {
      query = query.limit(firstLoad);
    } else {
      if (lastDocument == null) return;

      query = query.startAfterDocument(lastDocument!).limit(nextLoad);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      lastDocument = snapshot.docs.last;

      attractions.addAll(snapshot.docs);
    }

    if (snapshot.docs.length < (firstTime ? firstLoad : nextLoad)) {
      hasMore = false;
    }

    setState(() {
      isLoading = false;
      isInitialLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    loadFavorites();
    loadAttractions(firstTime: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100 &&
          !isLoading &&
          hasMore) {
        loadAttractions();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        scrolledUnderElevation: 0,

        centerTitle: true,

        title: const Text(
          "Attractions",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,

                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
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
                const SizedBox(width: 10),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: _showFilterSheet,
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(Icons.tune, color: Colors.black),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Builder(
                builder: (context) {
                  final filtered = attractions.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    final name = (data["name"] ?? "").toString().toLowerCase();

                    final cityName = (data["cityName"] ?? "")
                        .toString()
                        .toLowerCase();

                    final category = (data["categoryName"] ?? "")
                        .toString()
                        .toLowerCase();

                    final description = (data["description"] ?? "")
                        .toString()
                        .toLowerCase();

                    final rating = ((data["averageRating"] ?? 0) as num)
                        .toDouble();

                    final query = searchText.toLowerCase();

                    final matchesSearch =
                        query.isEmpty ||
                            name.contains(query) ||
                            cityName.contains(query) ||
                            category.contains(query) ||
                            description.contains(query);

                    final matchesCity =
                        city == null || cityName == city!.toLowerCase();

                    final matchesCategory =
                        selectedCategory == null ||
                            category == selectedCategory!.toLowerCase();

                    final matchesRating =
                        minRating == null || rating >= minRating!;

                    final matchesFavorite =
                        !favoritesOnly || favoriteIds.contains(doc.id);

                    return matchesSearch &&
                        matchesCity &&
                        matchesCategory &&
                        matchesRating &&
                        matchesFavorite;
                  }).toList();

                  if (isInitialLoading) {
                    return const AttractionCardShimmer();
                  }

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        "No attractions found",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 5),
                    itemCount: filtered.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: .72,
                    ),
                    itemBuilder: (context, index) {
                      final attraction = filtered[index];

                      return buildCard(attraction);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(QueryDocumentSnapshot attraction) {
    final data = attraction.data() as Map<String, dynamic>;

    final isOpen = isAttractionOpen(data["openingHours"] ?? "");

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => AttractionDetail(
              attraction: attraction as QueryDocumentSnapshot,
              isFavorite: favoriteIds.contains(attraction.id),
            ),
          ),
        );

        if (result != null) {
          setState(() {
            if (result) {
              favoriteIds.add(attraction.id);
            } else {
              favoriteIds.remove(attraction.id);
            }
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 1.35,
                child: Image.network(
                  data["imageUrl"],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["name"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 15,
                        ),
                        const SizedBox(width: 4),

                        Text(
                          data["cityName"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 15,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${data["averageRating"]}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              "(${data["totalReviews"]})",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),


                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isOpen
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isOpen ? "Open Now" : "Closed",
                        style: TextStyle(
                          color: isOpen ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
