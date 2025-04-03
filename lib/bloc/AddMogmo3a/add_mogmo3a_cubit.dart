import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase/firebase_functions.dart';
import '../../models/Magmo3aModel.dart';
import 'add_mogmo3a_state.dart';

class Magmo3aCubit extends Cubit<Magmo3aState> {
  Magmo3aCubit() : super(Magmo3aInitial());

  final List<String> days = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  late List<String> secondaries = [];

  Future<void> fetchGrades() async {
    List<String> fetchedGrades = await FirebaseFunctions.getGradesList();
    secondaries = fetchedGrades;
    if (secondaries.isEmpty){
      emit(Magmo3aError("there is noe grades so you cant put groups"));
    }
  }

  String? chosenDay;
  String? selectedSecondary;
  TimeOfDay timeOfDay = TimeOfDay.now();

  void selectDay(String day) {
    chosenDay = day;
    emit(Magmo3aDaySelected(day));
  }

  void selectSecondary(String secondary) {
    selectedSecondary = secondary;
    emit(Magmo3aSecondarySelected(secondary));
  }

  void pickTime(TimeOfDay time) {
    timeOfDay = time;
    emit(Magmo3aTimeSelected(time));
  }

  Future<void> addMagmo3a() async {
    if (chosenDay == null || selectedSecondary == null) {
      emit(Magmo3aError("Please fill all fields"));
      return;
    }

    emit(Magmo3aLoading());

    Magmo3amodel magmo3amodel = Magmo3amodel(
      userid: FirebaseAuth.instance.currentUser!.uid,
      days: chosenDay!,
      time: timeOfDay,
      grade: selectedSecondary!,
    );

    try {
      await FirebaseFunctions.addMagmo3aToDay(chosenDay!, magmo3amodel);
      emit(Magmo3aSuccess());
    } catch (e) {
      emit(Magmo3aError("Failed to add group"));
    }
  }
}
