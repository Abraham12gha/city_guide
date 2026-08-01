import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AttractionCardShimmer extends StatelessWidget {
  const AttractionCardShimmer({super.key});

  Widget _box({
    required double width,
    required double height,
    BorderRadius? radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius ?? BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: .72,
      ),
      itemBuilder: (_, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(
                  width: double.infinity,
                  height: 120,
                  radius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(width: 120, height: 16),

                      const SizedBox(height: 8),

                      _box(width: 80, height: 12),

                      const SizedBox(height: 8),

                      _box(width: 100, height: 12),

                      const SizedBox(height: 10),

                      _box(width: 70, height: 22),
                    ],
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