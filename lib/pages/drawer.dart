import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Alert dialogs/Delete diaolog.dart';
import '../Alert dialogs/ResetAbscenceMonthDialog.dart';
import '../colors_app.dart';
import '../firebase/firebase_functions.dart';
import '../models/Big invoice.dart';
import '../models/payment.dart';
import 'PaymentCheckPage.dart';
import 'allgrades.dart';
import 'invoices page.dart';

class CustomDrawer extends StatefulWidget {
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  void getCurrentDate() {
    DateTime now = DateTime.now();
    date = now.toIso8601String().substring(0, 10); // yyyy-mm-dd
    Day = now.weekday == 1
        ? 'Monday'
        : now.weekday == 2
            ? 'Tuesday'
            : now.weekday == 3
                ? 'Wednesday'
                : now.weekday == 4
                    ? 'Thursday'
                    : now.weekday == 5
                        ? 'Friday'
                        : now.weekday == 6
                            ? 'Saturday'
                            : 'Sunday';
  }

  late double totalAmount; // The total amount for the payment
  late String description; // The description of the payment
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late String? date;
  late String? Day;
  bool isDangresAreaOpen = false;
  List<String> tags = [];
  List<String>? fetchedGrades;
  List<String> options = ['Absence', 'bills'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentDate();
    fetchGrades();
  }

