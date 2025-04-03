import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/Big invoice.dart';

class PdfGenerator {
  static Future<void> createBigInvoicePDF(BigInvoice bigInvoice, BuildContext context) async {
    final pdf = pw.Document();
    final ttf = pw.Font.ttf(await rootBundle.load("fonts/NotoKufiArabic-Regular.ttf"));
    final textStyle = pw.TextStyle(font: ttf, fontSize: 12); // Restored original card size

    // First Page with Summary Details
    pdf.addPage(
      pw.Page(
        build: (context) {
          // Convert the day number to the actual day name
          String getDayName(int weekday) {
            switch (weekday) {
              case 1:
                return "Monday";
              case 2:
                return "Tuesday";
              case 3:
                return "Wednesday";
              case 4:
                return "Thursday";
              case 5:
                return "Friday";
              case 6:
                return "Saturday";
              case 7:
                return "Sunday";
              default:
                return "";
            }
          }

          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text("Big Invoice Summary",
                  style: pw.TextStyle(font: ttf, fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.Divider(),
                pw.Text("Date: ${bigInvoice.date}", style: textStyle),
                pw.Text("Day: ${getDayName(DateTime.parse(bigInvoice.date).weekday)}", style: textStyle),
                pw.SizedBox(height: 16),
                pw.Divider(),
              ],
            ),
          );
        },
      ),

    );

    // Add Invoices (Income) in chunks of 2 per page
    if (bigInvoice.invoices.isNotEmpty) {
      for (int i = 0; i < bigInvoice.invoices.length; i += 2) {
        final chunk = bigInvoice.invoices.skip(i).take(2);
        pdf.addPage(
          pw.Page(
            build: (context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Income", style: pw.TextStyle(font: ttf, fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(),
                  ...chunk.map((invoice) {
                    return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Student Name: ${invoice.studentName}", style: textStyle),
                        pw.Text("Student Phone: ${invoice.studentPhoneNumber}", style: textStyle),
                        pw.Text("Mom's Phone: ${invoice.momPhoneNumber}", style: textStyle),
                        pw.Text("Dad's Phone: ${invoice.dadPhoneNumber}", style: textStyle),
                        pw.Text("Grade: ${invoice.grade}", style: textStyle),
                        pw.Text("Amount: \$${invoice.amount.toStringAsFixed(2)}", style: textStyle),
                        pw.Text("Description: ${invoice.description}", style: textStyle),
                        pw.Text("Date: ${invoice.dateTime.toString().split(' ')[0]}", style: textStyle),
                        pw.Text("Day: ${invoice.dateTime.weekday}", style: textStyle),
                        // Formatting time to 12-hour format with AM/PM
                        pw.Text("Time: ${_formatTime(invoice.dateTime)}", style: textStyle),
                        pw.Divider(),
                      ],
                    );
                  }).toList(),
                ],
              );
            },
          ),
        );
      }
    } else {
      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Center(
              child: pw.Text("Income List is Empty", style: pw.TextStyle(font: ttf, fontSize: 20, fontWeight: pw.FontWeight.bold)),
            );
          },
        ),
      );
    }

    // Add Payments (Outcome) in chunks of 2 per page
    if (bigInvoice.payments.isNotEmpty) {
      for (int i = 0; i < bigInvoice.payments.length; i += 2) {
        final chunk = bigInvoice.payments.skip(i).take(2);
        pdf.addPage(
          pw.Page(
            build: (context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Outcome", style: pw.TextStyle(font: ttf, fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(),
                  ...chunk.map((payment) {
                    return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Amount: \$${payment.amount.toStringAsFixed(2)}", style: textStyle),
                        pw.Text("Description: ${payment.description}", style: textStyle),
                        pw.Text("Date: ${payment.dateTime.toString().split(' ')[0]}", style: textStyle),
                        pw.Text("Day: ${payment.dateTime.weekday}", style: textStyle),
                        // Formatting time to 12-hour format with AM/PM
                        pw.Text("Time: ${_formatTime(payment.dateTime)}", style: textStyle),
                        pw.Divider(),
                      ],
                    );
                  }).toList(),
                ],
              );
            },
          ),
        );
      }
    } else {
      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Center(
              child: pw.Text("Outcome List is Empty", style: pw.TextStyle(font: ttf, fontSize: 20, fontWeight: pw.FontWeight.bold)),
            );
          },
        ),
      );
    }

    // Show the PDF using Printing.layoutPdf
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

// Static function to format time to 12-hour system with AM/PM
  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final ampm = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final formattedMinute = minute < 10 ? '0$minute' : '$minute';
    return '$hour12:$formattedMinute $ampm';
  }


}