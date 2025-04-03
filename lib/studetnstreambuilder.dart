import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../cards/StudentWidget.dart';
import '../colors_app.dart';
import '../firebase/firebase_functions.dart';
import 'cards/smallStudentCard.dart';
import 'models/Studentmodel.dart';

class StudentStreamBuilder extends StatefulWidget {
  final String grade;

  StudentStreamBuilder({required this.grade, super.key});

  @override
  State<StudentStreamBuilder> createState() => _StudentStreamBuilderState();
}

class _StudentStreamBuilderState extends State<StudentStreamBuilder> {
  final _searchController = TextEditingController();
  List<Studentmodel> _filteredStudents = [];
  int numberofstudents = 0;
  bool islarge = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterStudents);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStudents);
    _searchController.dispose();
    super.dispose();
  }

  void _filterStudents() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredStudents.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Center(child: Image.asset("assets/images/1......1.png")),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: app_colors.green,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.print,
                                      color: Colors.white),
                                  onPressed: () async {
                                    if (_filteredStudents.isNotEmpty) {
                                      await _generatePdf(_filteredStudents);
                                    } else {
                                      print("No students to export");
                                    }
                                  },
                                ),
                                Text(
                                  "Number of students: $numberofstudents",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                LiteRollingSwitch(
                                  width: 110,
                                  value: true,
                                  textOn: 'Large',
                                  textOff: 'Small',
                                  colorOn: app_colors.ligthGreen,
                                  colorOff: app_colors.orange,
                                  iconOn: Icons.done,
                                  iconOff: Icons.remove_circle_outline,
                                  textSize: 16.0,
                                  onSwipe: () {},
                                  onChanged: (value) {
                                    setState(() {
                                      islarge = value;
                                    });
                                  },
                                  onTap: () {},
                                  onDoubleTap: () {},
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: TextFormField(
                              style: const TextStyle(color: app_colors.green),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Search',
                                hintStyle:
                                    const TextStyle(color: app_colors.green),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: app_colors.orange, width: 2.0),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: app_colors.orange, width: 2.0),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: app_colors.orange),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                ),
                              ),
                              cursorColor: app_colors.green,
                              controller: _searchController,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: StreamBuilder<List<Studentmodel>>(
                        stream: FirebaseFunctions.getAllStudentsByGrade(
                            widget.grade),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Studentmodel>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (numberofstudents != 0) {
                                setState(() {
                                  numberofstudents = 0;
                                });
                              }
                            });
                            return Center(
                                child: Text(
                                    'No students found for grade: ${widget.grade}.'));
                          }

                          var students = snapshot.data!;

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (numberofstudents != students.length) {
                              setState(() {
                                numberofstudents = students.length;
                              });
                            }
                          });

                          if (_searchController.text.isNotEmpty) {
                            _filteredStudents = students.where((student) {
                              return student.name?.toLowerCase().contains(
                                      _searchController.text.toLowerCase()) ??
                                  false;
                            }).toList();
                          } else {
                            _filteredStudents = students;
                          }

                          return ListView.builder(
                            itemCount: _filteredStudents.length,
                            itemBuilder: (context, index) {
                              final student = _filteredStudents[index];
                              return islarge
                                  ? StudentWidget(
                                      studentModel: student,
                                      grade: widget.grade,
                                      IsComingFromGroup: false,
                                    )
                                  : Smallstydentcard(
                                      studentModel: student,
                                      grade: widget.grade,
                                    );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _generatePdf(List<Studentmodel> students) async {
    final pdf = pw.Document();
    const int crossAxisCount = 3; // Number of cards per row
    const int maxRowsPerPage = 5; // Maximum number of rows per page
    const double cardWidth = 150.0; // Set the card width
    const double cardHeight = 120.0; // Set the card height
    const double spacing = 8.0; // Space between cards

    // Load your desired font
    final fontData = await rootBundle.load("fonts/NotoKufiArabic-Regular.ttf");
    final pw.Font font = pw.Font.ttf(fontData);

    final int totalStudents = students.length;
    final int totalCardsPerPage =
        crossAxisCount * maxRowsPerPage; // 18 cards per page
    final int totalPages =
        (totalStudents / totalCardsPerPage).ceil(); // Calculate number of pages

    for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              children: List.generate(maxRowsPerPage, (rowIndex) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: List.generate(crossAxisCount, (colIndex) {
                    // Calculate the current student's index
                    final studentIndex = pageIndex * totalCardsPerPage +
                        rowIndex * crossAxisCount +
                        colIndex;

                    if (studentIndex < totalStudents) {
                      final student = students[studentIndex];
                      final nameText = student.name ?? "Unknown Student";

                      return pw.Container(
                        width: cardWidth,
                        height: cardHeight,
                        padding: const pw.EdgeInsets.all(4),
                        margin: pw.EdgeInsets.all(spacing / 2),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey),
                          borderRadius: pw.BorderRadius.circular(8),
                        ),
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              nameText.length > 20
                                  ? nameText.substring(0, 20) + '...'
                                  : nameText,
                              style: pw.TextStyle(font: font, fontSize: 10),
                              textDirection: pw.TextDirection.rtl,
                            ),
                            pw.SizedBox(height: 5.0),
                            pw.BarcodeWidget(
                              data: student.id ?? "No ID",
                              barcode: pw.Barcode.qrCode(),
                              width: 50.0,
                              height: 50.0,
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Empty container to align remaining cells in last row
                      return pw.SizedBox(
                        width: cardWidth,
                        height: cardHeight,
                      );
                    }
                  }),
                );
              }),
            );
          },
        ),
      );
    }

    // Print the document
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
