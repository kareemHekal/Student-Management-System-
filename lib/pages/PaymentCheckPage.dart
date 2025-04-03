import 'package:flutter/material.dart';
import 'package:hanan_khaled_main/models/Studentmodel.dart';
import '../colors_app.dart';
import '../firebase/firebase_functions.dart';
import '../home.dart';

class PaymentCheckPage extends StatefulWidget {
  const PaymentCheckPage({super.key});

  @override
  State<PaymentCheckPage> createState() => _PaymentCheckPageState();
}

class _PaymentCheckPageState extends State<PaymentCheckPage> {
  late List<String> secondaries = [];
  List<String> categories = [
    "First Month",
    "Second Month",
    "Third Month",
    "Fourth Month",
    "Fifth Month",
    "Explaining Note",
    "Review Note"
  ];

  String? selectedSecondary;
  String? selectedCategory;
  List<Studentmodel> paidStudents = [];
  List<Studentmodel> unpaidStudents = [];
  bool startSearch=false;

  Future<void> fetchGrades() async {
    List<String> fetchedGrades = await FirebaseFunctions.getGradesList();
    setState(() {
      secondaries = fetchedGrades;
    });
  }

  Future<void> checkPayments() async {
    if (selectedSecondary == null || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both grade and category.")),
      );
      return;
    }
print(selectedSecondary);
print(selectedCategory);
    List<Studentmodel> students =
    await FirebaseFunctions.getAllStudentsByGrade_future(selectedSecondary!);

    List<Studentmodel> paid = [];
    List<Studentmodel> unpaid = [];
    if (selectedCategory=="First Month"){
      for (var student in students) {
        if (student.firstMonth == true) {
          paid.add(student);
        } else {
          unpaid.add(student);
        }
      }
    }else if (selectedCategory=="Second Month"){
      for (var student in students) {
        if (student.secondMonth == true) {
          paid.add(student);
        } else {
          unpaid.add(student);
        }
      }
    }else if (selectedCategory=="Third Month"){
      for (var student in students) {
        if (student.thirdMonth == true) {
          paid.add(student);
        } else {
          unpaid.add(student);
        }
      }
    } else if (selectedCategory=="Fourth Month"){
      for (var student in students) {
        if (student.fourthMonth == true) {
          paid.add(student);
        } else {
          unpaid.add(student);
        }
      }
    }else if (selectedCategory=="Fifth Month"){
      for (var student in students) {
        if (student.fifthMonth == true) {
          paid.add(student);
        } else {
          unpaid.add(student);
        }
      }
    } else if (selectedCategory=="Explaining Note"){
      for (var student in students) {
        if (student.explainingNote == true) {
          paid.add(student);
        } else {
          unpaid.add(student);
        }
      }
    } else if (selectedCategory=="Review Note"){
      for (var student in students) {
        if (student.reviewNote == true) {
          paid.add(student);
        } else {
          unpaid.add(student);
        }
      }
    }

    setState(() {
      paidStudents = paid;
      unpaidStudents = unpaid;
      startSearch=true;
    });
    print('Paid Students: ${paidStudents.length}');
    print('Unpaid Students: ${unpaidStudents.length}');

  }

  @override
  void initState() {
    super.initState();
    fetchGrades();
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
                  (route) => false,
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
        toolbarHeight: 180,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDropdown("G R A D E", "Select a grade", secondaries,
                selectedSecondary, (value) => selectSecondary(value)),
            const SizedBox(height: 15),
            _buildDropdown("Select Month", "Select the month", categories,
                selectedCategory, (value) => selectCategory(value)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: checkPayments,
              style: ElevatedButton.styleFrom(
                backgroundColor: app_colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              ),
              child: const Text(
                "Search",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            paidStudents.isNotEmpty || unpaidStudents.isNotEmpty?
              Expanded(
                child: ListView(
                  children: [
                    _buildStudentList("Paid Students", paidStudents, Colors.green),
                    const SizedBox(height: 20),
                    _buildStudentList("Unpaid Students", unpaidStudents, Colors.red),
                  ],
                ),
              ):startSearch==true?Text("You dont have students in this grade"):SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _buildStudentList(String title, List<Studentmodel> students, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 10),
        ...students.map((student) => Card(
          child: ListTile(
            title: Text(student.name ?? "Unknown"),
            subtitle: Text(student.phoneNumber ?? "No Phone"),
          ),
        )),
      ],
    );
  }

  void selectSecondary(String secondary) {
    setState(() {
      selectedSecondary = secondary;
    });
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  Widget _buildDropdown(String label, String hint, List<String> items,
      String? selectedValue, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: app_colors.green, width: 2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: Colors.white,
              value: selectedValue,
              isExpanded: true,
              hint: Text(hint, style: TextStyle(color: Colors.grey[700])),
              items: items.map((item) {
                return DropdownMenuItem(
                    value: item,
                    child: Text(item, style: TextStyle(color: app_colors.green)));
              }).toList(),
              onChanged: (value) => onChanged(value!),
              icon: const Icon(Icons.arrow_drop_down, color: app_colors.green),
            ),
          ),
        ),
      ],
    );
  }
}
