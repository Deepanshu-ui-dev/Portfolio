import 'package:flutter/material.dart';
import '../../../../config/portfolio_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/animated_role_text.dart';
import '../../../../core/widgets/shared_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class MonofolioProfile extends StatelessWidget {
  const MonofolioProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "New Checkout my Article" Button
        Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 32),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.surfaceBorder, width: 1),
              color: AppColors.surfaceBorder.withOpacity(0.2), // Faint dashed look emulation
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary,
                  ),
                  child: Text(
                    'New',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.background,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),  
                const SizedBox(width: 8),
                Text(
                  'Checkout my Article',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_outward, size: 14, color: AppColors.textPrimary),
              ],
            ),
          ),
        ),

        // Profile Heading Row
        Container(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, I\'m 👋🏼',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        PortfolioConfig.name,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2, // Emulate the wide tracking seen in the screenshot's name
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.verified, color: AppColors.textPrimary, size: 24),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const AnimatedRoleText(),
                ],
              ),
              
              // Social Icons
              Row(
                children: [
                  if (PortfolioConfig.githubUrl.isNotEmpty) ...[
                    IconButton(
                      icon: const Icon(Icons.code), // Emulate github via standard material temporarily if fontawesome isn't used
                      onPressed: () => launchUrl(Uri.parse(PortfolioConfig.githubUrl)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (PortfolioConfig.linkedinUrl.isNotEmpty) ...[
                    IconButton(
                      icon: const Icon(Icons.link), // Emulate linkedin
                      onPressed: () => launchUrl(Uri.parse(PortfolioConfig.linkedinUrl)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (PortfolioConfig.twitterUrl.isNotEmpty) ...[
                    IconButton(
                      icon: const Icon(Icons.alternate_email), // Emulate twitter/x
                      onPressed: () => launchUrl(Uri.parse(PortfolioConfig.twitterUrl)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              const DashedDivider(),
            ],
          ),
        ),
      ],
    );
  }
}
