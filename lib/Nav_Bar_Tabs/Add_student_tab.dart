import 'package:flutter/material.dart';
import 'package:hanan_khaled_main/firebase/firebase_functions.dart';
import '../add_student_widget.dart';
import '../colors_app.dart';

class AddStudentTab extends StatefulWidget {
  const AddStudentTab({super.key});

  @override
  State<AddStudentTab> createState() => _AddStudentTabState();
}

class _AddStudentTabState extends State<AddStudentTab> {
  String? grade;
  List<String>? grades;

  @override
  void initState() {
    super.initState();
    fetchGrades();
  }

  Future<void> fetchGrades() async {
    List<String> fetchedGrades = await FirebaseFunctions.getGradesList();
    setState(() {
      grades = fetchedGrades;
      if (grades!.isNotEmpty) {
        grade = grades![0]; // Default to the first grade
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (grades == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (grades!.isEmpty) {
      return const Center(
        child: Text(
          "There are no grades, you must add one first.",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }

    return DefaultTabController(
      length: grades!.length,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: app_colors.green,
              child: TabBar(
                labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                dividerColor: Colors.transparent,
                onTap: (index) {
                  setState(() {
                    grade = grades![index];
                  });
                },
                isScrollable: false,
                indicatorColor: app_colors.orange,
                labelColor: app_colors.orange,
                unselectedLabelColor: Colors.white,
                tabs: grades!.map((g) => Tab(text: g)).toList(),
              ),
            ),
            Expanded(child: AddStudentScreen(level: grade)),
          ],
        ),
      ),
    );
  }
}
