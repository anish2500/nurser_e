
import 'package:flutter/material.dart';
import 'package:nurser_e/app/theme/theme_colors_extension.dart';

class BuildMenuItem extends StatelessWidget {
  const BuildMenuItem({
    super.key,
    required this.context,
    required this.lightGreen,
    required this.primaryGreen,
    required this.fontFamily,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final BuildContext context;
  final Color lightGreen;
  final Color primaryGreen;
  final String fontFamily;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.isDarkMode ? Colors.grey[800] : lightGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: primaryGreen),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: fontFamily,
                      color: context.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.textSecondary,
                      fontFamily: fontFamily,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: context.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
