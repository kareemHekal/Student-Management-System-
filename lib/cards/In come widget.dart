import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../colors_app.dart';
import '../firebase/firebase_functions.dart';
import '../models/Invoice.dart';

class InvoiceWidget extends StatelessWidget {
  final Invoice invoice;
  int incomeIndex;
  InvoiceWidget({required this.incomeIndex,required this.invoice, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: app_colors.ligthGreen,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const Divider(color: app_colors.green, thickness: 1),
              const SizedBox(height: 8),
              _buildInfoRow(
                  context, false, "Student Name:", invoice.studentName),
              _buildInfoRow(
                  context, true, "Student Phone:", invoice.studentPhoneNumber),
              _buildInfoRow(
                  context, true, "Mom's Phone:", invoice.momPhoneNumber),
              _buildInfoRow(
                  context, true, "Dad's Phone:", invoice.dadPhoneNumber),
              _buildInfoRow(context, false, "Grade:", invoice.grade),
              const SizedBox(height: 8),
              _buildInfoRow(context, false, "Amount:",
                  "\$${invoice.amount.toStringAsFixed(2)}"),
              _buildInfoRow(
                  context, false, "Description:", invoice.description),
              _buildInfoRow(context, false, "Date:",
                  DateFormat('yyyy-MM-dd').format(invoice.dateTime)),
              _buildInfoRow(context, false, "Time:",
                  DateFormat('hh:mm a').format(invoice.dateTime)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "InCome Details",
          style: TextStyle(
            color: app_colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: app_colors.orange,
              ),
              onPressed: () {
                _showEditDialog(context); // Show the edit dialog
              },
            ),

          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(
      BuildContext context, bool isPhoneNumber, String label, String value) {
    void _launchPhoneNumber(String phoneNumber) async {
      final String phoneUrl = 'tel:$phoneNumber';
      if (await canLaunchUrlString(phoneUrl)) {
        await launchUrlString(phoneUrl);
      } else {
        print('Could not launch $phoneNumber');
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: app_colors.green,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: isPhoneNumber ? () => _launchPhoneNumber(value) : null,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  value,
                  style: TextStyle(
                    color: isPhoneNumber ? app_colors.orange : app_colors.green,
                    fontSize: 16,
                    fontWeight:
                    isPhoneNumber ? FontWeight.bold : FontWeight.normal,
                    decoration: isPhoneNumber
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final amountController =
    TextEditingController(text: invoice.amount.toStringAsFixed(2));
    final descriptionController =
    TextEditingController(text: invoice.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Income Bill"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without changes
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String formattedDate =
                DateFormat('yyyy-MM-dd').format(invoice.dateTime);
                // Parse the new amount
                double parsedAmount =
                    double.tryParse(amountController.text) ?? invoice.amount;

                // Create an updated Invoice object
                Invoice updatedInvoice = Invoice(
                  amount: parsedAmount,
                  description: descriptionController.text,
                  dateTime: invoice.dateTime, // Keep the same date and time
                  studentName: invoice.studentName,
                  studentPhoneNumber: invoice.studentPhoneNumber,
                  momPhoneNumber: invoice.momPhoneNumber,
                  dadPhoneNumber: invoice.dadPhoneNumber,
                  grade: invoice.grade,
                );

                 FirebaseFunctions.updateIncomeInBigInvoice(date: formattedDate, updatedIncome: updatedInvoice, incomeIndex: incomeIndex);
                 Navigator.of(context).pop(); // Close the dialog after updating

              },
              child: const Text("OK"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Text color
              ),
            ),
          ],
        );
      },
    );
  }
}
