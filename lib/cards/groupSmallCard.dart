import 'package:flutter/material.dart';

import '../colors_app.dart';
import '../models/Magmo3aModel.dart';

class Groupsmallcard extends StatelessWidget {
  final Magmo3amodel? magmo3aModel;
   Groupsmallcard({super.key,required this.magmo3aModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Card(

        elevation: 10,
        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(30),
        ),
        color: app_colors.ligthGreen,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: 150, // Set a fixed width for the card
                    child: Column(
                      children: [
                        _buildDaysList(),
                        const SizedBox(height: 10),
                        _buildGradeAndTimeAndType(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildDaysList() {
    return SizedBox(
      height: 60, // increased height
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
                magmo3aModel?.days??"", // Display the full day name
                style: const TextStyle(
                  fontSize: 22, // increased font size
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
    return SizedBox(
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
                    const TextSpan(
                      text: "Grade: ",
                      style: TextStyle(
                        fontSize: 17,
                        color: app_colors.green,
                      ),
                    ),
                    TextSpan(
                      text: magmo3aModel?.grade ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        color: app_colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: " Time : ",
                      style: TextStyle(
                        fontSize: 17,
                        color: app_colors.green,
                      ),
                    ),
                    TextSpan(
                      text: magmo3aModel?.time != null
                          ? _formatTime(magmo3aModel!.time!)
                          : '',
                      style: const TextStyle(
                        fontSize: 20,
                        color: app_colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
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
}


