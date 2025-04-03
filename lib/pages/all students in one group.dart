import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../cards/StudentWidget.dart';
import '../colors_app.dart';
import '../firebase/firebase_functions.dart';
import '../loadingFile/loadingWidget.dart';
import '../models/Magmo3aModel.dart';
import '../models/Studentmodel.dart';

class StudentInAgroup extends StatefulWidget {
  Magmo3amodel magmo3aModel;

  StudentInAgroup(
      {required this.magmo3aModel, super.key});

  @override
  State<StudentInAgroup> createState() => _StudentInAgroupState();
}

class _StudentInAgroupState extends State<StudentInAgroup> {
  final _searchController = TextEditingController();
  List<Studentmodel> filteredStudents = [];
  List<Studentmodel> allStudents =
      []; // This will hold the full list of students

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: app_colors.orange),
            onPressed: () async {
              await _generatePdf(
                  context); // Call the modified PDF generation method
            },
          ),
        ],
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: app_colors.orange),
        ),
        backgroundColor: app_colors.green,
        title: Image.asset(
          "assets/images/2....2.png",
          height: 100,
          width: 90,
        ),
        toolbarHeight: 150,
      ),
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
                padding: const EdgeInsets.only(bottom: 8), // Adjust as needed
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: double.infinity,
                      // Ensures the container takes the full width
                      decoration: const BoxDecoration(
                        color: app_colors.green,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        // Add some padding to prevent the field from touching edges
                        child: TextFormField(
                          style: const TextStyle(color: app_colors.green),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            // Sets the background color to white
                            hintText: 'Search',
                            hintStyle: const TextStyle(color: app_colors.green),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20.0),
                            // Adjust the internal padding of the field
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
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder(
                      stream: FirebaseFunctions.getStudentsByGroupId(
                        widget.magmo3aModel.grade??"",
                        widget.magmo3aModel.id
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: DiscreteCircle(
                              color: app_colors.green,
                              size: 30,
                              secondCircleColor: app_colors.ligthGreen,
                              thirdCircleColor: app_colors.orange,
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Something went wrong"),
                                ElevatedButton(
                                    onPressed: () {},
                                    child: const Text('Try again')),
                              ],
                            ),
                          );
                        }

                        var students =
                            snapshot.data?.docs.map((e) => e.data()).toList() ??
                                [];
                        allStudents = students;
                        if (students.isEmpty) {
                          return Center(
                            child: Text(
                              "No students found",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontSize: 25, color: app_colors.black),
                            ),
                          );
                        }

                        filteredStudents = students;

                        if (_searchController.text.isNotEmpty) {
                          filteredStudents = students.where((student) {
                            return student.name?.toLowerCase().contains(
                                    _searchController.text.toLowerCase()) ??
                                false;
                          }).toList();
                        }

                        return Expanded(
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 5),
                            itemBuilder: (context, index) {
                              return StudentWidget(
                                IsComingFromGroup: true,
                                grade: filteredStudents[index].grade,
                                studentModel: filteredStudents[index],
                              );
                            },
                            itemCount: filteredStudents.length,
                          ),
                        );
                      },
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

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load("fonts/NotoKufiArabic-Regular.ttf");
    final pw.Font font = pw.Font.ttf(fontData);
    List<Studentmodel> pdfStudents = allStudents;

    // Format the time
    final String formattedTime = widget.magmo3aModel.time != null
        ? '${widget.magmo3aModel.time!.hourOfPeriod == 0 ? 12 : widget.magmo3aModel.time!.hourOfPeriod}:${widget.magmo3aModel.time!.minute.toString().padLeft(2, '0')} ${(widget.magmo3aModel.time!.period == DayPeriod.am) ? 'AM' : 'PM'}'
        : 'Unnamed Group';

    // Separate students into boys and girls lists and sort them alphabetically
    List<Studentmodel> boys = pdfStudents.where((s) => s.gender == 'Male').toList();
    List<Studentmodel> girls = pdfStudents.where((s) => s.gender == 'Female').toList();

    // Sort boys and girls lists alphabetically by student name
    boys.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
    girls.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));

    // Set maximum entries per page
    const int maxEntriesPerPage = 40;

    // Helper function to add student pages
    void addStudentPages(String title, List<Studentmodel> students, bool showGroupInfo) {
      for (int page = 0; page * maxEntriesPerPage < students.length; page++) {
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(20),
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (page == 0 && showGroupInfo) ...[
                    pw.Text(
                      "Group time: $formattedTime",
                      style: pw.TextStyle(font: font, fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text("Grade: ${widget.magmo3aModel.grade ?? 'N/A'}",
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.Text("Day: ${widget.magmo3aModel.days ?? 'N/A'}",
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.Text("Number of boys: ${boys.length}",
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.Text("Number of girls: ${girls.length}",
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.Text("Total number of students: ${boys.length + girls.length}",
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      title,
                      style: pw.TextStyle(font: font, fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 5),
                  ],

                  // List of student names for the current page
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: students
                        .skip(page * maxEntriesPerPage)
                        .take(maxEntriesPerPage)
                        .map((student) => pw.Text(
                      student.name ?? 'Unnamed',
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(font: font, fontSize: 8),
                    ))
                        .toList(),
                  ),
                ],
              );
            },
          ),
        );
      }
    }

    // Add pages for boys and girls, splitting as needed
    addStudentPages("Boys:", boys, true);
    addStudentPages("Girls:", girls, true);

    // Print the document
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

}
