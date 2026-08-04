/// Domain models for the wallet screen.
///
/// These are intentionally plain data classes with `fromJson` factories so the
/// same shapes work whether the data comes from the mock source
/// (`MockWalletApi`) today or the real backend later — see [WalletApi].

/// A single row in the TRANSACTION table on the wallet screen.
class WalletTransaction {
  const WalletTransaction({
    required this.points,
    required this.quantity,
    required this.date,
    required this.time,
    required this.item,
  });

  /// Points/amount column (e.g. "$50").
  final String points;
  final int quantity;

  /// Pre-formatted date column (e.g. "16-01-2026").
  final String date;

  /// Pre-formatted time column (e.g. "59:59:59").
  final String time;
  final String item;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      points: json['points']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      item: json['item']?.toString() ?? '',
    );
  }
}

/// Everything the wallet screen renders: the balance card, the points chip,
/// the "How to use" steps and the transaction history.
class WalletData {
  const WalletData({
    required this.totalBalance,
    required this.points,
    required this.maskedCardNumber,
    required this.howToUse,
    required this.transactions,
  });

  /// Pre-formatted balance shown on the blue card (e.g. "99,999.00").
  final String totalBalance;

  /// Points balance shown in the top-right chip (e.g. "999,999").
  final String points;

  /// Masked card number (e.g. "**** **** **** 4829").
  final String maskedCardNumber;

  /// Ordered "How to use" instructions.
  final List<String> howToUse;

  final List<WalletTransaction> transactions;

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      totalBalance: json['totalBalance']?.toString() ?? '0.00',
      points: json['points']?.toString() ?? '0',
      maskedCardNumber: json['maskedCardNumber']?.toString() ?? '',
      howToUse: (json['howToUse'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      transactions: (json['transactions'] as List<dynamic>? ?? [])
          .map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