  Future<void> fetchGrades() async {
    fetchedGrades = await FirebaseFunctions.getGradesList();
    options.addAll(fetchedGrades ?? []);
  }

  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          // Part 1: Two images in a row
          Container(
            decoration: const BoxDecoration(
              color: app_colors.green,
            ),
            width: double.infinity,
            height: 220,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    "assets/images/1......1.png",
                    height: 120,
                    width: 120,
                  ),
                  Text(
                    "Hanan Khaled",
                    style: GoogleFonts.qwitcherGrypen(
                        color: app_colors.ligthGreen, fontSize: 50),
                  ),
                ],
              ),
            ),
          ),

          // Part 2: ListView with light green background and title
          Expanded(
            child: Container(
              color: app_colors.ligthGreen,
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/StudentsTab', (route) => false);
                    },
                    child: ListTile(
                      leading:
                          Image.asset("assets/images/students.png", width: 40),
                      title: const Text(
                        "All Students",
                        style:
                            TextStyle(color: app_colors.orange, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => StartNewMonthDialog(),
                      );
                    },
                    child: ListTile(
                      leading:
                          Image.asset("assets/images/restart.png", width: 40),
                      title: const Text(
                        "Reset The Attendance",
                        style:
                            TextStyle(color: app_colors.orange, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Invoicespage()),
                        (Route<dynamic> route) =>
                            false, // This will remove all previous routes
                      );
                    },
                    child: ListTile(
                      leading:
                          Image.asset("assets/images/invoice.png", width: 40),
                      title: const Text(
                        "go and check all the invoices",
                        style:
                            TextStyle(color: app_colors.orange, fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Payment Changes Detected"),
                            content: Form(
                              key: _formKey, // GlobalKey<FormState>
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: totalAmountController,
                                    decoration: const InputDecoration(
                                      labelText: "Total Amount",
                                    ),
                                    keyboardType: TextInputType.number,
                                    // Ensure numeric input
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Total Amount cannot be empty'; // Show error if empty
                                      }
                                      return null; // Return null if validation passes
                                    },
                                  ),
                                  TextField(
                                    controller: descriptionController,
                                    decoration: const InputDecoration(
                                      labelText: "Description",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  FirebaseFirestore firestore =
                                      FirebaseFirestore.instance;
                                  DocumentSnapshot docSnapshot = await firestore
                                      .collection('big_invoices')
                                      .doc(date)
                                      .get();

                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    // If the form is valid, save the data
                                    totalAmount = double.tryParse(
                                            totalAmountController.text) ??
                                        0.0;
                                    description = descriptionController.text;

                                    // Create a new Payment object
                                    Payment newPayment = Payment(
                                      amount: totalAmount,
                                      description: description,
                                      dateTime: DateTime.now(),
                                    );

                                    if (docSnapshot.exists) {
                                      // If the document exists, retrieve the existing data
                                      Map<String, dynamic> data = docSnapshot
                                          .data() as Map<String, dynamic>;

                                      // Parse the existing document into a BigInvoice object
                                      BigInvoice bigInvoice =
                                          BigInvoice.fromJson(data);

                                      // Add the new payment to the existing list of payments
                                      bigInvoice.payments.add(newPayment);

                                      // Update the Firestore document
                                      await firestore
                                          .collection('big_invoices')
                                          .doc(date)
                                          .update(bigInvoice.toJson());
                                    } else {
                                      // If the document does not exist, create it with the new payment in the `payments` list
                                      BigInvoice bigInvoice = BigInvoice(
                                        date: date ?? "",
                                        day: Day ?? "",
                                        invoices: [],
                                        // Initialize invoices as an empty list
                                        payments: [
                                          newPayment
                                        ], // Add the new payment to the list
                                      );

                                      // Save the new document to Firestore
                                      await firestore
                                          .collection('big_invoices')
                                          .doc(date)
                                          .set(bigInvoice.toJson());
                                    }

                                    // Navigate to the Home Screen
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/HomeScreen',
                                      (route) => false,
                                    );
                                  } else {
                                    // If validation fails, don't do anything
                                    return;
                                  }
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: ListTile(
                      leading:
                          Image.asset("assets/images/clipboard.png", width: 40),
                      title: const Text(
                        "Add Outcome",
                        style:
                            TextStyle(color: app_colors.orange, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Allgrades()),
                        (Route<dynamic> route) =>
                            false, // This will remove all previous routes
                      );
                    },
                    child: ListTile(
                      leading: Image.asset("assets/images/edit-table.png", width: 40),
                      title: const Text(
                        "My Grades",
                        style:
                            TextStyle(color: app_colors.orange, fontSize: 15),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const PaymentCheckPage()),
                        (Route<dynamic> route) =>
                            false, // This will remove all previous routes
                      );
                    },
                    child:  ListTile(
                      leading:  Image.asset("assets/images/seo.png", width: 40),
                      title: const Text(
                        "Payment Check",
                        style:
                            TextStyle(color: app_colors.orange, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Part 3: Two buttons at the bottom
          GestureDetector(
            onTap: () {
              isDangresAreaOpen = !isDangresAreaOpen;
              setState(() {});
            },
            child: Container(
              decoration: const BoxDecoration(
                color: app_colors.green,
              ),
              width: double.maxFinite, // <--- Add this line
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isDangresAreaOpen == false
                          ? Icons.arrow_forward_ios_rounded
                          : Icons.keyboard_double_arrow_down_rounded,
                      color: app_colors.orange,
                    ),
                    const Spacer(),
                    const Text(
                      "Dangerous Zone",
                      style: TextStyle(color: app_colors.orange, fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
              color: app_colors.green,
              child: isDangresAreaOpen == true
                  ? Column(
                      children: [
                        const Divider(
                          endIndent: 15,
                          indent: 15,
                          color: Colors.red,
                          thickness: 2,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text("Sign out",
                                  style: TextStyle(
                                      color: app_colors.orange, fontSize: 20)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffFF0000),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // rectangular shape with rounded corners
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // center the row
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "sign out",
                                      style: TextStyle(
                                          color: app_colors.white,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/LoginPage', (route) => false);
                                },
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          endIndent: 8,
                          indent: 8,
                          color: Colors.red,
                          thickness: 2,
                        ),
                        // delete  part
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text("Delete Every Thing",
                                  style: TextStyle(
                                      color: app_colors.orange, fontSize: 20)),
                            ),
                            ChipsChoice<String>.multiple(
                              value: tags,
                              onChanged: (val) {
                                setState(() {
                                  tags = val;
                                  print(tags); // Print the tags list
                                });
                              },
                              choiceItems: C2Choice.listFrom<String, String>(
                                source: options,
                                value: (i, v) => v,
                                label: (i, v) => v,
                              ),
                              choiceStyle: C2ChipStyle.outlined(
                                borderWidth: 2,
                                backgroundColor: app_colors.orange,

                                // Text color for unselected chips
                                selectedStyle: const C2ChipStyle(
                                  borderColor: Colors.redAccent,
                                  // Border color for selected chips
                                  foregroundColor: Colors.redAccent,
                                  // Text color for selected chips
                                  backgroundColor: Colors
                                      .white, // Background color for selected chips
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffFF0000),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // rectangular shape with rounded corners
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // center the row
                                    children: [
                                      Icon(
                                        Icons.delete_sweep_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        "Delete Things you choose",
                                        style: TextStyle(
                                            color: app_colors.white,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CustomConfirmDialog(
                                          title: "Are you sure?",
                                          content:
                                              "This will delete the data you just chose. Are you sure?",
                                          tags: tags,
                                          // Pass the tags if you have them
                                          onConfirm: (tags) async {
                                            for (var tag in tags) {
                                              if (fetchedGrades!
                                                  .contains(tag)) {
                                                await FirebaseFunctions
                                                    .deleteCollection(tag);
                                                print(
                                                    'Deleted collection: $tag');
                                              } else if (tag == 'bills') {
                                                FirebaseFunctions
                                                    .deleteBigInvoiceCollection();
                                              } else {
                                                List<String> allDaysOfWeek = [
                                                  "Monday",
                                                  "Tuesday",
                                                  "Wednesday",
                                                  "Thursday",
                                                  "Friday",
                                                  "Saturday",
                                                  "Sunday"
                                                ];
                                                for (var day in allDaysOfWeek) {
                                                  await FirebaseFunctions
                                                      .deleteAbsencesSubcollection(
                                                          day);
                                                  print(
                                                      'Attempted to delete absences for $day');
                                                }
                                              }
                                            }
                                          },
                                        );
                                      },
                                    );
                                  },
                                )),
                          ],
                        ),
                      ],
                    )
                  : null)
        ],
      ),
    );
  }
}
