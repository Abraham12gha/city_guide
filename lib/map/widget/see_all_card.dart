import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttractionCard extends StatelessWidget {
  final QueryDocumentSnapshot attraction;
  final bool showFavorite;
  final bool isFavorite;
  final bool enableNavigation;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool showStatus;

  const AttractionCard({
    super.key,
    required this.attraction,
    this.showFavorite = false,
    this.isFavorite = false,
    this.enableNavigation = true,
    this.onTap,
    this.onFavoriteTap,
    this.showStatus = true,
  });

  bool _isOpen(String openingHours) {
    try {
      final parts = openingHours.split('-');

      if (parts.length != 2) return false;

      final now = DateTime.now();

      TimeOfDay parseTime(String timeStr) {
        timeStr = timeStr.trim().toLowerCase();

        final isPm = timeStr.contains('pm');
        final isAm = timeStr.contains('am');

        timeStr =
            timeStr.replaceAll('am', '').replaceAll('pm', '');

        final split = timeStr.split(':');

        int hour = int.parse(split[0]);
        int minute = int.parse(split[1]);

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
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOpen =
    _isOpen(attraction['openingHours'] ?? '');

    return GestureDetector(
      onTap: enableNavigation ? onTap : null,
      child: Container(
        width: 270,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.all(5),
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

                  if (showFavorite)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: onFavoriteTap,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 5),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          attraction['name'],
                          maxLines: 2,
                          overflow:
                          TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            "${attraction['averageRating']} (${attraction['totalReviews']})",
                            style: const TextStyle(
                                fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 8),

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
                          overflow:
                          TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),

                  if (showStatus) ...[
                    const SizedBox(height: 10),

                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isOpen
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius:
                        BorderRadius.circular(6),
                      ),
                      child: Text(
                        isOpen ? "Open" : "Closed",
                        style: TextStyle(
                          color: isOpen
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}