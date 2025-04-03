import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../colors_app.dart';
import '../firebase/firebase_functions.dart';
import '../models/Magmo3aModel.dart';
import '../models/Studentmodel.dart';
import '../pages/all students in one group.dart';

class Magmo3aWidget extends StatelessWidget {
  final Magmo3amodel magmo3aModel;

  const Magmo3aWidget({required this.magmo3aModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Slidable(
        startActionPane: ActionPane(
          motion: DrawerMotion(),
          extentRatio: 0.5,
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(30),
              onPressed: (context) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16), // Modern rounded corners
                      ),
                      backgroundColor: Colors.red[50],
                      // Light red background for contrast
                      title: Text(
                        'Start a New Month',
                        style: TextStyle(
                          color: Colors.red[900],
                          // Darker red for the title for better readability
                          fontSize: 20,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to reset the attendance for all students?',
                        style: TextStyle(
                          color: Colors.red[700],
                          // Slightly darker red for content
                          fontSize: 16,
                        ),
                      ),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red[900],
                            // Darker red text for cancel
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          child: Text(
                            'Cancel',
                            style:
                                TextStyle(color: Colors.red[900], fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            // White text on the red button
                            backgroundColor: Colors.red[600],
                            // Dark red button color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Rounded corners for the button
                            ),
                            elevation: 5, // Subtle shadow for depth
                          ),
                          child: const Text(
                            'Confirm',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () async {
                            try {
                              // Delete the Magmo3a from the day
                              await FirebaseFunctions.deleteMagmo3aFromDay(
                                  magmo3aModel.days ?? "", magmo3aModel.id);
                              Navigator.pop(context);

                              // Fetch students by group ID
                              Stream<QuerySnapshot<Studentmodel>>
                                  studentsStream =
                                  FirebaseFunctions.getStudentsByGroupId(
                                      magmo3aModel.grade ?? "",
                                      magmo3aModel.id ?? "");
                              print(studentsStream);
                              studentsStream.listen((snapshot) async {
                                for (var doc in snapshot.docs) {
                                  var student = doc.data();
                                  if (student != null) {
                                    // Remove the group from the student's `hisGroups` list and the group ID from `hisGroupsId` list
                                    student.hisGroups?.removeWhere(
                                        (group) => group.id == magmo3aModel.id);
                                    student.hisGroupsId
                                        ?.remove(magmo3aModel.id);

                                    // Update the student in the collection
                                    await FirebaseFunctions
                                        .updateStudentInCollection(
                                      student.grade ?? "",
                                      student.id,
                                      student,
                                    );
                                  }
                                }
                              });

                              print('Delete button pressed');
                            } catch (e) {
                              print("Error deleting group: $e");
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: app_colors.ligthGreen,
            child: Container(
              height: 150,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  _buildVerticalLine(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        _buildDaysList(),
                        const SizedBox(height: 10),
                        _buildGradeAndTimeAndType(),
                      ],
                    ),
                  ),
                  _buildDetailsButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        decoration: BoxDecoration(
          color: app_colors.orange,
          borderRadius: BorderRadius.circular(25),
        ),
        width: 5,
        height: 200,
      ),
    );
  }

  Widget _buildDaysList() {
    return SizedBox(
      height: 70, // increased height
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0), // increased padding
            child: Container(
              decoration: BoxDecoration(
                color: app_colors.green,
                border: Border.all(
                  color: app_colors.orange,
                  width: 2, // increased border width
                ),
                borderRadius: BorderRadius.circular(15), // increased radius
              ),
              padding: const EdgeInsets.all(8.0), // added padding
              child: Text(
                magmo3aModel.days ?? "", // Display the full day name
                style: TextStyle(
                  fontSize: 30, // increased font size
                  color: app_colors.orange,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGradeAndTimeAndType() {
    return Container(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Grade: ",
                      style: TextStyle(
                        fontSize: 17,
                        color: app_colors.green,
                      ),
                    ),
                    TextSpan(
                      text: "${magmo3aModel.grade ?? ''}",
                      style: TextStyle(
                        fontSize: 20,
                        color: app_colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: " Time : ",
                      style: TextStyle(
                        fontSize: 17,
                        color: app_colors.green,
                      ),
                    ),
                    TextSpan(
                      text: magmo3aModel.time != null
                          ? "${_formatTime(magmo3aModel.time!)}"
                          : '',
                      style: TextStyle(
                        fontSize: 20,
                        color: app_colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute;
    final isPm = hour >= 12;

    final formattedHour = hour > 12 ? hour - 12 : hour;
    final formattedMinute = minute.toString().padLeft(2, '0');

    return "$formattedHour:$formattedMinute ${isPm ? 'PM' : 'AM'}";
  }

  Widget _buildDetailsButton(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentInAgroup(
                  magmo3aModel: magmo3aModel,
                ),
              ),
            );
          },
          icon: Container(
            decoration: BoxDecoration(
              color: app_colors.green,
              border: Border.all(
                color: app_colors.orange,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              color: app_colors.orange,
            ),
          ),
        ),
      ],
    );
  }
}
