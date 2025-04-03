import 'Magmo3aModel.dart';

/// A model representing a student and their associated data.
class Studentmodel {
  // Basic student details
  String id; // Unique identifier for the student
  String? name; // Name of the student
  String? grade; // Grade/level of the student
  String? gender; // Gender of the student (e.g., male, female)
  String? phoneNumber; // Student's phone number
  String? motherPhone; // Mother's phone number
  String? fatherPhone; // Father's phone number

  // List of groups the student belongs to
  List<Magmo3amodel>? hisGroups;
  List<String>? hisGroupsId; // List of group IDs (Strings)

  /// Flags for tracking payments for monthly fees and notes
  bool? firstMonth; // Payment status for the first month
  bool? secondMonth; // Payment status for the second month
  bool? thirdMonth; // Payment status for the third month
  bool? fourthMonth; // Payment status for the fourth month
  bool? fifthMonth; // Payment status for the fifth month
  bool? explainingNote; // Payment status for explaining notes
  bool? reviewNote; // Payment status for reviewing notes

  // Additional student information
  String? note; // Notes or remarks about the student
  String? dateofadd; // Date the student was added
  int? numberOfAbsentDays; // Total number of days the student was absent
  int? numberOfAttendantDays; // Total number of days the student was present
  String? lastDayStudentCame; // The last day the student attended class
  String? lastDateStudentCame; // The last date the student attended class

  // Dates for when payments were made
  String? dateOfFirstMonthPaid; // Date when the first month's fee was paid
  String? dateOfSecondMonthPaid; // Date when the second month's fee was paid
  String? dateOfThirdMonthPaid; // Date when the third month's fee was paid
  String? dateOfFourthMonthPaid; // Date when the fourth month's fee was paid
  String? dateOfFifthMonthPaid; // Date when the fifth month's fee was paid
  String? dateOfExplainingNotePaid; // Date when the explaining note fee was paid
  String? dateOfReviewingNotePaid; // Date when the reviewing note fee was paid

  /// Constructor to initialize the student model.
  Studentmodel({
    this.id = "",
    this.hisGroups,
    this.hisGroupsId,
    this.grade,
    this.name,
    this.gender,
    this.explainingNote,
    this.reviewNote,
    this.phoneNumber,
    this.motherPhone,
    this.fatherPhone,
    this.firstMonth,
    this.secondMonth,
    this.thirdMonth,
    this.fourthMonth,
    this.fifthMonth,
    this.note,
    this.dateofadd,
    this.numberOfAbsentDays,
    this.numberOfAttendantDays,
    this.lastDayStudentCame,
    this.lastDateStudentCame,
    this.dateOfFirstMonthPaid,
    this.dateOfSecondMonthPaid,
    this.dateOfThirdMonthPaid,
    this.dateOfFourthMonthPaid,
    this.dateOfFifthMonthPaid,
    this.dateOfExplainingNotePaid,
    this.dateOfReviewingNotePaid,
  });

  /// Factory method to create a `Studentmodel` instance from a JSON object.
  factory Studentmodel.fromJson(Map<String, dynamic> json) {
    return Studentmodel(
      id: json['id'] ?? "",
      name: json['name'],
      motherPhone: json['mothernumber'],
      phoneNumber: json['phonenumber'],
      explainingNote: json['explainingnote'],
      reviewNote: json['reviewnote'],
      note: json['note'],
      dateofadd: json['dateofadd'],
      gender: json['gender'],
      grade: json['grade'],
      fatherPhone: json['fatherphone'],
      firstMonth: json['firstmonth'],
      secondMonth: json['secondmonth'],
      thirdMonth: json['thirdmonth'],
      fourthMonth: json['fourthmonth'],
      fifthMonth: json['fifthMonth'],
      numberOfAbsentDays: json['numberOfAbsentDays'],
      numberOfAttendantDays: json['numberOfAttendantDays'],
      lastDayStudentCame: json['lastDayStudentCame'],
      lastDateStudentCame: json['lastDateStudentCame'],
      dateOfFirstMonthPaid: json['dateOfFirstMonthPaid'],
      dateOfSecondMonthPaid: json['dateOfSecondMonthPaid'],
      dateOfThirdMonthPaid: json['dateOfThirdMonthPaid'],
      dateOfFourthMonthPaid: json['dateOfFourthMonthPaid'],
      dateOfFifthMonthPaid: json['dateOfFifthMonthPaid'],
      dateOfExplainingNotePaid: json['dateOfExplainingNotePaid'],
      dateOfReviewingNotePaid: json['dateOfReviewingNotePaid'],
      // Convert JSON list to `hisGroups`
      hisGroups: (json['hisGroups'] as List<dynamic>?)
          ?.map((group) => Magmo3amodel.fromJson(group))
          .toList(),
      // Convert `hisGroupsId` if available in the JSON
      hisGroupsId: (json['hisGroupsId'] as List<dynamic>?)
          ?.map((id) => id.toString())
          .toList(),
    );
  }

  /// Converts the `Studentmodel` instance to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gender': gender,
      'grade': grade,
      'dateofadd': dateofadd,
      'note': note,
      'name': name,
      'fatherphone': fatherPhone,
      'firstmonth': firstMonth,
      'secondmonth': secondMonth,
      'thirdmonth': thirdMonth,
      'fourthmonth': fourthMonth,
      'fifthMonth': fifthMonth,
      'mothernumber': motherPhone,
      'phonenumber': phoneNumber,
      'explainingnote': explainingNote,
      'reviewnote': reviewNote,
      'numberOfAbsentDays': numberOfAbsentDays,
      'numberOfAttendantDays': numberOfAttendantDays,
      'lastDayStudentCame': lastDayStudentCame,
      'lastDateStudentCame': lastDateStudentCame,
      'dateOfFirstMonthPaid': dateOfFirstMonthPaid,
      'dateOfSecondMonthPaid': dateOfSecondMonthPaid,
      'dateOfThirdMonthPaid': dateOfThirdMonthPaid,
      'dateOfFourthMonthPaid': dateOfFourthMonthPaid,
      'dateOfFifthMonthPaid': dateOfFifthMonthPaid,
      'dateOfExplainingNotePaid': dateOfExplainingNotePaid,
      'dateOfReviewingNotePaid': dateOfReviewingNotePaid,
      // Convert `hisGroups` to JSON
      'hisGroups': hisGroups?.map((group) => group.toJson()).toList(),
      // Convert `hisGroupsId` to JSON
      'hisGroupsId': hisGroupsId,
    };
  }
}
