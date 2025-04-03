class Invoice {
  final String studentName;
  final String studentPhoneNumber;
  final String momPhoneNumber;
  final String dadPhoneNumber;
  final String grade;
  final double amount;
  final String description;
  final DateTime dateTime;

  Invoice({
    required this.studentName,
    required this.studentPhoneNumber,
    required this.momPhoneNumber,
    required this.dadPhoneNumber,
    required this.grade,
    required this.amount,
    required this.description,
    required this.dateTime,
  });

  // From JSON
  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      studentName: json['studentName'],
      studentPhoneNumber: json['studentPhoneNumber'],
      momPhoneNumber: json['momPhoneNumber'],
      dadPhoneNumber: json['dadPhoneNumber'],
      grade: json['grade'],
      amount: json['amount'].toDouble(),
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'studentName': studentName,
      'studentPhoneNumber': studentPhoneNumber,
      'momPhoneNumber': momPhoneNumber,
      'dadPhoneNumber': dadPhoneNumber,
      'grade': grade,
      'amount': amount,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
