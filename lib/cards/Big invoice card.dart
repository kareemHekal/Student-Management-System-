  import 'package:flutter/material.dart';
  import '../colors_app.dart';
import '../models/Big invoice.dart';
  import '../pages/one invoice page.dart';
import '../pages/pdfGnerator.dart';

  class BigInvoiceCard extends StatefulWidget {
    final BigInvoice invoice;

    BigInvoiceCard({required this.invoice, super.key});

    @override
    State<BigInvoiceCard> createState() => _BigInvoiceCardState();
  }

  class _BigInvoiceCardState extends State<BigInvoiceCard> {
    @override
    Widget build(BuildContext context) {
      double totalIncome = 0;
      double totalOutcome = 0;

      // Calculate the total income and outcome
      for (var inv in widget.invoice.invoices) {
        totalIncome += inv.amount;
      }

      for (var payment in widget.invoice.payments) {
        totalOutcome += payment.amount;
      }

      double total = totalIncome - totalOutcome;

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OneInivoicePage(invoice: widget.invoice),
              ),
            );
          },
          child: Card(
            color: app_colors.ligthGreen,
            child: Stack(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(widget.invoice.date, style: const TextStyle(fontSize: 16)),
                        Text(widget.invoice.day, style: const TextStyle(fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.print, size: 24, color: app_colors.orange),
                          onPressed: () async {
                            await generateBigInvoicePDF(widget.invoice);
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          showDataSummary("Income", totalIncome),
                          showDataSummary("Outcomes", totalOutcome),
                          showDataSummary("Total", total),
                        ],
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        ),
      );
    }

    Widget showDataSummary(String label, double amount) {
      return Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 15,
              color: app_colors.orange,
            ),
          ),
        ],
      );
    }

    Future<void> generateBigInvoicePDF(BigInvoice invoice) async {
      // Use your utility function to create and save the PDF
      await PdfGenerator.createBigInvoicePDF(invoice, context);
    }
  }
