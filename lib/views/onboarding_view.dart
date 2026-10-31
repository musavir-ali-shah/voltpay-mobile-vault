

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_typography.dart';
import 'home_dashboard_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _idleController;

  // Touch drag coordinates for real 3D perspective
  double _dragX = 0.0;
  double _dragY = 0.0;

  @override
  void initState() {
    super.initState();
    // Ambient floating breath animation (runs when not interacting)
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Atmospheric Ambient Crimson Glow
          Positioned(
            top: -size.height * 0.15,
            left: -size.width * 0.2,
            right: -size.width * 0.2,
            child: Container(
              height: size.height * 0.55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.crimsonGlow.withOpacity(0.85),
                    AppColors.crimsonGlow.withOpacity(0.2),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // 2. Main Responsive Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 10),

                          // 3. Interactive 3D Card Stage with Gesture Detection
                          GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                _dragX += details.delta.dx * 0.005;
                                _dragY -= details.delta.dy * 0.005;
                                _dragX = _dragX.clamp(-0.4, 0.4);
                                _dragY = _dragY.clamp(-0.4, 0.4);
                              });
                            },
                            onPanEnd: (_) {
                              // Smooth reset to origin
                              setState(() {
                                _dragX = 0.0;
                                _dragY = 0.0;
                              });
                            },
                            child: AnimatedBuilder(
                              animation: _idleController,
                              builder: (context, child) {
                                final idleFloat = math.sin(_idleController.value * 2 * math.pi) * 8;
                                final idleRot = math.sin(_idleController.value * 2 * math.pi) * 0.03;

                                return Container(
                                  height: isSmallScreen ? size.height * 0.38 : size.height * 0.44,
                                  color: Colors.transparent, // Hitbox
                                  child: Stack(
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.none,
                                    children: [
                                      // BACK CARD (Deep Matte Titanium)
                                      Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.identity()
                                          ..setEntry(3, 2, 0.0015) // 3D Perspective focal depth
                                          ..rotateX(_dragY * 0.7 + idleRot)
                                          ..rotateY(_dragX * 0.7)
                                          ..rotateZ(-math.pi / 14 + idleRot * 0.5)
                                          ..translate(-35.0, 10.0 + idleFloat * 0.6),
                                        child: _buildLuxuryCard(
                                          isBackCard: true,
                                          width: size.width * 0.55,
                                          height: size.width * 0.85,
                                        ),
                                      ),

                                      // FOREGROUND CARD (Polished Obsidian VISA)
                                      Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.identity()
                                          ..setEntry(3, 2, 0.0018) // Foreground 3D depth
                                          ..rotateX(_dragY + idleRot)
                                          ..rotateY(_dragX)
                                          ..rotateZ(math.pi / 16 + idleRot * 0.8)
                                          ..translate(40.0, -10.0 - idleFloat),
                                        child: _buildLuxuryCard(
                                          isBackCard: false,
                                          width: size.width * 0.55,
                                          height: size.width * 0.85,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          // Text & Button Actions
                          Column(
                            children: [
                              Text(
                                "Smarter payments. Better\nmoney management.",
                                textAlign: TextAlign.center,
                                style: AppTypography.heroHeading.copyWith(
                                  fontSize: isSmallScreen ? 24 : 30,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  "Simplify payments, streamline expenses, and enjoy better control over your financial journey.",
                                  textAlign: TextAlign.center,
                                  style: AppTypography.bodyRegular.copyWith(
                                    fontSize: isSmallScreen ? 12 : 14,
                                    height: 1.5,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Continue with Google Button
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: () => _navigateToDashboard(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.buttonWhite,
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(LucideIcons.chrome, size: 18, color: Colors.black),
                                      const SizedBox(width: 10),
                                      const Text(
                                        "Continue with Google",
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Continue with Apple Button
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: OutlinedButton(
                                  onPressed: () => _navigateToDashboard(context),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: AppColors.cardSurface.withOpacity(0.6),
                                    side: const BorderSide(color: AppColors.borderSubtle),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(LucideIcons.apple, size: 20, color: Colors.white),
                                      SizedBox(width: 10),
                                      Text(
                                        "Continue with Apple",
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Already have an account? ", style: AppTypography.bodyRegular.copyWith(fontSize: 13)),
                                  GestureDetector(
                                    onTap: () => _navigateToDashboard(context),
                                    child: const Text(
                                      "Log in",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeDashboardView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Widget _buildLuxuryCard({
    required bool isBackCard,
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isBackCard ? const Color(0xFF151821) : const Color(0xFF1E2333),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isBackCard ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isBackCard ? Colors.black.withOpacity(0.5) : AppColors.crimsonGlow.withOpacity(0.25),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: isBackCard
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 38,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9).withOpacity(0.7),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black26),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.crimsonAccent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.zap, size: 16, color: AppColors.crimsonAccent),
            ),
          ),
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("VISA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.5)),
              Icon(LucideIcons.wifi, size: 16, color: Colors.white70),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("ALEXANDER COLE", style: TextStyle(color: Colors.white60, fontSize: 9, letterSpacing: 1)),
              SizedBox(height: 4),
              Text("4000 1234 5678 9010", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("11/27", style: TextStyle(color: Colors.white60, fontSize: 10)),
              Icon(LucideIcons.shieldCheck, size: 16, color: AppColors.crimsonAccent),
            ],
          ),
        ],
      ),
    );
  }
}