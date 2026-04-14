import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.primary),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // App wordmark
              Text(
                'Zakati',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'by Safi Solutions',
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textSecondary),
              ),

              const SizedBox(height: 32),

              // Bismillah — Amiri font for Arabic script
              Text(
                'بسم الله الرحمن الرحيم',
                style: GoogleFonts.amiri(
                  fontSize: 28,
                  color: AppColors.accent,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),

              const SizedBox(height: 40),

              Text(
                'Calculate Your Zakat',
                style: AppTextStyles.headingLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Text(
                'Zakat is one of the five pillars of Islam — a means of '
                'purifying your wealth and strengthening your community. '
                'This app will walk you through your calculation step by '
                'step, with education and context along the way.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              ElevatedButton(
                onPressed: () => context.push('/calculator/madhab'),
                child: const Text('Begin Calculation'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.push('/recipients'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.accent,
                  side: const BorderSide(color: AppColors.accent),
                ),
                child: const Text('Who Can Receive Zakat?'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.push('/runs'),
                child: const Text('View Past Runs'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
