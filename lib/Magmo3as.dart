import 'package:flutter/material.dart';

import 'BottomSheets/add_magmo3a.dart';
import 'models/Magmo3aModel.dart';
import 'cards/Magmo3aWidget.dart';
import 'colors_app.dart';
import 'firebase/firebase_functions.dart';
import 'loadingFile/loadingWidget.dart';

class Magmo3as extends StatelessWidget {
  String day;

  Magmo3as({required this.day, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // the add icon
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                    color: app_colors.green,
                    borderRadius: BorderRadius.circular(30)),
                child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: AddMagmo3a(),
                            ));
                  },
                  icon: Icon(Icons.add),
                  color: app_colors.orange,
                  iconSize: 30,
                ),
              ),
            )
          ],
        ),
        StreamBuilder<List<Magmo3amodel>>(
          stream: FirebaseFunctions.getAllDocsFromDay(day), // Ensure this returns Stream<List<Magmo3amodel>>
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: DiscreteCircle(
                  color: app_colors.green,
                  size: 30,
                  secondCircleColor: app_colors.ligthGreen,
                  thirdCircleColor: app_colors.orange,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    const Text("Something went wrong"),
                    ElevatedButton(
                      onPressed: () {
                        // You can implement retry logic here if needed
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
            }

            // Directly get the list of Magmo3amodel
            var magmo3as = snapshot.data ?? []; // This is already a list of Magmo3amodel


            if (magmo3as.isEmpty) {
              return Center(
                child: Text(
                  "No groups",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 25,
                    color: app_colors.black,
                  ),
                ),
              );
            }

            return Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Magmo3aWidget(
                    magmo3aModel: magmo3as[index], // Use the Magmo3amodel directly
                  );
                },
                itemCount: magmo3as.length,
              ),
            );
          },
        )
      ],
    );
  }
}
