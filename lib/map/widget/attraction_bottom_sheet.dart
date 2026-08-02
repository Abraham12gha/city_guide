import 'package:flutter/material.dart';

import '../../admin_app/models/attraction_model.dart';

class AttractionBottomSheet extends StatelessWidget {
  final AttractionModel attraction;
  final VoidCallback onDetails;
  final VoidCallback onDirections;

  const AttractionBottomSheet({
    super.key,
    required this.attraction,
    required this.onDetails,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF14B8A6);
    const chipBackground = Color(0xFFF0FDFA);
    const titleColor = Color(0xFF1A1A1A);
    const bodyColor = Color(0xFF4B5563);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.35,
      maxChildSize: 0.75,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [

              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  children: [

                    // Cover image with drag handle overlay
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          child: Image.network(
                            attraction.imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey.shade200,
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey.shade400,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        ),

                        Positioned(
                          top: 12,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Category chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: chipBackground,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              attraction.categoryName,
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Name
                          Text(
                            attraction.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Description
                          Text(
                            attraction.description,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: bodyColor,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Divider(color: Colors.grey.shade200),

                          const SizedBox(height: 12),

                          // Address
                          _InfoRow(
                            icon: Icons.location_on_outlined,
                            text: attraction.address,
                          ),

                          const SizedBox(height: 14),

                          // Opening hours
                          _InfoRow(
                            icon: Icons.access_time,
                            text: attraction.openingHours,
                          ),

                          if (attraction.phoneNumber.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            _InfoRow(
                              icon: Icons.call_outlined,
                              text: attraction.phoneNumber,
                            ),
                          ],

                          if (attraction.website.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            _InfoRow(
                              icon: Icons.language,
                              text: attraction.website,
                            ),
                          ],

                          const SizedBox(height: 20),

                          Divider(color: Colors.grey.shade200),

                          const SizedBox(height: 12),

                          // Rating and reviews — kept at the very bottom
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                attraction.averageRating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: titleColor,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '(${attraction.totalReviews} review${attraction.totalReviews == 1 ? '' : 's'})',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Fixed action buttons — always visible, never scroll away
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [

                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onDetails,
                          icon: const Icon(
                            Icons.info_outline,
                            size: 18,
                            color: primaryColor,
                          ),
                          label: const Text(
                            'Details',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onDirections,
                          icon: const Icon(
                            Icons.directions,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Directions',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF14B8A6);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: primaryColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }
}