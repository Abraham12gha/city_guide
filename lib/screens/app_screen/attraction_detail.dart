import 'package:city_guide/screens/app_screen/attractions_details/attraction_askAI.dart';
import 'package:city_guide/screens/app_screen/attractions_details/attraction_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../admin_app/models/attraction_model.dart';
import '../../map/screens/direction_screen.dart';
import '../../services/home_firestore.dart';
import '../../services/review_service.dart';
import 'attractions_details/attraction_information.dart';
import 'attractions_details/attraction_overview.dart';

class AttractionDetail extends StatefulWidget {
  final QueryDocumentSnapshot attraction;
  final bool isFavorite;

  const AttractionDetail({
    super.key,
    required this.attraction,
    required this.isFavorite,
  });

  @override
  State<AttractionDetail> createState() => _AttractionDetailState();
}

class _AttractionDetailState extends State<AttractionDetail> {
  final homeFirestore = HomeFirestore();

  late bool isFavorite;

  @override
  void initState() {
    super.initState();

    isFavorite = widget.isFavorite;
  }

  Future<void> toggleFavorite() async {
    final oldValue = isFavorite;

    setState(() {
      isFavorite = !isFavorite;
    });

    try {
      if (oldValue) {
        await homeFirestore.removeFromFavorites(widget.attraction.id);
      } else {
        await homeFirestore.addToFavorites(widget.attraction.id);
      }
    } catch (e) {
      setState(() {
        isFavorite = oldValue;
      });
    }
  }

  bool isAttractionOpen(String openingHours) {
    try {
      final parts = openingHours.split('-');

      if (parts.length != 2) return false;

      final now = DateTime.now();

      DateTime parseTime(String time) {
        final isPm = time.toLowerCase().contains('pm');

        final clean = time
            .toLowerCase()
            .replaceAll('am', '')
            .replaceAll('pm', '')
            .trim();

        final timeParts = clean.split(':');

        int hour = int.parse(timeParts[0]);
        int minute = int.parse(timeParts[1]);

        if (isPm && hour != 12) {
          hour += 12;
        }

        if (!isPm && hour == 12) {
          hour = 0;
        }

        return DateTime(now.year, now.month, now.day, hour, minute);
      }

      final openTime = parseTime(parts[0]);
      final closeTime = parseTime(parts[1]);

      return now.isAfter(openTime) && now.isBefore(closeTime);
    } catch (e) {
      return false;
    }
  }

