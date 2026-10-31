import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_typography.dart';
import '../core/providers/wallet_provider.dart';
import 'widgets/custom_keypad.dart';

class SendMoneyView extends StatefulWidget {
  final String recipientName;

  const SendMoneyView({
    super.key,
    this.recipientName = "Alexander Cole",
  });

  @override
  State<SendMoneyView> createState() => _SendMoneyViewState();
}

class _SendMoneyViewState extends State<SendMoneyView> {
  String _amount = "0"; // Default starts at 0 now
  bool _isScheduled = false;

  void _onKeyTap(String value) {
    setState(() {
      if (_amount == "0") {
        if (value == ".") {
          _amount = "0.";
        } else {
          _amount = value;
        }
      } else {
        if (value == "." && _amount.contains(".")) return; // Avoid double decimal
        if (_amount.length < 8) {
          _amount += value;
        }
      }
    });
  }

  void _onDeleteTap() {
    setState(() {
      if (_amount.length > 1) {
        _amount = _amount.substring(0, _amount.length - 1);
      } else {
        _amount = "0";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final wallet = Provider.of<WalletProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
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
                    AppColors.crimsonGlow.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 12),
                            _buildTopBar(context),
                            const SizedBox(height: 36),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  _amount,
                                  style: AppTypography.heroHeading.copyWith(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardSurface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.borderSubtle),
                                  ),
                                  child: Row(
                                    children: const [
                                      Text("USD", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                                      SizedBox(width: 4),
                                      Icon(LucideIcons.chevronDown, size: 14, color: AppColors.textMuted),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Available balance ${wallet.formattedBalance}", style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                                const SizedBox(width: 6),
                                const Text("🇺🇸", style: TextStyle(fontSize: 10)),
                              ],
                            ),
                            const SizedBox(height: 28),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.cardSurface.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.borderSubtle),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(LucideIcons.calendar, size: 16, color: AppColors.textMuted),
                                      SizedBox(width: 10),
                                      Text("Schedule this payment", style: TextStyle(color: Colors.white, fontSize: 13)),
                                    ],
                                  ),
                                  Switch(
                                    value: _isScheduled,
                                    onChanged: (val) => setState(() => _isScheduled = val),
                                    activeColor: AppColors.buttonWhite,
                                    activeTrackColor: AppColors.crimsonAccent,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: () => _handlePaymentExecution(context, wallet),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonWhite,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                ),
                                child: const Text("Send Money", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomKeypad(
                              onKeyPressed: _onKeyTap,
                              onDeletePressed: _onDeleteTap,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ],
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

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: const Icon(LucideIcons.arrowLeft, size: 16, color: Colors.white),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100'),
              ),
              const SizedBox(width: 8),
              Text("Send to ${widget.recipientName}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
              const SizedBox(width: 4),
              const Icon(LucideIcons.chevronDown, size: 12, color: AppColors.textMuted),
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
          child: const Icon(LucideIcons.moreHorizontal, size: 16, color: Colors.white),
        ),
      ],
    );
  }

  // Senior Logic: Strict Validations + Real Hardware Biometrics
  Future<void> _handlePaymentExecution(BuildContext context, WalletProvider wallet) async {
    final double? parsedAmount = double.tryParse(_amount);

    // 1. Strict Validation: Khali ya zero amount block hogi
    if (parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.crimsonAccent,
          content: Text("Please enter an amount greater than \$0.00"),
        ),
      );
      return;
    }

    // 2. Strict Validation: Insufficient Balance Check
    if (parsedAmount > wallet.balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.crimsonAccent,
          content: Text("Insufficient funds in available vault balance!"),
        ),
      );
      return;
    }

    // 3. Real Hardware Biometric Trigger
    final bool authenticated = await wallet.authenticateBiometric();

    if (!authenticated) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.crimsonAccent,
            content: Text("Biometric verification cancelled or failed."),
          ),
        );
      }
      return;
    }

    // 4. State Update
    final success = wallet.transferMoney(
      recipientName: widget.recipientName,
      amount: parsedAmount,
    );

    if (success && mounted) {
      _showSuccessSheet(context, parsedAmount);
    }
  }

  void _showSuccessSheet(BuildContext context, double amount) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(28),
          decoration: const BoxDecoration(
            color: Color(0xFF13151E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.borderSubtle, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.greenTrend.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.greenTrend.withOpacity(0.4)),
                ),
                child: const Icon(LucideIcons.checkCheck, size: 36, color: AppColors.greenTrend),
              ),
              const SizedBox(height: 16),
              const Text("Transaction Completed", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                "Successfully transferred \$${amount.toStringAsFixed(2)} to ${widget.recipientName} via Biometric Ledger.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonWhite,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text("Return to Dashboard", style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}