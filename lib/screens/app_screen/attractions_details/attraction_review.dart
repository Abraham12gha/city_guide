import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../services/review_service.dart';

const Color _kPrimary = Color(0xFF14B8A6);

class AttractionReview extends StatelessWidget {
  final String attractionId;

  const AttractionReview({
    super.key,
    required this.attractionId,
  });
  Widget _ratingBar({
    required int star,
    required int count,
    required int totalReviews,
  }) {
    final progress = totalReviews == 0 ? 0.0 : count / totalReviews;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            "$star",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(_kPrimary),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 28,
            child: Text(
              count.toString(),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _kPrimary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.rate_review_outlined,
              color: _kPrimary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "No reviews yet",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Be the first to share your experience",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required double averageRating,
    required int totalReviews,
    required Map<int, int> ratingCounts,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Big average number
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  final filled = i < averageRating.round();
                  return Icon(
                    filled ? Icons.star_rounded : Icons.star_border_rounded,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 6),
              Text(
                "$totalReviews review${totalReviews == 1 ? '' : 's'}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),

          const SizedBox(width: 24),
          Container(
            width: 1,
            height: 100,
            color: Colors.grey.shade200,
          ),
          const SizedBox(width: 24),

          // Distribution bars
          Expanded(
            child: Column(
              children: [
                _ratingBar(star: 5, count: ratingCounts[5]!, totalReviews: totalReviews),
                _ratingBar(star: 4, count: ratingCounts[4]!, totalReviews: totalReviews),
                _ratingBar(star: 3, count: ratingCounts[3]!, totalReviews: totalReviews),
                _ratingBar(star: 2, count: ratingCounts[2]!, totalReviews: totalReviews),
                _ratingBar(star: 1, count: ratingCounts[1]!, totalReviews: totalReviews),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewTile(Map<String, dynamic> review) {
    final userName = (review['userName'] ?? 'Anonymous').toString();
    final userPhoto = (review['userPhoto'] ?? '').toString();
    final rating = review['rating'];
    final reviewText = (review['review'] ?? '').toString();

    final initials = userName.isNotEmpty
        ? userName.trim().split(RegExp(r'\s+')).map((e) => e[0]).take(2).join().toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: _kPrimary.withOpacity(0.12),
                backgroundImage: userPhoto.isNotEmpty ? NetworkImage(userPhoto) : null,
                child: userPhoto.isEmpty
                    ? Text(
                  initials,
                  style: const TextStyle(
                    color: _kPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 15),
                    const SizedBox(width: 3),
                    Text(
                      "$rating",
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (reviewText.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              reviewText,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.4,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviewService = ReviewFirestore();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: reviewService.getReviews(attractionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(_kPrimary),
                  ),
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _emptyState();
          }

          final reviews = snapshot.data!.docs;

          final Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
          double totalRating = 0;

          for (final doc in reviews) {
            final data = doc.data();
            final rating = (data['rating'] as num).round().clamp(1, 5);
            ratingCounts[rating] = (ratingCounts[rating] ?? 0) + 1;
            totalRating += (data['rating'] as num).toDouble();
          }

          final totalReviews = reviews.length;
          final averageRating = totalReviews == 0 ? 0.0 : totalRating / totalReviews;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryCard(
                averageRating: averageRating,
                totalReviews: totalReviews,
                ratingCounts: ratingCounts,
              ),
              const SizedBox(height: 20),
              Text(
                "All reviews",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index].data();
                  return _reviewTile(review);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}