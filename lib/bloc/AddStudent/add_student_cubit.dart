import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../firebase/firebase_functions.dart';
import '../../home.dart';
import '../../models/Big invoice.dart';
import '../../models/Invoice.dart';
import '../../models/Magmo3aModel.dart';
import '../../models/Studentmodel.dart';
import 'add_student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  StudentCubit() : super(StudentInitial());

  ///============================================================================================================================\\\
  ///=============================================================Variables===========================================================\\\
  ///============================================================================================================================\\\
  late double totalAmount; // The total amount for the payment
  late String description; // The description of the payment
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late String? date;
  late String? Day;
  String? dateOfFirstMonthPaid;
  String? dateOfSecondMonthPaid;
  String? dateOfThirdMonthPaid;
  String? dateOfFourthMonthPaid;
  String? dateOfFifthMonthPaid;
  String? dateOfExplainingNotePaid;
  String? dateOfReviewingNotePaid;
  String? selectedGender;
  bool? secondMonth;
  bool? firstMonth;
  bool? thirdMonth;
  bool? fourthMonth;
  bool? fifthMonth;
  bool? explainingNote;
  bool? reviewNote;
  TextEditingController name_controller = TextEditingController();
  TextEditingController studentNumberController = TextEditingController();
  TextEditingController fatherNumberController = TextEditingController();
  TextEditingController motherNumberController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  List<Magmo3amodel> hisGroups = [];
  List<String> hisGroupsId = []; // List of group IDs (Strings)
  ///============================================================================================================================\\\
  ///=============================================================Functions===========================================================\\\
  ///============================================================================================================================\\\
  static StudentCubit get(context) => BlocProvider.of(context);

  initTheState() {
    hisGroups = [];
    getCurrentDate();
  }

  Future<void> addStudent(BuildContext context, level) async {
    if (hisGroups == []) {
      emit(StudentValidationError("Please pick at least one group"));
      return; // Early return to prevent further actions
    }

    if (name_controller.text.isEmpty) {
      emit(StudentValidationError("Please enter the student\'s name"));
      return;
    }
    if (studentNumberController.text.isEmpty) {
      emit(StudentValidationError("Please enter the student number"));
      return;
    }

    // Validate that student number is exactly 11 digits
    if (!RegExp(r'^\d{11}$').hasMatch(studentNumberController.text)) {
      emit(StudentValidationError("Student number must be exactly 11 digits"));
      return;
    }

    if (fatherNumberController.text.isEmpty) {
      emit(StudentValidationError("Please enter the father\'s number"));

      return;
    }

    // Validate that father's number is exactly 11 digits
    if (!RegExp(r'^\d{11}$').hasMatch(fatherNumberController.text)) {
      emit(
          StudentValidationError("Father\'s number must be exactly 11 digits"));
      return;
    }

    if (motherNumberController.text.isEmpty) {
      emit(StudentValidationError("Please enter the mother\'s number"));
      return;
    }

    // Validate that mother's number is exactly 11 digits
    if (!RegExp(r'^\d{11}$').hasMatch(motherNumberController.text)) {
      emit(
          StudentValidationError("Mother\'s number must be exactly 11 digits"));
      return;
    }

    if (selectedGender == null) {
      emit(StudentValidationError("Please select a gender"));
      return;
    }
    if (firstMonth == null ||
        secondMonth == null ||
        thirdMonth == null ||
        fifthMonth == null ||
        fourthMonth == null) {
      emit(StudentValidationError(
          "Please select payment status for all months"));
      return;
    }
    if (explainingNote == null || reviewNote == null) {
      emit(StudentValidationError(
          "Please select notes for explaining and reviewing"));
      return;
    }
    updatePaymentDates();

    Studentmodel submodel = Studentmodel(
      hisGroupsId: hisGroupsId,
      hisGroups: hisGroups,
      note: noteController.text.isEmpty ? "No note" : noteController.text,
      dateofadd: date!,
      name: name_controller.text,
      gender: selectedGender,
      grade: level,
      firstMonth: firstMonth,
      secondMonth: secondMonth,
      thirdMonth: thirdMonth,
      fourthMonth: fourthMonth,
      fifthMonth: fifthMonth,
      explainingNote: explainingNote,
      reviewNote: reviewNote,
      phoneNumber: studentNumberController.text,
      motherPhone: motherNumberController.text,
      fatherPhone: fatherNumberController.text,
      dateOfFirstMonthPaid: dateOfFirstMonthPaid,
      dateOfSecondMonthPaid: dateOfSecondMonthPaid,
      dateOfThirdMonthPaid: dateOfThirdMonthPaid,
      dateOfFourthMonthPaid: dateOfFourthMonthPaid,
      dateOfFifthMonthPaid: dateOfFifthMonthPaid,
      dateOfExplainingNotePaid: dateOfExplainingNotePaid,
      dateOfReviewingNotePaid: dateOfReviewingNotePaid,
    );
    try {
      emit(StudentLoading());
      FirebaseFunctions.addStudentToCollection(level ?? "", submodel);
      emit(StudentAddedSuccess());
      reviewNote == true ||
          explainingNote == true ||
          firstMonth == true ||
          secondMonth == true ||
          thirdMonth == true ||
          fourthMonth == true ||
          fifthMonth == true
          ? await showPaymentChangeDialog(context, level)
          : Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Homescreen(),
          ),
              (route) => false);
    } catch (e) {
      emit(StudentAddedFailure(e as String));
    }


  }

  void updatePaymentDates() {
    // Check if the payment statuses are true, and update the date accordingly.
    dateOfFirstMonthPaid = firstMonth == true ? date : null;
    dateOfSecondMonthPaid = secondMonth == true ? date : null;
    dateOfThirdMonthPaid = thirdMonth == true ? date : null;
    dateOfFourthMonthPaid = fourthMonth == true ? date : null;
    dateOfFifthMonthPaid = fifthMonth == true ? date : null;
    dateOfExplainingNotePaid = explainingNote == true ? date : null;
    dateOfReviewingNotePaid = reviewNote == true ? date : null;
  }

  void updateGroup(BuildContext context, Magmo3amodel? result) {
    if (result != null) {
      bool groupExists =
          hisGroups.any((group) => group.id == result.id) ?? false;

      if (!groupExists) {
        hisGroups.add(result);
        hisGroupsId.add(result.id); // Add the group ID to hisGroupsId list
        print('Added Group ID: ${result.id}');
        emit(StudentUpdated());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'This Group already exists in the list.',
              style: TextStyle(fontSize: 18),
            ),
            backgroundColor: Colors.red, // Red background color
          ),
        );
      }

      print('His Groups: ${hisGroups?.length}');
    }
  }

  Future<void> showPaymentChangeDialog(BuildContext context, level) async {
    showDialog(
      barrierDismissible: false, // Prevent dismissal by tapping outside
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
                  keyboardType: TextInputType.number, // Ensure numeric input
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
              onPressed: () async {
                FirebaseFirestore firestore = FirebaseFirestore.instance;
                DocumentSnapshot docSnapshot =
                    await firestore.collection('big_invoices').doc(date).get();

                if (_formKey.currentState?.validate() ?? false) {
                  // If the form is valid, save the data
                  totalAmount =
                      double.tryParse(totalAmountController.text) ?? 0.0;
                  description = descriptionController.text;

                  // Create a new invoice object
                  Invoice newInvoice = Invoice(
                    studentName: name_controller.text,
                    studentPhoneNumber: studentNumberController.text,
                    momPhoneNumber: motherNumberController.text,
                    dadPhoneNumber: fatherNumberController.text,
                    grade: level ?? "",
                    amount: totalAmount,
                    description: description,
                    dateTime: DateTime.now(),
                  );

                  if (docSnapshot.exists) {
                    Map<String, dynamic> data =
                        docSnapshot.data() as Map<String, dynamic>;
                    BigInvoice bigInvoice = BigInvoice.fromJson(data);
                    bigInvoice.invoices.add(newInvoice);
                    await firestore
                        .collection('big_invoices')
                        .doc(date)
                        .update(bigInvoice.toJson());
                  } else {
                    BigInvoice bigInvoice = BigInvoice(
                      date: date ?? "",
                      day: Day ?? "",
                      invoices: [newInvoice],
                      payments: [],
                    );
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
  }

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
void setTheSelectedGenderByNull(){
  selectedGender = null;
  emit(StudentUpdated());
}
  void changeValueOfGenderDropDown(value) {
    selectedGender = value as String;
    emit(StudentUpdated());
    print(selectedGender);
  }
  void changeFirstMonthValue(value) {
    firstMonth = value;
    emit(StudentUpdated());
    print(firstMonth);
  }

  void changeSecondMonthValue(value) {
    secondMonth = value;
    emit(StudentUpdated());
    print(secondMonth);
  }

  void changeThirdMonthValue(value) {
    thirdMonth = value;
    emit(StudentUpdated());
    print(thirdMonth);
  }

  void changeFourthMonthValue(value) {
    fourthMonth = value;
    emit(StudentUpdated());
    print(fourthMonth);
  }

  void changeFifthMonthValue(value) {
    fifthMonth = value;
    emit(StudentUpdated());
    print(fifthMonth);
  }

  void changeExplainingNoteValue(value) {
    explainingNote = value;
    emit(StudentUpdated());
    print(explainingNote);
  }

  void changeReviewNoteValue(value) {
    reviewNote = value;
    emit(StudentUpdated());
    print(reviewNote);
  }

}
