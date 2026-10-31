import 'package:flutter/material.dart';

class TransactionModel {
  final String title;
  final String time;
  final String amount;
  final bool isDebit;
  final IconData icon;

  TransactionModel({
    required this.title,
    required this.time,
    required this.amount,
    required this.isDebit,
    required this.icon,
  });

  static List<TransactionModel> mockTransactions = [
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
}