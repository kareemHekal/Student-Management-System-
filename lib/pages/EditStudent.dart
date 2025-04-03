import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../Alert dialogs/RemoveFromGroupsListDialog.dart';
import '../bloc/Edit Student/edit_student_cubit.dart';
import '../bloc/Edit Student/edit_student_state.dart';
import '../cards/groupSmallCard.dart';
import '../colors_app.dart';
import '../firebase/firebase_functions.dart';
import '../models/Studentmodel.dart';
import 'Pick Groups Page.dart';

class EditStudentScreen extends StatefulWidget {
  Studentmodel student;
  String? grade;

  EditStudentScreen({required this.student, required this.grade, super.key});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}


class _EditStudentScreenState extends State<EditStudentScreen> {

  @override
  Widget build(BuildContext context) {
    final cubit = StudentEditCubit.get(context);
    return Material(
      child: Scaffold(
          appBar: AppBar(
            elevation: 10,
            shadowColor: Colors.yellow,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
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
            toolbarHeight: 180,
          ),
          body: LoaderOverlay(
            child: BlocProvider(
              create: (context) => StudentEditCubit(widget.student)..initTheState(),
              child: BlocConsumer<StudentEditCubit, StudentEditState>(
                listener: (context, state) {
                  // Show loader overlay while fetching sources or news
                  if (state is StudentEditLoading) {
                    context.loaderOverlay.show();
                  } else {
                    context.loaderOverlay.hide();
                  }
                  if (state is StudentEditSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Student added successfully!'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                  if (state is StudentUpdatedInEditPage) {
                    setState(() {});
                  }
                  if (state is StudentEditFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                  if (state is StudentValidationError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }

                },
                builder: (context, state) {
                  if (state is StudentEditLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Check if data is available
                  final cubit = StudentEditCubit.get(context);

                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: Center(child: Image.asset("assets/images/1......1.png")),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 17),
                          child: Container(
                            decoration: BoxDecoration(
                              color: app_colors.white.withOpacity(0.3),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                            ),
                            width: double.infinity,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20, left: 0),
                                              child: Text(
                                                textAlign: TextAlign.start,
                                                '''  E D I T
  Y O U R  S T U D E N T S''',
                                                style: GoogleFonts.oswald(
                                                  fontSize: 30,
                                                  color: app_colors.green,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                        const Divider(
                                          color: app_colors.orange,
                                          thickness: 4,
                                        ),
                                        SizedBox(
                                          height: 240, // or any other bounded height
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Center(
                                                  child: Text(" Pick the days ")),
                                              Expanded(
                                                child: PickGroupRow(context),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          color: app_colors.orange,
                                          thickness: 4,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormFields(context),
                                        const Divider(
                                          color: app_colors.orange,
                                          thickness: 4,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        MaleOrFemalePart(context),
                                        const SizedBox(
                                          height: 15,
                                        ),

                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Divider(
                                          color: app_colors.orange,
                                          thickness: 4,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        paymentsPart(context),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Divider(
                                          color: app_colors.orange,
                                          thickness: 4,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),

                                        /// the column of the monthes paid
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                showDateOfPaidMonth(
                                                    "First month",
                                                    widget
                                                        .student.dateOfFirstMonthPaid),
                                                showDateOfPaidMonth(
                                                    "Second month",
                                                    widget
                                                        .student.dateOfSecondMonthPaid),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                showDateOfPaidMonth(
                                                    "Third month",
                                                    widget
                                                        .student.dateOfThirdMonthPaid),
                                                showDateOfPaidMonth(
                                                    "Fourth month",
                                                    widget
                                                        .student.dateOfFourthMonthPaid),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                showDateOfPaidMonth(
                                                    "Fifth month",
                                                    widget
                                                        .student.dateOfFifthMonthPaid),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                showDateOfPaidMonth(
                                                    "Explaining Note",
                                                    widget.student
                                                        .dateOfExplainingNotePaid),
                                                showDateOfPaidMonth(
                                                    "Reviewing",
                                                    widget.student
                                                        .dateOfReviewingNotePaid),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Divider(
                                          color: app_colors.orange,
                                          thickness: 4,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            showNumberOfAbsenceAndPresence(
                                                "AttendantDays",
                                                widget.student.numberOfAttendantDays),
                                            showNumberOfAbsenceAndPresence("AbsentDays",
                                                widget.student.numberOfAbsentDays)
                                          ],
                                        ),
                                        const Divider(
                                          color: app_colors.orange,
                                          thickness: 4,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        NotesPart(context),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: app_colors.orange,
                                                  backgroundColor:
                                                  app_colors.green, // text color
                                                ),
                                                onPressed: () async {
                                                  await cubit.EditStudent(context, widget.grade);
                                                },
                                                child: const Text(" Edit "),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 200,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ],
                  );
                },
              ),
            ),
          )),
    );
  }



  Widget showDateOfPaidMonth(
    String label,
    String? date,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date ?? "he didn't pay for this yet",
              style: const TextStyle(fontSize: 10, color: app_colors.orange),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }

  Widget showNumberOfAbsenceAndPresence(
    String label,
    int? number,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              (number ?? 0).toString(),
              style: const TextStyle(fontSize: 16, color: app_colors.orange),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }
  Widget PickGroupRow(BuildContext context) {
    final cubit = StudentEditCubit.get(context);
    return Column(
      children: [
        Expanded(
            child: cubit.hisGroups==[]
                ? Center(
                child: Text(
                  "You did not choose any group yet",
                  style: TextStyle(color: app_colors.orange),
                ))
                : ListView.builder(
              itemCount: cubit.hisGroups?.length,
              itemBuilder: (context, index) {
                // Get the current Magmo3amodel
                final magmo3aModel = cubit.hisGroups?[index];
                // Return the Groupsmallcard widget for each Magmo3aModel
                return GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RemoveFromGroupsListDialog(
                            title: "Remove Group",
                            content:
                            "Are you sure you want to remove this group ?",
                            onConfirm: () async {
                              await Future.delayed(
                                  Duration(milliseconds: 1));
                              cubit.hisGroups?.removeAt(index);
                              cubit.hisGroupsId?.removeAt(index);
                              setState(() {});
                            },
                          );
                        },
                      );
                    },
                    child: Groupsmallcard(magmo3aModel: magmo3aModel));
              },
            )),
        const SizedBox(height: 10), // Space between the list and the button
        // First Day Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: const BorderSide(color: app_colors.orange, width: 1),
            foregroundColor: app_colors.orange,
            backgroundColor: app_colors.green, // text color
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChoosedaysToAttend(level:widget.grade),
              ),
            ).then((result) {
              if (result != null) {
                cubit.updateGroup(context, result);
              }
            });
          },
          child: const Text("Add Group"),
        ),
      ],
    );
  }

  Widget buildDropdown(
    String hint,
    bool? selectedValue,
    ValueChanged<bool?> onChanged,
  ) {
    return SizedBox(
      width: 200, // specify a width
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: app_colors.green, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButton<bool>(
          dropdownColor: app_colors.green,
          value: selectedValue,
          isExpanded: true,
          items: const [
            DropdownMenuItem(
              value: true,
              child: Text("Paid", style: TextStyle(color: Colors.orange)),
            ),
            DropdownMenuItem(
              value: false,
              child: Text("Not Paid", style: TextStyle(color: Colors.orange)),
            ),
          ],
          onChanged: onChanged,
          elevation: 8,
          style: const TextStyle(color: Colors.orange),
          icon: const Icon(Icons.arrow_forward_ios_outlined,
              color: Colors.orange),
          iconSize: 24,
          hint: Text(
            selectedValue == null
                ? hint
                : (selectedValue ? "Paid" : "Not Paid"),
            style: const TextStyle(color: Colors.orange),
          ),
        ),
      ),
    );
  }
  Widget NotesPart(BuildContext context) {
    final cubit = StudentEditCubit.get(context);

    return TextFormField(
      controller: cubit.noteController,
      maxLines: 3, // Allows for multi-line input
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a note';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Add Note",
        labelStyle: const TextStyle(fontSize: 25, color: app_colors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: app_colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: app_colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        hintText: 'Type your note here...',
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
  Widget paymentsPart(BuildContext context) {
    final cubit = StudentEditCubit.get(context);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      const Text("First Month :"),
                      buildDropdown("First Month", cubit.firstMonth, (value) {
                        cubit.changeFirstMonthValue(value);
                      }),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    children: [
                      const Text("Second Month :"),
                      buildDropdown("Second Month", cubit.secondMonth, (value) {
                        cubit.changeSecondMonthValue(value);
                      }),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Column(
                    children: [
                      const Text("Third Month :"),
                      buildDropdown("Third Month", cubit.thirdMonth, (value) {
                        cubit.changeThirdMonthValue(value);
                      }),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    children: [
                      const Text("Fourth Month :"),
                      buildDropdown("Fourth Month", cubit.fourthMonth, (value) {
                        cubit.changeFourthMonthValue(value);
                      }),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      const Text("Fifth Month :"),
                      buildDropdown("Fifth Month", cubit.fifthMonth, (value) {
                        cubit.changeFifthMonthValue(value);
                      }),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Column(
                    children: [
                      const Text("Explaining Note :"),
                      buildDropdown("Explaining Note", cubit.explainingNote,
                              (value) {
                            cubit.changeExplainingNoteValue(value);
                          }),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    children: [
                      const Text("Reviewing Note :"),
                      buildDropdown("Review Note", cubit.reviewNote, (value) {
                        cubit.changeReviewNoteValue(value);
                      }),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget MaleOrFemalePart(BuildContext context) {
    final cubit = StudentEditCubit.get(context);
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              border: Border.all(color: app_colors.green, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<String>(
              dropdownColor: app_colors.green,
              value: cubit.selectedGender ?? "Male",
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: "Male",
                  child:
                      Text("Male", style: TextStyle(color: app_colors.orange)),
                ),
                DropdownMenuItem(
                  value: "Female",
                  child: Text("Female",
                      style: TextStyle(color: app_colors.orange)),
                ),
              ],
              onChanged: (value) {
                cubit.changeValueOfGenderDropDown(value);
              },
              elevation: 8,
              style: const TextStyle(color: app_colors.orange),
              icon: const Icon(Icons.arrow_forward_ios_outlined,
                  color: app_colors.orange),
              iconSize: 24,
              hint: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  cubit.selectedGender ?? "Select a gender",
                  style: const TextStyle(color: app_colors.orange),
                ),
              ),
            )),
        const SizedBox(
          height: 15,
        ),
        cubit.selectedGender != null
            ? Wrap(
                direction: Axis.horizontal,
                spacing: 8,
                children: [
                  Chip(
                    backgroundColor: app_colors.green,
                    label: Text(cubit.selectedGender!,
                        style: const TextStyle(color: app_colors.orange)),
                    deleteIcon: const Icon(Icons.cancel,
                        size: 20, color: app_colors.orange),
                    shape: const StadiumBorder(
                        side: BorderSide(color: app_colors.orange)),
                    onDeleted: () {
                      cubit.setTheSelectedGenderByNull();
                    },
                  ),
                ],
              )
            : const Center(
                child: Text("Select a gender",
                    style: TextStyle(color: app_colors.orange)),
              ),
      ],
    );
  }

  Widget TextFormFields(BuildContext context) {
    final cubit = StudentEditCubit.get(context);

    InputDecoration getInputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 25, color: app_colors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: app_colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: app_colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
      );
    }

    Widget buildTextFormField({
      required TextEditingController controller,
      required String label,
      TextInputType? keyboardType,
    }) {
      return TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
        decoration: getInputDecoration(label),
        keyboardType: keyboardType,
        inputFormatters: keyboardType == TextInputType.number
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
      );
    }

    return Column(
      children: [
        buildTextFormField(
            controller: cubit.name_controller, label: "Student Name"),
        const SizedBox(height: 15),
        buildTextFormField(
          controller: cubit.studentNumberController,
          label: "Student Number",
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 15),
        buildTextFormField(
          controller: cubit.fatherNumberController,
          label: "Father's Number",
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 15),
        buildTextFormField(
          controller: cubit.motherNumberController,
          label: "Mother's Number",
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
