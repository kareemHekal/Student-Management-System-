import 'package:flutter/material.dart';
import '../Alert dialogs/DeleteIncomeBillDialog.dart';
import '../Alert dialogs/DeleteOutcomeBillDialog.dart';
import '../cards/outcome widget.dart';
import '../cards/In come widget.dart';
import '../colors_app.dart';
import '../firebase/firebase_functions.dart';
import '../models/Big invoice.dart';
import '../models/Invoice.dart';

class OneInivoicePage extends StatefulWidget {
  final BigInvoice invoice;

  OneInivoicePage({required this.invoice, super.key});

  @override
  State<OneInivoicePage> createState() => _OneInivoicePageState();
}
class _OneInivoicePageState extends State<OneInivoicePage> {
  final TextEditingController _incomeSearchController = TextEditingController();

  List<Invoice> filteredIncomeInvoices = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered lists
    filteredIncomeInvoices = widget.invoice.invoices;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: app_colors.green,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, color: app_colors.orange),
          ),
          title: Image.asset(
            "assets/images/2....2.png",
            height: 100,
            width: 90,
          ),
          toolbarHeight: 130,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.invoice.day,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.invoice.date,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const TabBar(
                  dividerHeight: 0,
                  tabs: [
                    Tab(text: "Income"),
                    Tab(text: "Outcomes"),
                  ],
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Income Tab
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _incomeSearchController,
                    decoration: const InputDecoration(
                      labelText: 'Search by Student Name',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        // Filter income invoices based on student name
                        filteredIncomeInvoices = widget.invoice.invoices
                            .where((invoice) => invoice.studentName
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredIncomeInvoices.length,
                    itemBuilder: (context, filteredIndex) {
                      // Find the real index in the original list based on the filtered index
                      int realIndex = widget.invoice.invoices.indexOf(filteredIncomeInvoices[filteredIndex]);

                      return GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteIncomeBillDialog(
                                onConfirm: () async {
                                  widget.invoice.invoices.remove(widget.invoice.invoices[realIndex]);
                                  await FirebaseFunctions.updateBigInvoice(widget.invoice.date, widget.invoice);
                                  setState(() {});
                                  print("Income bill deleted");
                                },
                                title: 'Delete Income Bill',
                                content: 'Are you sure you want to delete this income bill?',
                              );
                            },
                          );
                        },
                        child: InvoiceWidget(
                          incomeIndex: realIndex, // Pass the real index
                          invoice: filteredIncomeInvoices[filteredIndex], // Pass the filtered invoice
                        ),
                      );
                    },
                  ),
                ),

                // Display list length
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${filteredIncomeInvoices.length} Income Bill(s)',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),

            // Outcome Tab
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.invoice.payments.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteOutcomeBillDialog(
                                title: 'Delete Outcome Bill',
                                content:
                                'Are you sure you want to delete this outcome bill?',
                                onConfirm: () async {
                                  widget.invoice.payments
                                      .remove(widget.invoice.payments[index]);
                                  await FirebaseFunctions.updateBigInvoice(
                                      widget.invoice.date, widget.invoice);
                                  setState(() {});
                                  print("Outcome bill deleted");
                                },
                              );
                            },
                          );
                        },
                        child: PaymentWidget(
                          paymentIndex: index,
                          payment: widget.invoice.payments[index],
                        ),
                      );
                    },
                  ),
                ),
                // Display list length
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${widget.invoice.payments.length} Outcome Bill(s)',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
