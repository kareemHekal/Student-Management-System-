class Payment {
  late final double amount;
  late final String description;
  final DateTime dateTime;

  Payment({
    required this.amount,
    required this.description,
    required this.dateTime,
  });

  // From JSON
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      amount: json['amount'].toDouble(),
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
