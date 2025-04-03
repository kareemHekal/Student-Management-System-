import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/AddMogmo3a/add_mogmo3a_cubit.dart';
import '../bloc/AddMogmo3a/add_mogmo3a_state.dart';
import '../colors_app.dart';

class AddMagmo3a extends StatelessWidget {
  const AddMagmo3a({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Magmo3aCubit()..fetchGrades(),
      child: BlocConsumer<Magmo3aCubit, Magmo3aState>(
        listener: (context, state) {
          if (state is Magmo3aSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Added successfully'),
                  backgroundColor: Colors.green),
            );
          } else if (state is Magmo3aError) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Error"),
                  content: Text(state.message),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text("OK"),
                    ),
                  ],
                );
              },
            );
          }

        },
        builder: (context, state) {
          final cubit = context.read<Magmo3aCubit>();

          return Container(
            decoration: const BoxDecoration(
              color: app_colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Day Picker
                  _buildDropdown("D A Y S", "Select a day", cubit.days,
                      cubit.chosenDay, (value) => cubit.selectDay(value)),

                  const Divider(color: app_colors.green, thickness: 3),

                  // Time Picker
                  _buildTimePicker(context, cubit),

                  const Divider(color: app_colors.green, thickness: 3),

                  // Grade Picker
                  _buildDropdown(
                      "G R A D E",
                      "Select a secondary",
                      cubit.secondaries,
                      cubit.selectedSecondary,
                      (value) => cubit.selectSecondary(value)),

                  const SizedBox(height: 30),

                  // Add Button
                  state is Magmo3aLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: app_colors.orange,
                            backgroundColor: app_colors.green,
                          ),
                          onPressed: cubit.addMagmo3a,
                          child: const Text("A D D"),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdown(String label, String hint, List<String> items,
      String? selectedValue, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        DropdownButton<String>(
          dropdownColor: app_colors.green,
          value: selectedValue,
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(color: app_colors.green)),
          items: items.map((item) {
            return DropdownMenuItem(
                value: item,
                child: Text(item,
                    style: const TextStyle(color: app_colors.orange)));
          }).toList(),
          onChanged: (value) => onChanged(value!),
          underline: Container(
            height: 2,
            color: app_colors.orange,
          ),
          icon: const Icon(Icons.arrow_forward_ios_outlined,
              color: app_colors.orange),
        ),
      ],
    );
  }

  Widget _buildTimePicker(BuildContext context, Magmo3aCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("T I M E", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: cubit.timeOfDay,
                );
                if (pickedTime != null) cubit.pickTime(pickedTime);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: app_colors.orange,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: app_colors.green, width: 1.5),
                ),
                padding: const EdgeInsets.all(8.0),
                child: const Text("Pick Time"),
              ),
            ),
            Text(
              "${cubit.timeOfDay.hourOfPeriod}:${cubit.timeOfDay.minute.toString().padLeft(2, '0')} ${cubit.timeOfDay.period == DayPeriod.am ? 'AM' : 'PM'}",
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ),
      ],
    );
  }
}
