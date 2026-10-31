import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';

class LuxuryBottomNav extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const LuxuryBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<LuxuryBottomNav> createState() => _LuxuryBottomNavState();
}

class _LuxuryBottomNavState extends State<LuxuryBottomNav> {
  final List<NavModel> _items = [
    NavModel(icon: LucideIcons.home, label: "Home"),
    NavModel(icon: LucideIcons.barChart2, label: "Statistic"),
    NavModel(icon: LucideIcons.creditCard, label: "Card"),
    NavModel(icon: LucideIcons.settings, label: "Settings"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF161922).withOpacity(0.92),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final isSelected = widget.selectedIndex == index;
          return GestureDetector(
            onTap: () => widget.onItemTapped(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 16 : 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.cardSurfaceLight : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    _items[index].icon,
                    size: 18,
                    color: isSelected ? Colors.white : AppColors.textMuted,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 6),
                    Text(
                      _items[index].label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class NavModel {
  final IconData icon;
  final String label;
  NavModel({required this.icon, required this.label});
}