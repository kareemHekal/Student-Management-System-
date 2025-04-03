import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../colors_app.dart';
import '../firebase/firebase_functions.dart';
import '../models/payment.dart';

class PaymentWidget extends StatefulWidget {
  final Payment payment;
  int paymentIndex;

  PaymentWidget({required this.payment, required this.paymentIndex, super.key});

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
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
              _buildInfoRow(context, "Amount:",
                  "\$${widget.payment.amount.toStringAsFixed(2)}"),
              _buildInfoRow(
                  context, "Description:", widget.payment.description),
              _buildInfoRow(
                context,
                "Date:",
                DateFormat('yyyy-MM-dd').format(widget.payment.dateTime),
              ),
              _buildInfoRow(
                context,
                "Time:",
                DateFormat('hh:mm a').format(widget.payment.dateTime),
              ),
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
          "OutCome Details",
          style: TextStyle(
            color: app_colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.edit,
            color: app_colors.orange,
            size: 30,
          ),
          onPressed: () {
            _showEditDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                value,
                style: const TextStyle(
                  color: app_colors.green,
                  fontSize: 16,
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
        TextEditingController(text: widget.payment.amount.toStringAsFixed(2));
    final descriptionController =
        TextEditingController(text: widget.payment.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Outcome Bill"),
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
              onPressed: () async {
                String formattedDate =
                DateFormat('yyyy-MM-dd').format(widget.payment.dateTime);
                double parsedAmount = double.tryParse(amountController.text) ?? widget.payment.amount;

                // Create the updated payment object
                Payment updatedPayment = Payment(
                  amount: parsedAmount,
                  description: descriptionController.text,
                  dateTime: widget.payment.dateTime,
                );

                // Update in Firebase
                await FirebaseFunctions.updatePaymentInBigInvoice(
                  date: formattedDate,
                  updatedPayment: updatedPayment,
                  paymentIndex: widget.paymentIndex,
                );
                Navigator.of(context).pop();
                // Update the local widget state
                setState(() {
                  widget.payment.amount = updatedPayment.amount;
                  widget.payment.description = updatedPayment.description;
                });

                // Close the dialog
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
