import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'attraction_detail.dart';

class AttractionResultScreen extends StatefulWidget {
  late String searchText;
  final String? city;
  final String? category;
  final double? minRating;
  final bool favoritesOnly;
  final Set<String> favoriteIds;

  AttractionResultScreen({
    super.key,
    this.searchText = '',
    this.city,
    this.category,
    this.minRating,
    this.favoritesOnly = false,
    this.favoriteIds = const {},
  });

  @override
  State<AttractionResultScreen> createState() => _AttractionResultScreenState();
}

class _AttractionResultScreenState extends State<AttractionResultScreen> {
  String? selectedCategoryFilter;
  late TextEditingController _searchController;

  bool isGridView = true;

  late String searchText;
  String? city;
  String? selectedCategory;
  double? minRating;
  bool favoritesOnly = false;

  @override
  void initState() {
    super.initState();

    searchText = widget.searchText;
    city = widget.city;
    selectedCategory = widget.category;
    minRating = widget.minRating;
    favoritesOnly = widget.favoritesOnly;

    _searchController = TextEditingController(text: widget.searchText);
  }


  void _showFilterSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,

                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  SizedBox(height: 10,),

                  const Text(
                    "Filters",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  // DropdownButtonFormField<String>(
                  //   dropdownColor: Colors.white,
                  //   value: city,
                  //   decoration: InputDecoration(
                  //     labelText: "City",
                  //     labelStyle: const TextStyle(
                  //       color: Colors.black,
                  //     ),
                  //
                  //     floatingLabelStyle: const TextStyle(
                  //       color: Colors.black,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //     filled: true,
                  //     fillColor: Colors.white,
                  //
                  //     contentPadding: const EdgeInsets.symmetric(
                  //       horizontal: 16,
                  //       vertical: 14,
                  //     ),
                  //
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //       borderSide: BorderSide(
                  //         color: Colors.grey.shade300,
                  //       ),
                  //     ),
                  //
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //       borderSide: BorderSide(
                  //         color: Colors.grey.shade300,
                  //       ),
                  //     ),
                  //
                  //     focusedBorder: const OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(
                  //         Radius.circular(12),
                  //       ),
                  //       borderSide: BorderSide(
                  //         color: Color(0xFF14B8A6),
                  //         width: 2,
                  //       ),
                  //     ),
                  //   ),
                  //   items: const [
                  //     DropdownMenuItem(
                  //       value: "Karachi",
                  //       child: Text("Karachi"),
                  //     ),
                  //     DropdownMenuItem(value: "Lahore", child: Text("Lahore")),
                  //     DropdownMenuItem(
                  //       value: "Islamabad",
                  //       child: Text("Islamabad"),
                  //     ),
                  //   ],
                  //   onChanged: (value) {
                  //     setModalState(() {
                  //       city = value;
                  //     });
                  //   },
                  // ),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('cities')
                        .snapshots(),
                    builder: (context, snapshot) {

                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      final cities = snapshot.data!.docs;

                      return DropdownButtonFormField<String>(
                        dropdownColor: Colors.white,
                        value: city,
                        decoration: InputDecoration(
                          labelText: "City",
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          floatingLabelStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: cities.map((doc) {
                          return DropdownMenuItem<String>(
                            value: doc['name'],
                            child: Text(doc['name']),
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

                  const SizedBox(height: 15),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('categories')
                        .snapshots(),
                    builder: (context, snapshot) {

                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      final categories = snapshot.data!.docs;

                      return DropdownButtonFormField<String>(
                        dropdownColor: Colors.white,
                        value: selectedCategoryFilter,
                        decoration: InputDecoration(
                          labelText: "Category",
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),

                          floatingLabelStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: Colors.white,

                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),

                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                            borderSide: BorderSide(
                              color: Color(0xFF14B8A6),
                              width: 2,
                            ),
                          ),
                        ),
                        items: categories.map((doc) {

                          return DropdownMenuItem<String>(
                            value: doc['name'],
                            child: Text(doc['name']),
                          );

                        }).toList(),
                        onChanged: (value) {

                          setModalState(() {
                            selectedCategoryFilter = value;
                          });

                        },
                      );
                    },
                  ),
                  const SizedBox(height: 15),

                  DropdownButtonFormField<double>(
                    dropdownColor: Colors.white,
                    value: minRating,
                    decoration: InputDecoration(
                      labelText: "Minimum Rating",
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),

                      floatingLabelStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      filled: true,
                      fillColor: Colors.white,

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),

                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        borderSide: BorderSide(
                          color: Color(0xFF14B8A6),
                          width: 2,
                        ),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 3,
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 8),
                            Text("3+"),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 4,
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 8),
                            Text("4+"),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 4.5,
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star_half, color: Colors.amber, size: 16),
                            SizedBox(width: 8),
                            Text("4.5+"),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setModalState(() {
                        minRating = value;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text("Favorites Only"),
                        ),
                        Switch(
                          activeColor: const Color(0xFF14B8A6),
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

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF14B8A6),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Apply Filters"),
                  ),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        city = null;
                        selectedCategory = null;
                        minRating = null;
                        favoritesOnly = false;
                      });

                      Navigator.pop(context);
                    },
                    child: const Text("Clear Filters", style: TextStyle(color: Colors.black),),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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

      return nowMinutes >= startMinutes &&
          nowMinutes <= endMinutes;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          searchText.isNotEmpty
              ? 'Results for "$searchText"'
              : 'Filtered Results',
        ),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                        onSubmitted: (value) {
                          setState(() {
                            searchText = value.trim();
                          });
                        },
                      ),
                    ),
                  ),

                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    onTap: _showFilterSheet,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300, width: 1.5),
                            ),
                            child: Icon(Icons.tune, color: Colors.black),
                          ),

                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: .end,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        setState(() {
                          isGridView = !isGridView;
                        });
                      },
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
                        child: Icon(
                          isGridView
                              ? Icons.view_list_rounded
                              : Icons.grid_view_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('attractions')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                final results = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  final name = (data['name'] ?? '').toString().toLowerCase();

                  final category = (data['categoryName'] ?? '')
                      .toString()
                      .toLowerCase();

                  final cityName = (data['cityName'] ?? '')
                      .toString()
                      .toLowerCase();

                  final description = (data['description'] ?? '')
                      .toString()
                      .toLowerCase();

                  final rating = ((data['averageRating'] ?? 0) as num)
                      .toDouble();

                  final query = searchText.toLowerCase();

                  final matchesSearch =
                      query.isEmpty ||
                      name.contains(query) ||
                      category.contains(query) ||
                      cityName.contains(query) ||
                      description.contains(query);

                  final matchesCity =
                      city == null || cityName == city!.toLowerCase();

                  final matchesRating =
                      minRating == null || rating >= minRating!;

                  final matchesFavorites =
                      !favoritesOnly || widget.favoriteIds.contains(doc.id);

                  final matchesCategory =
                      selectedCategory == null ||
                          category == selectedCategory!.toLowerCase();



                  return matchesSearch &&
                      matchesCity &&
                      matchesCategory &&
                      matchesRating &&
                      matchesFavorites;

                }).toList();

                if (results.isEmpty) {
                  return const Center(child: Text("No attractions found"));
                }

                // return ListView.builder(
                //   padding: const EdgeInsets.all(12),
                //   itemCount: results.length,
                //   itemBuilder: (context, index) {
                //     final attraction = results[index];
                //     final openingHours = attraction['openingHours'] ?? '';
                //
                //     final isOpen = isAttractionOpen(openingHours);
                //
                //     return GestureDetector(
                //       onTap: (){
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (_) => AttractionDetail(
                //               attraction: attraction,
                //               isFavorite: widget.favoriteIds.contains(attraction.id),
                //             ),
                //           ),
                //         );
                //       },
                //       child: Card(
                //         color: Colors.white,
                //         elevation: 0,
                //         margin: const EdgeInsets.only(bottom: 12),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //         child: ListTile(
                //
                //           contentPadding: const EdgeInsets.all(10),
                //           leading: ClipRRect(
                //             borderRadius: BorderRadius.circular(8),
                //             child: Image.network(
                //               attraction['imageUrl'],
                //               width: 70,
                //               height: 70,
                //               fit: BoxFit.cover,
                //             ),
                //           ),
                //           title: Text(
                //             attraction['name'],
                //             style: const TextStyle(fontWeight: FontWeight.bold),
                //           ),
                //           subtitle: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(attraction['cityName']),
                //               Container(
                //                 padding: const EdgeInsets.symmetric(
                //                   horizontal: 8,
                //                   vertical: 4,
                //                 ),
                //                 decoration: BoxDecoration(
                //                   color: isOpen
                //                       ? Colors.green.shade50
                //                       : Colors.red.shade50,
                //                   borderRadius: BorderRadius.circular(6),
                //                 ),
                //                 child: Text(
                //                   isOpen ? "Open" : "Closed",
                //                   style: TextStyle(
                //                     color: isOpen
                //                         ? Colors.green
                //                         : Colors.red,
                //                     fontSize: 12,
                //                     fontWeight: FontWeight.w600,
                //                   ),
                //                 ),
                //               )
                //             ],
                //           ),
                //           trailing: Row(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               const Icon(
                //                 Icons.star,
                //                 size: 14,
                //                 color: Colors.amber,
                //               ),
                //               const SizedBox(width: 4),
                //               Text("${attraction['averageRating'].toString()} (${attraction['totalReviews'].toString()})"),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // );

                return isGridView
                    ? _buildGridView(results)
                    : _buildListView(results);
              },
            ),
          ),
        ],
      ),
    );
  }




  Widget _buildListView(List<QueryDocumentSnapshot> results) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final attraction = results[index];
        final openingHours = attraction['openingHours'] ?? '';

        final isOpen = isAttractionOpen(openingHours);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AttractionDetail(
                  attraction: attraction,
                  isFavorite: widget.favoriteIds.contains(attraction.id),
                ),
              ),
            );
          },
          child: Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  attraction['imageUrl'],
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                attraction['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(attraction['cityName']),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isOpen
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isOpen ? "Open" : "Closed",
                      style: TextStyle(
                        color: isOpen ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star,
                    size: 14,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${attraction['averageRating']} (${attraction['totalReviews']})",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<QueryDocumentSnapshot> results) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: results.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final attraction = results[index];
        final openingHours = attraction['openingHours'] ?? '';

        final isOpen = isAttractionOpen(openingHours);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AttractionDetail(
                  attraction: attraction,
                  isFavorite: widget.favoriteIds.contains(attraction.id),
                ),
              ),
            );
          },
          child: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// IMAGE
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.3,
                    child: Image.network(
                      attraction['imageUrl'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          attraction['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 14,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                attraction['cityName'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isOpen
                                    ? Colors.green.shade50
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isOpen ? "Open" : "Closed",
                                style: TextStyle(
                                  color: isOpen
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),


                            /// RATING
                            // Row(
                            //   children: [
                            //     const Icon(
                            //       Icons.star,
                            //       size: 14,
                            //       color: Colors.amber,
                            //     ),
                            //       Text(
                            //         "${attraction['averageRating']} (${attraction['totalReviews']})",
                            //         style: const TextStyle(fontSize: 12),
                            //         overflow: TextOverflow.ellipsis,
                            //       ),
                            //   ],
                            // ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 2),
                                  Flexible(
                                    child: Text(
                                      "${attraction['averageRating']} (${attraction['totalReviews']})",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

