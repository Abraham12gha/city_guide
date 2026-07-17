import 'package:carousel_slider/carousel_slider.dart';
import 'package:city_guide/screens/app_screen/attraction_detail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/home_firestore.dart';
import 'attraction_result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> {

  String? selectedCategoryFilter;

  void resetSearchAndFilters() {
    setState(() {
      _searchController.clear();

      searchText = '';

      selectedCityFilter = null;
      selectedCategoryFilter = null;
      selectedRatingFilter = null;
      showFavoritesOnly = false;
    });
  }

  final TextEditingController _searchController = TextEditingController();



  String searchText = '';

  String? selectedCityFilter;
  double? selectedRatingFilter;
  bool showFavoritesOnly = false;


  // Filter

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

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
                        value: selectedCityFilter,
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
                        items: cities.map((doc) {

                          return DropdownMenuItem<String>(
                            value: doc['name'],
                            child: Text(doc['name']),
                          );

                        }).toList(),
                        onChanged: (value) {

                          setModalState(() {
                            selectedCityFilter = value;
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
                    value: selectedRatingFilter,


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
                        selectedRatingFilter = value;
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
                        const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text("Favorites Only"),
                        ),
                        Switch(
                          activeColor: const Color(0xFF14B8A6),
                          value: showFavoritesOnly,
                          onChanged: (value) {
                            setModalState(() {
                              showFavoritesOnly = value;
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

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AttractionResultScreen(
                            searchText: _searchController.text.trim(),
                            city: selectedCityFilter,
                            category: selectedCategoryFilter,
                            minRating: selectedRatingFilter,
                            favoritesOnly: showFavoritesOnly,
                            favoriteIds: favoriteIds,
                          )
                        ),
                      ).then((_) {
                        resetSearchAndFilters();
                      });
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
                ],
              ),
            );
          },
        );
      },
    );
  }




  String selectedCategory = "For you";

  HomeFirestore homeFirestore = HomeFirestore();

   Set<String> favoriteIds = {};



  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favorites = await homeFirestore.loadFavorites();

    setState(() {
      favoriteIds = favorites; //what error here,
    });
  }

  Stream<QuerySnapshot> getAttractions() {
    if (selectedCategory == "For you") {
      return FirebaseFirestore.instance.collection('attractions').snapshots();
    }

    return FirebaseFirestore.instance
        .collection('attractions')
        .where('categoryName', isEqualTo: selectedCategory)
        .snapshots();
  }

  // Set<String> favoriteIds = {};

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;



    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value.toLowerCase().trim();
                        });
                      },

                      onSubmitted: (value) {
                        if (value.trim().isEmpty) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AttractionResultScreen(
                              searchText: _searchController.text.trim(),
                              city: selectedCityFilter,
                              category: selectedCategoryFilter,
                              minRating: selectedRatingFilter,
                              favoritesOnly: showFavoritesOnly,
                              favoriteIds: favoriteIds,
                            )
                          ),
                        ).then((_) {
                          resetSearchAndFilters();
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

              SizedBox(height: height * 0.01),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 1.0,
                        autoPlay: true,
                      ),
                      items: [
                        SliderImageRound(
                          imageURL: "assets/images/new_slider_3.jpg",
                        ),
                        SliderImageRound(
                          imageURL: "assets/images/new_slider_1.jpg",
                        ),
                        SliderImageRound(
                          imageURL: "assets/images/slider_2.jpg",
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),

              SizedBox(height: height * 0.01),

              // SizedBox(
              //   height: 80,
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: 6,
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (_, index) {
              //       return Column(
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.only(right: 10),
              //             child: Container(
              //               height: 56,
              //               padding: const EdgeInsets.symmetric(
              //                 horizontal: 12,
              //                 vertical: 6,
              //               ),
              //               decoration: BoxDecoration(
              //                 color: Colors.white,
              //                 borderRadius: BorderRadius.circular(10),
              //                 border: Border.all(color: Colors.grey.shade200),
              //               ),
              //               child: Center(child: Text("Mountains")),
              //             ),
              //           ),
              //         ],
              //       );
              //     },
              //   ),
              // ),
              SizedBox(
                height: 60,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: docs.length + 1,
                      itemBuilder: (context, index) {
                        final categoryName = index == 0
                            ? "For you"
                            : docs[index - 1]['name'];

                        final isSelected = selectedCategory == categoryName;

                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = categoryName;
                              });
                            },
                            child: Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF14B8A6)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF14B8A6)
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  categoryName,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: height * 0.02),

              // recommendation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommendation",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "See all",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),

              SizedBox(height: height * 0.02),


              StreamBuilder<QuerySnapshot>(
                stream: getAttractions(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final attractions = snapshot.data!.docs;

                  if (attractions.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No item found"),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: attractions.length,
                      itemBuilder: (context, index) {
                        final attraction = attractions[index];

                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AttractionDetail(
                                  attraction: attraction,
                                  isFavorite: favoriteIds.contains(attraction.id),
                                ),
                              ),
                            );



                            if (result != null) {
                              setState(() {
                                if (result == true) {
                                  favoriteIds.add(attraction.id);
                                } else {
                                  favoriteIds.remove(attraction.id);
                                }
                              });
                            }

                            await loadFavorites();
                          },
                          child: Container(
                            width: 270,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          attraction['imageUrl'],
                                          height: 160,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),

                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: GestureDetector(
                                          // onTap: () async {
                                          //   if (favoriteIds.contains(
                                          //     attraction.id,
                                          //   )) {
                                          //     await homeFirestore
                                          //         .removeFromFavorites(
                                          //           attraction.id,
                                          //         );
                                          //
                                          //     setState(() {
                                          //       favoriteIds.remove(attraction.id);
                                          //     });
                                          //   } else {
                                          //     await homeFirestore.addToFavorites(
                                          //       attraction.id,
                                          //     );
                                          //
                                          //     setState(() {
                                          //       favoriteIds.add(attraction.id);
                                          //     });
                                          //   }
                                          // },
                                            onTap: () async {
                                              final wasFavorite = favoriteIds.contains(attraction.id);

                                              // Instant UI update
                                              setState(() {
                                                if (wasFavorite) {
                                                  favoriteIds.remove(attraction.id);
                                                } else {
                                                  favoriteIds.add(attraction.id);
                                                }
                                              });

                                              try {
                                                if (wasFavorite) {
                                                  await homeFirestore.removeFromFavorites(attraction.id);
                                                } else {
                                                  await homeFirestore.addToFavorites(attraction.id);
                                                }
                                              } catch (e) {
                                                // Revert UI if save fails
                                                setState(() {
                                                  if (wasFavorite) {
                                                    favoriteIds.add(attraction.id);
                                                  } else {
                                                    favoriteIds.remove(attraction.id);
                                                  }
                                                });
                                              }
                                            },
                                          child: AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 200),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.9,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                favoriteIds.contains(attraction.id)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                key: ValueKey(favoriteIds.contains(attraction.id)),
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsetsGeometry.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text(
                                      //       attraction['name'],
                                      //       maxLines: 1,
                                      //       overflow: TextOverflow.ellipsis,
                                      //       style: const TextStyle(
                                      //         fontWeight: FontWeight.bold,
                                      //         fontSize: 16,
                                      //       ),
                                      //     ),
                                      //
                                      //     const SizedBox(height: 6),
                                      //
                                      //     Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.spaceBetween,
                                      //       children: [
                                      //         const Icon(
                                      //           Icons.star,
                                      //           size: 16,
                                      //           color: Colors.amber,
                                      //         ),
                                      //         const SizedBox(width: 4),
                                      //         Text(
                                      //           "${attraction['averageRating'].toString()} (${attraction['totalReviews'].toString()})",
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ],
                                      // ),

                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              attraction['name'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 8),

                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                size: 16,
                                                color: Colors.amber,
                                              ),

                                              const SizedBox(width: 4),

                                              Text(
                                                "${attraction['averageRating']} (${attraction['totalReviews']})",
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 6),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              attraction['cityName'],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),


              SizedBox(height: height * 0.02,),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Popular Cities",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "See all",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('cities')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final cities = snapshot.data!.docs;

                  if (cities.isEmpty) {
                    return const Center(
                      child: Text("No cities found"),
                    );
                  }

                  return SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        final city = cities[index];

                        return Container(
                          width: 220,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  city['imageUrl'],
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      city['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),


                                    Text(
                                      "Pakistan",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 4),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  city['description'] ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),


              SizedBox(height: height * 0.02,),

              // TextButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => AttractionDetail()),
              //     );
              //   },
              //   child: Text("attraction detailed"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliderImageRound extends StatelessWidget {
  const SliderImageRound({
    super.key,
    this.border,
    this.width,
    this.height,
    this.applyImageRadius = true,
    this.borderRadius = 10,
    this.backgroundColor = Colors.white,
    this.fit = BoxFit.cover,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    required this.imageURL,
  });

  final double? width, height;
  final String imageURL;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: border,
          color: backgroundColor,
        ),
        child: ClipRRect(
          // borderRadius: BorderRadius.circular(10),
          borderRadius: applyImageRadius
              ? BorderRadius.circular(borderRadius)
              : BorderRadius.circular(0),
          child: Image(
            image: isNetworkImage
                ? NetworkImage(imageURL)
                : AssetImage(imageURL) as ImageProvider,
            fit: fit,
          ),
        ),
      ),
    );
  }
}
