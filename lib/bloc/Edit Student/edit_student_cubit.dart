import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../firebase/firebase_functions.dart';
import '../../models/Big invoice.dart';
import '../../models/Invoice.dart';
import '../../models/Magmo3aModel.dart';
import '../../models/Studentmodel.dart';
import '../../pages/AllStudentPage.dart';
import 'edit_student_state.dart';

class StudentEditCubit extends Cubit<StudentEditState> {
  Studentmodel student;

  StudentEditCubit(this.student) : super(StudentEditInitial());

  ///============================================================================================================================\\\
  ///=============================================================Variables===========================================================\\\
  ///============================================================================================================================\\\

  String? dateOfFirstMonthPaid; // Date when the first month was paid
  String? dateOfSecondMonthPaid; // Date when the second month was paid
  String? dateOfThirdMonthPaid; // Date when the third month was paid
  String? dateOfFourthMonthPaid; // Date when the fourth month was paid
  String? dateOfFifthMonthPaid; // Date when the fifth month was paid
  String? dateOfExplainingNotePaid; // Date when the explaining note was paid
  String? dateOfReviewingNotePaid;
  late double totalAmount; // The total amount for the payment
  late String description; // The description of the payment
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late String? date;
  late String? Day;
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
  List<Magmo3amodel>? hisGroups = [];
  List<String>? hisGroupsId = [];

