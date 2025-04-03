import 'package:hanan_khaled_main/models/payment.dart';
import 'Invoice.dart';


class BigInvoice {
  final String date; // Change from DateTime to String
  final String day;
  final List<Invoice> invoices;/// الدواخل
  final List<Payment> payments; // الخوارج

  BigInvoice({
    required this.date,
    required this.day,
    required this.invoices,
    required this.payments,
  });

  // From JSON
  factory BigInvoice.fromJson(Map<String, dynamic> json) {
    return BigInvoice(
      date: json['date'], // Directly take the date as a String
      day: json['day'],

      invoices: (json['invoices'] as List)
          .map((invoiceJson) => Invoice.fromJson(invoiceJson))
          .toList(),
      payments: (json['payments'] as List)
          .map((paymentJson) => Payment.fromJson(paymentJson))
          .toList(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date, // Store the date as a String
      'day': day,
      'invoices': invoices.map((invoice) => invoice.toJson()).toList(),
      'payments': payments.map((payment) => payment.toJson()).toList(),
    };
  }
}
