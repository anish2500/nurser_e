import 'package:flutter/material.dart';
import 'package:nurser_e/app/theme/theme_colors_extension.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryGreen = Colors.green;
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About NurserE',
                style: TextStyle(
                  fontFamily: 'Poppins Bold',
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                  color: primaryGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A calm, curated space for plant lovers to discover, learn, and bring nature home.',
                style: TextStyle(
                  fontFamily: 'Poppins Regular',
                  fontSize: 14,
                  color: context.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: context.cardShadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/plant2.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(
                        Icons.eco_outlined,
                        size: 48,
                        color: primaryGreen.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                title: 'What we do',
                body:
                    'NurserE helps you explore indoor, outdoor, seasonal, and fruit & herb plants with clear pricing, care tips, and curated picks.',
              ),
              const SizedBox(height: 12),
              _buildSectionCard(
                title: 'Why it matters',
                body:
                    'We believe plants make spaces healthier and happier. Our goal is to make plant selection easy, calming, and beautiful.',
              ),
              const SizedBox(height: 12),
              _buildSectionCard(
                title: 'Crafted experience',
                body:
                    'From rounded cards to soft greens, every detail is designed to feel fresh and welcoming—just like a well‑loved garden.',
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: primaryGreen.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: primaryGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.local_florist, color: primaryGreen),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Built with care for plant lovers in Nepal and beyond.',
                        style: TextStyle(
                          fontFamily: 'Poppins Regular',
                          fontSize: 13,
                          color: context.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required String body}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: context.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins Bold',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: TextStyle(
              fontFamily: 'Poppins Regular',
              fontSize: 13,
              color: context.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