  ///============================================================================================================================\\\
  ///=============================================================Functions===========================================================\\\
  ///============================================================================================================================\\\
  static StudentEditCubit get(context) => BlocProvider.of(context);
  initTheState() {
    getCurrentDate();

    hisGroups = student.hisGroups;
    hisGroupsId = student.hisGroupsId;
    dateOfFirstMonthPaid = student.dateOfFirstMonthPaid;
    dateOfSecondMonthPaid = student.dateOfSecondMonthPaid;
    dateOfThirdMonthPaid = student.dateOfThirdMonthPaid;
    dateOfFourthMonthPaid = student.dateOfFourthMonthPaid;
    dateOfFifthMonthPaid = student.dateOfFifthMonthPaid;
    dateOfExplainingNotePaid = student.dateOfExplainingNotePaid;
    dateOfReviewingNotePaid = student.dateOfReviewingNotePaid;

    noteController.text = student.note ?? "";
    name_controller.text = student.name ?? "";
    studentNumberController.text = student.phoneNumber ?? "";
    fatherNumberController.text = student.fatherPhone ?? "";
    motherNumberController.text = student.motherPhone ?? "";

    // Initialize months and notes
    firstMonth = student.firstMonth;
    secondMonth = student.secondMonth;
    thirdMonth = student.thirdMonth;
    fourthMonth = student.fourthMonth;
    fifthMonth = student.fifthMonth;
    explainingNote = student.explainingNote;
    reviewNote = student.reviewNote;

    // Initialize gender
    selectedGender = student.gender;
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
          hisGroups?.any((group) => group.id == result.id) ?? false;

      if (!groupExists) {
        hisGroups?.add(result);
        hisGroupsId?.add(result.id);
        emit(StudentUpdatedInEditPage());
        print('Added Group ID: ${result.id}');
      } else {
        emit(StudentValidationError("This Group already exists in the list."));
      }
    }
  }

  Future<void> showPaymentChangeDialog(BuildContext context) async {
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
                    grade: student.grade ?? "",
                    amount: totalAmount,
                    description: description,
                    dateTime: DateTime.now(),
                  );

                  if (docSnapshot.exists) {
                    // If the document exists, retrieve the existing data
                    Map<String, dynamic> data =
                        docSnapshot.data() as Map<String, dynamic>;

                    // Parse the existing document into a BigInvoice object
                    BigInvoice bigInvoice = BigInvoice.fromJson(data);

                    // Add the new invoice to the existing list of invoices
                    bigInvoice.invoices.add(newInvoice);

                    // Update the Firestore document
                    await firestore
                        .collection('big_invoices')
                        .doc(date)
                        .update(bigInvoice.toJson());
                  } else {
                    // If the document does not exist, create it with the new invoice in the `invoices` list
                    BigInvoice bigInvoice = BigInvoice(
                      date: date ?? "",
                      day: Day ?? "",
                      invoices: [newInvoice], // Add the new invoice to the list
                      payments: [], // Initialize payments as an empty list
                    );

                    // Save the new document to Firestore
                    await firestore
                        .collection('big_invoices')
                        .doc(date)
                        .set(bigInvoice.toJson());
                  }

                  // Navigate to the Home Screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AllStudentsTab()),
                    (Route<dynamic> route) => false,
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

  Future<void> EditStudent(BuildContext context, level) async {
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

    String? dateOfFirstMonthPaid = firstMonth != student.firstMonth
        ? firstMonth == true
            ? date
            : null
        : student.dateOfFirstMonthPaid;

    String? dateOfSecondMonthPaid = getPaymentDate(
        secondMonth, student.secondMonth, student.dateOfSecondMonthPaid, date);
    String? dateOfThirdMonthPaid = getPaymentDate(
        thirdMonth, student.thirdMonth, student.dateOfThirdMonthPaid, date);
    String? dateOfFourthMonthPaid = getPaymentDate(
        fourthMonth, student.fourthMonth, student.dateOfFourthMonthPaid, date);
    String? dateOfFifthMonthPaid = getPaymentDate(
        fifthMonth, student.fifthMonth, student.dateOfFifthMonthPaid, date);
    String? dateOfExplainingNotePaid = getPaymentDate(explainingNote,
        student.explainingNote, student.dateOfExplainingNotePaid, date);
    String? dateOfReviewingNotePaid = getPaymentDate(
        reviewNote, student.reviewNote, student.dateOfReviewingNotePaid, date);

    updatePaymentDates();

    // Create the updated Studentmodel
    Studentmodel submodel = Studentmodel(
      id: student.id,
      dateofadd: student.dateofadd,
      name: name_controller.text,
      gender: selectedGender,
      hisGroups: hisGroups,
      hisGroupsId: hisGroupsId,
      grade: level,
      firstMonth: firstMonth,
      secondMonth: secondMonth,
      thirdMonth: thirdMonth,
      note: noteController.text,
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

    // Update the student in Firestore
    try {
      emit(StudentEditLoading());
      FirebaseFunctions.updateStudentInCollection(
        student.grade ?? "",
        student.id,
        submodel,
      );
      emit(StudentEditSuccess());
    } catch (e) {
      print("Error: >>>>>>>>>>>  $e" );
      emit(StudentEditFailure(errorMessage: e as String));
    }
// Compare the old values with the new values to detect changes
    bool isMonthOrNoteChanged =
        (student.firstMonth == false && firstMonth == true) ||
            (student.secondMonth == false && secondMonth == true) ||
            (student.thirdMonth == false && thirdMonth == true) ||
            (student.fourthMonth == false && fourthMonth == true) ||
            (student.fifthMonth == false && fifthMonth == true) ||
            (student.explainingNote == false && explainingNote == true) ||
            (student.reviewNote == false && reviewNote == true);

    // If changes detected, show the dialog
    if (isMonthOrNoteChanged) {
      await showPaymentChangeDialog(context);
    } else {
      Navigator.pop(context);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Student Edited successfully!'),
      ),
    );
  }

  String? getPaymentDate(bool? currentValue, bool? previousValue,
      String? previousDate, String? date) {
    return currentValue != previousValue
        ? currentValue == true
            ? date // If changed to true, set to current date
            : null // If changed to false, set to null
        : previousDate;
  }
  void setTheSelectedGenderByNull(){
    selectedGender = null;
    emit(StudentUpdatedInEditPage());
  }
  void changeValueOfGenderDropDown(value) {
    selectedGender = value as String;
    emit(StudentUpdatedInEditPage());
    print(selectedGender);
  }
  void changeFirstMonthValue(value) {
    firstMonth = value;
    emit(StudentUpdatedInEditPage());
    print(firstMonth);
  }

  void changeSecondMonthValue(value) {
    secondMonth = value;
    emit(StudentUpdatedInEditPage());
    print(secondMonth);
  }

  void changeThirdMonthValue(value) {
    thirdMonth = value;
    emit(StudentUpdatedInEditPage());
    print(thirdMonth);
  }

  void changeFourthMonthValue(value) {
    fourthMonth = value;
    emit(StudentUpdatedInEditPage());
    print(fourthMonth);
  }

  void changeFifthMonthValue(value) {
    fifthMonth = value;
    emit(StudentUpdatedInEditPage());
    print(fifthMonth);
  }

  void changeExplainingNoteValue(value) {
    explainingNote = value;
    emit(StudentUpdatedInEditPage());
    print(explainingNote);
  }

  void changeReviewNoteValue(value) {
    reviewNote = value;
    emit(StudentUpdatedInEditPage());
    print(reviewNote);
  }
}
