import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_colors.dart';

class ShimmerBookCard extends StatelessWidget {
  const ShimmerBookCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color(0xFFE0E0E0),
      highlightColor: Color(0xFFF5F5F5),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18, left: 8, right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFE5E7EB), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.overlay.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Book Cover Placeholder
            Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Color(0xFFC5C8CE),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 14),
            // Content Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Line 1
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFB8BBBD),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Title Line 2
                  Container(
                    height: 16,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Color(0xFFB8BBBD),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Author
                  Container(
                    height: 13,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Color(0xFFCCCFD3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Category Badges
                  Row(
                    children: [
                      Container(
                        height: 24,
                        width: 70,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFD8DBE0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Container(
                        height: 24,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Color(0xFFD8DBE0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Rating
                  Container(
                    height: 13,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Color(0xFFCCCFD3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerBookDetails extends StatelessWidget {
  const ShimmerBookDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color(0xFFE0E0E0),
      highlightColor: Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 28, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Hero Image
              Container(
                width: double.infinity,
                height: 300,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Color(0xFFB0B3BA),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 20),
              // Book Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFFE5E7EB), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.overlay.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Line 1
                    Container(
                      height: 22,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFB8BBBD),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    // Title Line 2
                    Container(
                      height: 22,
                      width: 240,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFFB8BBBD),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    // Author
                    Container(
                      height: 13,
                      width: 180,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFFCCCFD3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    // Categories
                    Row(
                      children: [
                        Container(
                          height: 28,
                          width: 85,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Color(0xFFD8DBE0),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        Container(
                          height: 28,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFFD8DBE0),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Divider
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Color(0xFFE5E7EB),
                      margin: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    // Metadata Row 1
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 11,
                                width: 85,
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFCCCFD3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              Container(
                                height: 16,
                                width: 110,
                                decoration: BoxDecoration(
                                  color: Color(0xFFB8BBBD),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 11,
                                width: 65,
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFCCCFD3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              Container(
                                height: 16,
                                width: 90,
                                decoration: BoxDecoration(
                                  color: Color(0xFFB8BBBD),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Metadata Row 2
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 11,
                                width: 75,
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFCCCFD3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              Container(
                                height: 16,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Color(0xFFB8BBBD),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 11,
                                width: 85,
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFCCCFD3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              Container(
                                height: 16,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Color(0xFFB8BBBD),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    // Add to Favorites Button
                    Container(
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFB0B3BA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Synopsis Section Title
              Container(
                height: 18,
                width: 105,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFB8BBBD),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Synopsis Text
              Container(
                height: 13,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFCCCFD3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Container(
                height: 13,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFCCCFD3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Container(
                height: 13,
                width: 180,
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  color: Color(0xFFCCCFD3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              // Reader Insights Section Title
              Container(
                height: 18,
                width: 145,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFB8BBBD),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Insights Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Color(0xFFE5E7EB), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.overlay.withValues(alpha: 0.04),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 22,
                      width: 95,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFB8BBBD),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      height: 13,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFCCCFD3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

