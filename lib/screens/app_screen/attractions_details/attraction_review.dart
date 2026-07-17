import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../services/review_service.dart';

class AttractionReview extends StatelessWidget {

  final String attractionId;

  const AttractionReview({
    super.key,
    required this.attractionId,
  });

  Widget ratingBar({
    required int star,
    required int count,
    required int totalReviews,
  }) {

    final progress =
    totalReviews == 0
        ? 0.0
        : count / totalReviews;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        children: [

          SizedBox(
            width: 18,
            child: Text(
              "$star",
            ),
          ),

          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 16,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius:
              BorderRadius.circular(20),
            ),
          ),

          const SizedBox(width: 8),

          Text(
            count.toString(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final reviewService = ReviewFirestore();

    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: reviewService.getReviews(
              attractionId,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No reviews yet"),
                );
              }

              final reviews = snapshot.data!.docs;

              final Map<int, int> ratingCounts = {
                1: 0,
                2: 0,
                3: 0,
                4: 0,
                5: 0,
              };

              double totalRating = 0;

              for (final doc in reviews) {

                final data = doc.data();

                final rating =
                (data['rating'] as num).round();

                ratingCounts[rating] =
                    (ratingCounts[rating] ?? 0) + 1;

                totalRating +=
                    (data['rating'] as num).toDouble();
              }

              final totalReviews = reviews.length;

              final averageRating =
              totalReviews == 0
                  ? 0
                  : totalRating / totalReviews;

              return Column(
                children: [

                  Card(
                    elevation: 0,
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [

                          Text(
                            averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 28,
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "Based on $totalReviews reviews",
                          ),

                          const SizedBox(height: 16),

                          ratingBar(
                            star: 5,
                            count: ratingCounts[5]!,
                            totalReviews: totalReviews,
                          ),

                          ratingBar(
                            star: 4,
                            count: ratingCounts[4]!,
                            totalReviews: totalReviews,
                          ),

                          ratingBar(
                            star: 3,
                            count: ratingCounts[3]!,
                            totalReviews: totalReviews,
                          ),

                          ratingBar(
                            star: 2,
                            count: ratingCounts[2]!,
                            totalReviews: totalReviews,
                          ),

                          ratingBar(
                            star: 1,
                            count: ratingCounts[1]!,
                            totalReviews: totalReviews,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {

                      final review =
                      reviews[index].data();

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [


                                  Row(
                                    children: [

                                      CircleAvatar(
                                        backgroundImage:
                                        review['userPhoto'] != ''
                                            ? NetworkImage(
                                          review['userPhoto'],
                                        )
                                            : null,

                                        child:
                                        review['userPhoto'] == ''
                                            ? const Icon(
                                          Icons.person,
                                        )
                                            : null,
                                      ),

                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: Text(
                                          review['userName'] ??
                                              'Anonymous',
                                          style: const TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      Row(
                                        children: [

                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 18,
                                          ),

                                          const SizedBox(width: 4),

                                          Text(
                                            review['rating']
                                                .toString(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    review['review'] ?? '',
                                  ),
                                ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}