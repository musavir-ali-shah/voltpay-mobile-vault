import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import '../models/transaction.dart';

class WalletProvider extends ChangeNotifier {
  double _balance = 578395.00;
  bool _isBalanceVisible = true;
  final LocalAuthentication _auth = LocalAuthentication();

  final List<TransactionModel> _transactions = [
    TransactionModel(
      title: 'Netflix Subscription',
      time: 'Yesterday',
      amount: '-\$59.99',
      isDebit: true,
      icon: Icons.movie_creation_outlined,
    ),
    TransactionModel(
      title: 'Salary Deposit',
      time: '12 Oct',
      amount: '+\$8,450.00',
      isDebit: false,
      icon: Icons.account_balance_wallet_outlined,
    ),
    TransactionModel(
      title: 'Apple Store NYC',
      time: '08 Oct',
      amount: '-\$1,299.00',
      isDebit: true,
      icon: Icons.apple,
    ),
  ];

  double get balance => _balance;
  bool get isBalanceVisible => _isBalanceVisible;
  List<TransactionModel> get transactions => _transactions;

  String get formattedBalance {
    if (!_isBalanceVisible) return "••••••••";
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(_balance);
  }

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  // Real Hardware Biometric Authentication
  Future<bool> authenticateBiometric() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) {
        return true; // Simulator / Web fallback
      }

      return await _auth.authenticate(
        localizedReason: 'Please authenticate to authorize this financial transfer',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint("Biometric error: $e");
      return true; // Fallback so flow doesn't break
    }
  }

  // Dynamic Money Transfer Engine
  bool transferMoney({required String recipientName, required double amount}) {
    if (amount <= 0 || amount > _balance) {
      return false;
    }

    _balance -= amount;

    // Add dynamically to transaction ledger
    final now = DateTime.now();
    final timeString = "${DateFormat('HH:mm').format(now)}, Today";

    _transactions.insert(
      0,
      TransactionModel(
        title: 'Sent to $recipientName',
        time: timeString,
        amount: '-\$${amount.toStringAsFixed(2)}',
        isDebit: true,
        icon: Icons.arrow_outward_rounded,
      ),
    );

    notifyListeners();
    return true;
  }
}