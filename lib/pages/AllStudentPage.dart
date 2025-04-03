import 'package:flutter/material.dart';

import '../Appbar_TAbs/All 1 S.dart';
import '../Appbar_TAbs/All 2 S.dart';
import '../Appbar_TAbs/All 3 S.dart';
import '../colors_app.dart';
import '../firebase/firebase_functions.dart';
import '../studetnstreambuilder.dart';

class AllStudentsTab extends StatefulWidget {
  const AllStudentsTab({super.key});

  @override
  State<AllStudentsTab> createState() => _AllStudentsTabState();
}

String? grade;
bool isLoading = true;
List<String>? grades;
late bool thereIsGrades;

class _AllStudentsTabState extends State<AllStudentsTab> {
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      await fetchGrades();
      setState(() {
        isLoading = false; // Stop loading after fetching
      });
    });
  }

  Future<void> fetchGrades() async {
    List<String> fetchedGrades = await FirebaseFunctions.getGradesList();
    setState(() {
      grades = fetchedGrades;
      if (fetchedGrades.isEmpty) {
        thereIsGrades = false;
      } else {
        thereIsGrades = true;
        grade = grades![0]; // Default to the first grade
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Center(child: Image.asset("assets/images/1......1.png")),
        ),
        const SizedBox(height: 50),
        DefaultTabController(
          length: grades?.length ?? 0,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/HomeScreen', (route) => false);
                },
                icon: const Icon(Icons.arrow_back_ios, color: app_colors.orange),
              ),
              backgroundColor: app_colors.green,
              title: Image.asset(
                "assets/images/2....2.png",
                height: 100,
                width: 90,
              ),
              toolbarHeight: 120,
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(
              child: thereIsGrades
                  ? Column(
                children: [
                  Container(
                    color: app_colors.green,
                    child: TabBar(
                      labelPadding:
                      const EdgeInsets.symmetric(horizontal: 10),
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
                  Expanded(
                    child: StudentStreamBuilder(grade: grade ?? ""),
                  ),
                ],
              )
                  : const Text(
                "There are no grades, you must add one first.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
