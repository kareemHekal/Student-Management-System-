import 'package:flutter/material.dart';
import '../colors_app.dart';
import '../firebase/firebase_functions.dart';

class Allgrades extends StatefulWidget {
  const Allgrades({super.key});

  @override
  State<Allgrades> createState() => _AllgradesState();
}

class _AllgradesState extends State<Allgrades> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showAddGradeDialog(context);
            },
            icon: Icon(Icons.add, size: 40, color: app_colors.blue),
          )
        ],
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
      body: StreamBuilder<List<String>>(
        stream: FirebaseFunctions.getGradesStream(), // Stream that fetches grades
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading grades."));
          }

          List<String> secondaries = snapshot.data ?? [];

          return secondaries.isEmpty
              ? const Center(child: Text("No grades available."))
              : ListView.builder(
            itemCount: secondaries.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: GestureDetector(
                  onLongPress: () {
                    onLongPressDelete(context, secondaries[index]);
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const Icon(Icons.school, color: app_colors.orange),
                    title: Text(
                      secondaries[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void onLongPressDelete(BuildContext context, String gradeToDelete) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Grade"),
          content: Text("Are you sure you want to delete the grade: $gradeToDelete?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFunctions.deleteGradeFromList(gradeToDelete);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Grade deleted successfully")),
                );
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void showAddGradeDialog(BuildContext context) {
    TextEditingController gradeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Grade"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Please enter the name of the new grade."),
              TextFormField(
                controller: gradeController,
                decoration: const InputDecoration(
                  labelText: "Grade Name",
                  hintText: "Enter grade name",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String newGrade = gradeController.text.trim();
                if (newGrade.isNotEmpty) {
                  await FirebaseFunctions.addGradeToList(newGrade);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Grade added successfully")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a grade name")),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
