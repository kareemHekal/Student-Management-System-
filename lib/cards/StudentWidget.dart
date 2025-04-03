import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../Alert dialogs/Notify Absence.dart';
import '../bloc/Edit Student/edit_student_cubit.dart';
import '../colors_app.dart';
import '../firebase/firebase_functions.dart';
import '../models/Studentmodel.dart';
import '../pages/EditStudent.dart';

class StudentWidget extends StatelessWidget {
  bool IsComingFromGroup;
  final Studentmodel studentModel;
  final String? grade;

  StudentWidget({required this.studentModel, required this.IsComingFromGroup,required this.grade, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onLongPress: () {
          IsComingFromGroup==true?null: showDialog(
            context: context,
            builder: (BuildContext context) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                    primary: Colors.red, // Primary color for the dialog
                  ),
                ),
                child: AlertDialog(
                  backgroundColor: Colors.red[100], // Light red background
                  title: Text(
                    "Delete Student",
                    style: TextStyle(
                      color: Colors.red[900], // Darker red for title
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    "Are you sure you want to delete this student?",
                    style: TextStyle(
                        color:
                            Colors.red[800]), // Slightly darker red for content
                  ),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red[900], // Dark red for text
                      ),
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red[
                            700], // Darker red background for delete button
                      ),
                      child: Text("Delete"),
                      onPressed: () {
                        FirebaseFunctions.deleteStudentFromHisCollection(
                            studentModel.grade??"", studentModel.id);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => StudentEditCubit(studentModel),
                child: EditStudentScreen(grade: grade,student:studentModel,),
              ),
            ),
          );

        },
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: app_colors.ligthGreen,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(

                  children: [
                    Text("${studentModel.dateofadd}"),
                    Spacer(),
                    _buildIconButton(
                      imagePath: "assets/images/whatsapp.png",
                      // Path to WhatsApp icon
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: app_colors.ligthGreen,
                            title: const Text(
                              'Who would you like to send the message to?',style: TextStyle(color: app_colors.green),),
                            content: SelectRecipientDialogContent(
                              sendMessageToFather: () => _sendMessageToParent('father'),
                              sendMessageToMother: () => _sendMessageToParent('mother'),
                              sendMessageToStudent: () => _sendMessageToParent('student'),
                            ),
                            actions: [
                              Material(
                                color: Colors.transparent, // Make the material background transparent
                                elevation: 10, // Set elevation for the shadow effect
                                shadowColor: Colors.black.withOpacity(0.5), // Set shadow color
                                borderRadius: BorderRadius.circular(10), // Optional: Add rounded corners
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: app_colors.orange, // Set background color
                                    foregroundColor: Colors.white, // Set text color for contrast
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Optional: Adjust padding
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElTooltip(
                      position: ElTooltipPosition.leftCenter,
                      content:
                          Text("${studentModel.note ?? "there is no note"}"),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          "assets/images/comment.gif",
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 10),

                _buildInfoRow(context, false,"Name:", studentModel.name ?? 'N/A'),
                _buildInfoRow(context, true,"Phone Number:",
                    studentModel.phoneNumber ?? 'N/A'),
                _buildInfoRow(context,true, "Mother Number:",
                    studentModel.motherPhone ?? 'N/A'),
                _buildInfoRow(context, true,"Father Number:",
                    studentModel.fatherPhone ?? 'N/A'),

                _buildInfoRow(context,false, "Grade:", studentModel.grade ?? 'N/A'),
                const SizedBox(height: 10),

                // Display days from Magmo3amodel

                _buildStudentDaysList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, bool isnumber, String label, String value) {
    void _launchPhoneNumber(String phoneNumber) async {
      final String phoneUrl = 'tel:$phoneNumber';
      if (await canLaunchUrlString(phoneUrl)) {
        await launchUrlString(phoneUrl);
      } else {
        print('Could not launch $phoneNumber');
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: app_colors.green,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 20),
          Flexible(
            child: Theme(
              data: Theme.of(context).copyWith(
                textSelectionTheme: TextSelectionThemeData(
                  selectionColor: app_colors.green.withOpacity(0.5),
                  cursorColor: app_colors.green,
                ),
              ),
              child: GestureDetector(
                onLongPress: isnumber ? () => _launchPhoneNumber(value) : null, // Check isnumber
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: app_colors.orange,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessageToParent(String parentRole) {
    String genderSpecificMessage;

    // Determine the parent's role and customize the message
    if (parentRole == 'father') {
      genderSpecificMessage = """
عزيزي والد ${studentModel.name} 



أطيب التحيات،
حنان خالد
      """;
    }
    else if (parentRole == 'mother') {
      genderSpecificMessage = """
عزيزتي والدة ${studentModel.name}  

 

أطيب التحيات،
حنان خالد
      """;
    }
    else {
      genderSpecificMessage = """
عزيزي ${studentModel.name}،

أطيب التحيات،
حنان خالد
      """;
    }

    // Send the message based on the parent's role
    if (parentRole == 'father') {
      _sendWhatsAppMessage(studentModel.fatherPhone!, genderSpecificMessage);
    } else if (parentRole == 'mother') {
      _sendWhatsAppMessage(studentModel.motherPhone!, genderSpecificMessage);
    } else {
      _sendWhatsAppMessage(studentModel.phoneNumber!, genderSpecificMessage);
    }
  }
  Future<void> _sendWhatsAppMessage(String phoneNumber, String message) async {
    // Format the phone number
    final String formattedPhone = phoneNumber.startsWith('0')
        ? '+20${phoneNumber.substring(1)}'
        : phoneNumber;

    // Print the formatted phone number
    print("Formatted Phone Number: $formattedPhone");

    // Encode the message
    final String encodedMessage = Uri.encodeComponent(message);

    // Build the WhatsApp URL
    final Uri url = Uri.parse(
        'whatsapp://send?phone=$formattedPhone&text=$encodedMessage');

    // Print the WhatsApp URL for debugging
    print("WhatsApp URL: $url");

    try {
      // Check if WhatsApp can be launched
      bool canLaunch = await canLaunchUrl(url);
      if (canLaunch) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        print("WhatsApp is not installed or cannot be opened.");
      }
    } catch (e) {
      print("Error launching WhatsApp: $e");
    }
  }
  Widget _buildStudentDaysList() {
    // Assuming `studentModel.hisGroups` is a list of Magmo3amodel
    List<Map<String, dynamic>> daysWithTimes = studentModel.hisGroups?.map((group) {
      return {
        'day': group.days, // Group days as a string (e.g., "Monday, Wednesday")
        'time': group.time != null
            ? {'hour': group.time?.hour, 'minute': group.time?.minute}
            : null,
      };
    }).toList() ?? [];

    // Remove entries where day is null
    daysWithTimes.removeWhere((entry) => entry['day'] == null);

    return Row(
      children: [
        const Text(
          "Student Days:",
          style: TextStyle(
            color: app_colors.green,
            fontSize: 18,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: daysWithTimes.map((entry) {
                String day = entry['day'] ?? '';
                TimeOfDay? time = entry['time'] != null
                    ? TimeOfDay(hour: entry['time']['hour'], minute: entry['time']['minute'])
                    : null;

                // Convert TimeOfDay to 12-hour format with AM/PM
                String timeString = time != null ? _formatTime12Hour(time) : 'No Time';

                return Row(
                  children: [
                    Chip(
                      label: Column(
                        children: [
                          Text(
                            day,
                            style: const TextStyle(
                              color: app_colors.orange,
                            ),
                          ),
                          Text(
                            timeString,
                            style: const TextStyle(
                              color: app_colors.orange,
                              fontSize: 12, // Smaller font for time
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: app_colors.green,
                    ),
                    const SizedBox(width: 8),
                    // Add some space between each day
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required String imagePath,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Image.asset(
            imagePath,
            width: 30,
            height: 30,
          ),
        ), // مسافة بين الصورة والنص
      ],
    );
  }
// Helper function to format TimeOfDay to 12-hour format with AM/PM
  String _formatTime12Hour(TimeOfDay time) {
    final int hour = time.hourOfPeriod == 0
        ? 12
        : time.hourOfPeriod; // Convert 0 to 12 for midnight/noon
    final String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final String minute =
        time.minute.toString().padLeft(2, '0'); // Ensure two digits for minutes
    return '$hour:$minute $period';
  }
}
