import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../cards/Big invoice card.dart';
import '../colors_app.dart';
import '../home.dart';
import '../models/Big invoice.dart';

class Invoicespage extends StatefulWidget {
  const Invoicespage({super.key});

  @override
  _InvoicespageState createState() => _InvoicespageState();
}

class _InvoicespageState extends State<Invoicespage> {
  final TextEditingController _searchController = TextEditingController();
  List<BigInvoice> allInvoices = [];
  List<BigInvoice> filteredInvoices = [];

  @override
  void initState() {
    super.initState();
    // Fetch invoices from Firestore and filter them initially
    _fetchInvoices();
  }

  // Fetch invoices from Firestore and filter based on the initial search term
  Future<void> _fetchInvoices() async {
    final snapshot = await FirebaseFirestore.instance.collection('big_invoices').get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        // Convert documents to BigInvoice model
        allInvoices = snapshot.docs.map((doc) {
          return BigInvoice.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        // Initially, we set filteredInvoices to allInvoices (no filtering)
        filteredInvoices = allInvoices;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Homescreen(),
              ),
                  (route) => false, // This ensures all previous routes are removed.
            );
          },
          icon: const Icon(Icons.arrow_back_ios, color: app_colors.orange),
        ),
        backgroundColor: app_colors.green,
        title: Image.asset(
          "assets/images/2....2.png",
          height: 100,
          width: 90,
        ),
        toolbarHeight: 130,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Center(child: Image.asset("assets/images/1......1.png")),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search by Date (yyyy_mm_dd)',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        // Filter invoices based on whether the date contains the search term
                        filteredInvoices = allInvoices.where((invoice) {
                          return invoice.date.contains(value); // Check if the date contains the search term
                        }).toList();
                      } else {
                        filteredInvoices = allInvoices; // Show all invoices if the search is empty
                      }
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredInvoices.isNotEmpty
                      ? filteredInvoices.length
                      : 1,
                  itemBuilder: (context, index) {
                    if (filteredInvoices.isNotEmpty) {
                      return BigInvoiceCard(invoice: filteredInvoices[index]);
                    } else {
                      return const Center(child: Text('No invoices found for the given date'));
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