  void openReviewSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return ReviewBottomSheet(attractionId: widget.attraction.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final isOpen = isAttractionOpen(widget.attraction['openingHours']);
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: 56,
            width: double.infinity,
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
                  MaterialPageRoute(
                    builder: (_) => DirectionScreen(
                      destinationName: widget.attraction['name'],
                      destinationLatitude:
                          (widget.attraction['latitude'] as num).toDouble(),
                      destinationLongitude:
                          (widget.attraction['longitude'] as num).toDouble(),
                    ),
                  ),
                );
              },
              child: Text(
                "Get Directions",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: curvedEdgesContainer(),
              child: Container(
                padding: const EdgeInsets.all(0),
                child: Stack(
                  children: [
                    Container(
                      width: width * 1,
                      height: height * 0.43,
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.attraction['imageUrl']),
                          fit: BoxFit.cover,
                          alignment: AlignmentGeometry.center,
                        ),
                        // borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: AlignmentGeometry.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 40,
                              ),
                              child: Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context, isFavorite);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
        
                                  GestureDetector(
                                    onTap: toggleFavorite,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        child: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          key: ValueKey(isFavorite),
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
        
                          // Align(
                          //   alignment: AlignmentGeometry.bottomRight,
                          //   child: Text(
                          //     "Closed",
                          //     style: TextStyle(color: Colors.red),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
        
                    Positioned(
                      bottom: 25,
                      right: 20,
                      child: ElevatedButton.icon(
                        onPressed: openReviewSheet,
                        icon: const Icon(Icons.star, color: Colors.black),
                        label: const Text(
                          "Rate It",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //   title
                      Expanded(
                        child: Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          widget.attraction['name'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
        
                      //   Share Button
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Icon(Icons.share, color: Colors.black87),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // city
                      Row(
                        mainAxisAlignment: .start,
                        children: [
                          Icon(Icons.location_on, color: Colors.red, size: 16),
                          Text(
                            "${widget.attraction['cityName']}, Pakistan",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
        
                      // Rating
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          Text(
                            "${widget.attraction['averageRating'].toString()} (${widget.attraction['totalReviews'].toString()})",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
        
                  SizedBox(height: height * 0.005),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                            color: isOpen ? Colors.green : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
        
                  SizedBox(height: height * 0.005),
        
                  DefaultTabController(
                    length: 4,
                    child: Column(
                      children: [
                        // TAB BAR
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                          ),
                          child: const TabBar(
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
        
                            // labelPadding: EdgeInsets.symmetric(horizontal: 16),
                            splashFactory: NoSplash.splashFactory,
                            overlayColor: WidgetStatePropertyAll(
                              Colors.transparent,
                            ),
        
                            labelColor: Color(0xFF14B8A6),
                            unselectedLabelColor: Color(0xFF6B7280),
        
                            labelStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
        
                            unselectedLabelStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
        
                            dividerColor: Colors.transparent,
        
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                color: Color(0xFF14B8A6),
                                width: 4,
                              ),
                            ),
        
                            indicatorSize: TabBarIndicatorSize.label,
        
                            tabs: [
                              Tab(text: 'Overview'),
                              Tab(text: 'Details'),
                              Tab(text: 'Review'),
                              Tab(text: 'Ask AI'),
                            ],
                          ),
                        ),
        
                        // TAB CONTENT
                        SizedBox(
                          height: 200,
                          child: TabBarView(
                            children: [
                              AttractionOverview(attraction: widget.attraction),
        
                              AttractionInformation(
                                attraction: widget.attraction,
                              ),
        
                              AttractionReview(
                                attractionId: widget.attraction.id,
                              ),
        
                              AttractionAskAi(
                                attraction: AttractionModel.fromFirestore(
                                  widget.attraction,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
        
                  // SizedBox(
                  //   height: height * 0.067,
                  //   width: width * .9,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Color(0xFF14B8A6),
                  //       foregroundColor: Colors.white,
                  //       minimumSize: const Size(double.infinity, 50),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //     ),
                  //     onPressed: (){},
                  //     child:Text(
                  //       "Start Direction",
                  //       style: TextStyle(
                  //         fontSize: 17,
                  //         fontWeight: FontWeight.w700,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class curvedEdgesContainer extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    final firstCurve = Offset(0, size.height - 20);
    final lastCurve = Offset(30, size.height - 20);
    path.quadraticBezierTo(
      firstCurve.dx,
      firstCurve.dy,
      lastCurve.dx,
      lastCurve.dy,
    );

    final secondFirstCurve = Offset(0, size.height - 20);
    final secondLastCurve = Offset(size.width - 30, size.height - 20);
    path.quadraticBezierTo(
      secondFirstCurve.dx,
      secondFirstCurve.dy,
      secondLastCurve.dx,
      secondLastCurve.dy,
    );

    final thirdFirstCurve = Offset(size.width, size.height - 20);
    final thirdLastCurve = Offset(size.width, size.height);
    path.quadraticBezierTo(
      thirdFirstCurve.dx,
      thirdFirstCurve.dy,
      thirdLastCurve.dx,
      thirdLastCurve.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

// class ReviewBottomSheet extends StatefulWidget {
//   final String attractionId;
//
//   const ReviewBottomSheet({super.key, required this.attractionId});
//
//   @override
//   State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
// }
//
// class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
//   final reviewService = ReviewFirestore();
//   double rating = 0;
//   final reviewController = TextEditingController();
//   bool isLoading = false;
//   bool isEdit = false;
//
//   Future<void> loadUserReview() async {
//     final user = FirebaseAuth.instance.currentUser;
//
//     if (user == null) return;
//
//     final review = await reviewService.getUserReview(
//       attractionId: widget.attractionId,
//       userId: user.uid,
//     );
//
//     if (review == null) return;
//
//     setState(() {
//       isEdit = true;
//
//       rating = (review['rating'] as num).toDouble();
//
//       reviewController.text = review['review'] ?? '';
//     });
//   }
//
//   Future<void> submitReview() async {
//     if (rating == 0) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please select a rating")));
//       return;
//     }
//
//     if (reviewController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please write a review")));
//       return;
//     }
//
//     try {
//       setState(() {
//         isLoading = true;
//       });
//
//       final user = FirebaseAuth.instance.currentUser;
//
//       if (user == null) return;
//
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();
//
//       final data = userDoc.data();
//
//       final firstName = data?['firstName'] ?? '';
//
//       final lastName = data?['lastName'] ?? '';
//
//       final userName = "$firstName $lastName".trim();
//
//       await reviewService.submitOrUpdateReview(
//         attractionId: widget.attractionId,
//         userId: user.uid,
//         userName: userName,
//         userPhoto: user.photoURL ?? '',
//         rating: rating,
//         review: reviewController.text.trim(),
//       );
//
//       if (!mounted) return;
//
//       Navigator.pop(context);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(isEdit ? "Review updated" : "Review submitted")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.toString())));
//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     loadUserReview();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: 20,
//         right: 20,
//         top: 20,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "Rate Your Experience",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//
//             const SizedBox(height: 20),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(5, (index) {
//                 return IconButton(
//                   onPressed: () {
//                     setState(() {
//                       rating = index + 1;
//                     });
//                   },
//                   icon: Icon(
//                     Icons.star,
//                     color: rating > index ? Colors.amber : Colors.grey,
//                   ),
//                 );
//               }),
//             ),
//
//             const SizedBox(height: 20),
//
//             TextField(
//               controller: reviewController,
//               maxLines: 4,
//               decoration: const InputDecoration(
//                 hintText: "Tell others about your experience",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: isLoading ? null : submitReview,
//                 child: isLoading
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                     : Text(isEdit ? "Update Review" : "Submit Review"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
const Color _kPrimary = Color(0xFF14B8A6);

class ReviewBottomSheet extends StatefulWidget {
  final String attractionId;

  const ReviewBottomSheet({super.key, required this.attractionId});

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  final reviewService = ReviewFirestore();
  double rating = 0;
  final reviewController = TextEditingController();
  bool isLoading = false;
  bool isEdit = false;

  static const List<String> _ratingLabels = [
    "Tap a star to rate",
    "Poor",
    "Fair",
    "Good",
    "Very Good",
    "Excellent",
  ];

  Future<void> loadUserReview() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final review = await reviewService.getUserReview(
      attractionId: widget.attractionId,
      userId: user.uid,
    );

    if (review == null) return;

    setState(() {
      isEdit = true;

      rating = (review['rating'] as num).toDouble();

      reviewController.text = review['review'] ?? '';
    });
  }

  Future<void> submitReview() async {
    if (rating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a rating")));
      return;
    }

    if (reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please write a review")));
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = userDoc.data();

      final firstName = data?['firstName'] ?? '';

      final lastName = data?['lastName'] ?? '';

      final userName = "$firstName $lastName".trim();

      await reviewService.submitOrUpdateReview(
        attractionId: widget.attractionId,
        userId: user.uid,
        userName: userName,
        userPhoto: user.photoURL ?? '',
        rating: rating,
        review: reviewController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEdit ? "Review updated" : "Review submitted")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserReview();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Header row with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEdit ? "Update Your Review" : "Rate Your Experience",
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              "Your feedback helps other travelers",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),

            const SizedBox(height: 24),

            // Star rating
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: _kPrimary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final filled = rating > index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                        child: AnimatedScale(
                          scale: filled ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 150),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Icon(
                              filled ? Icons.star_rounded : Icons.star_border_rounded,
                              size: 38,
                              color: filled ? Colors.amber : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _ratingLabels[rating.toInt()],
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: rating == 0 ? Colors.grey.shade500 : _kPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Your review",
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: reviewController,
              maxLines: 4,
              maxLength: 500,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Tell others about your experience...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.5),
                filled: true,
                fillColor: Colors.grey.shade50,
                counterStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _kPrimary, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _kPrimary.withOpacity(0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Text(
                  isEdit ? "Update Review" : "Submit Review",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}