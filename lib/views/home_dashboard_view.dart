import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_typography.dart';
import '../core/models/contact.dart';
import '../core/providers/wallet_provider.dart';
import 'send_money_view.dart';
import 'widgets/luxury_bottom_nav.dart';

class HomeDashboardView extends StatefulWidget {
  const HomeDashboardView({super.key});

  @override
  State<HomeDashboardView> createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends State<HomeDashboardView> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final wallet = Provider.of<WalletProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Ambient Glow
          Positioned(
            top: -size.height * 0.15,
            left: -size.width * 0.2,
            right: -size.width * 0.2,
            child: Container(
              height: size.height * 0.45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.crimsonGlow.withOpacity(0.65),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildTopBar(context),
                  const SizedBox(height: 28),

                  // Dynamic Balance
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Available balance", style: AppTypography.bodyRegular.copyWith(fontSize: 13)),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.cardSurface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.borderSubtle),
                              ),
                              child: Row(
                                children: const [
                                  Text("🇺🇸", style: TextStyle(fontSize: 10)),
                                  SizedBox(width: 4),
                                  Icon(LucideIcons.chevronDown, size: 12, color: AppColors.textMuted),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              wallet.formattedBalance,
                              style: AppTypography.balanceText.copyWith(
                                fontSize: size.width < 380 ? 28 : 34,
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => wallet.toggleBalanceVisibility(),
                              child: Icon(
                                wallet.isBalanceVisible ? LucideIcons.eye : LucideIcons.eyeOff,
                                size: 18,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),
                  _buildActionCardsGrid(context),
                  const SizedBox(height: 28),

                  Text("Quick actions", style: AppTypography.cardTitle.copyWith(fontSize: 15)),
                  const SizedBox(height: 14),
                  _buildQuickContactsTray(context),
                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Transactions", style: AppTypography.cardTitle.copyWith(fontSize: 15)),
                      Row(
                        children: const [
                          Icon(LucideIcons.search, size: 18, color: AppColors.textMuted),
                          SizedBox(width: 14),
                          Icon(LucideIcons.slidersHorizontal, size: 18, color: AppColors.textMuted),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Dynamic Transactions List
                  _buildTransactionsList(wallet),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),

          // Bottom Nav
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LuxuryBottomNav(
              selectedIndex: _navIndex,
              onItemTapped: (index) => setState(() => _navIndex = index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: const Icon(LucideIcons.layoutGrid, size: 16, color: Colors.white),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Row(
            children: const [
              CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100'),
              ),
              SizedBox(width: 8),
              Text("Personal", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
              SizedBox(width: 4),
              Icon(LucideIcons.chevronDown, size: 12, color: AppColors.textMuted),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: const Icon(LucideIcons.bell, size: 16, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildActionCardsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildActionTile(
          icon: LucideIcons.externalLink,
          label: "Send",
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SendMoneyView(recipientName: "Alexander Cole")),
            );
          },
        ),
        _buildActionTile(icon: LucideIcons.arrowDownLeft, label: "Received", onTap: () {}),
        _buildActionTile(icon: LucideIcons.repeat, label: "Swap", onTap: () {}),
        _buildActionTile(icon: LucideIcons.moreHorizontal, label: "More", onTap: () {}),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.white),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickContactsTray(BuildContext context) {
    final contacts = QuickContact.mockContacts;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: const Icon(LucideIcons.plus, size: 20, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text("Add New", style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(width: 14),
          ...contacts.map((contact) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SendMoneyView(recipientName: contact.name)),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(right: 14),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(contact.avatarUrl),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      contact.name,
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(WalletProvider wallet) {
    final txs = wallet.transactions;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: txs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final tx = txs[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.cardSurfaceLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(tx.icon, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text(tx.time, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ),
              Text(
                tx.amount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: tx.isDebit ? Colors.white : AppColors.greenTrend,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}