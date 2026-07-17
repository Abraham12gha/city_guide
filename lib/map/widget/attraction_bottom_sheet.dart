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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              attraction.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              attraction.categoryName,
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                Expanded(
                  child: OutlinedButton(
                    onPressed: onDetails,
                    child: const Text(
                      'Details',
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: onDirections,
                    child: const Text(
                      'Directions',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}