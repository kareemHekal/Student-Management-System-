

import 'package:flutter/material.dart';

abstract class Magmo3aState {}

class Magmo3aInitial extends Magmo3aState {}

class Magmo3aDaySelected extends Magmo3aState {
  final String day;
  Magmo3aDaySelected(this.day);
}

class Magmo3aSecondarySelected extends Magmo3aState {
  final String secondary;
  Magmo3aSecondarySelected(this.secondary);
}

class Magmo3aTimeSelected extends Magmo3aState {
  final TimeOfDay time;
  Magmo3aTimeSelected(this.time);
}

class Magmo3aLoading extends Magmo3aState {}

class Magmo3aSuccess extends Magmo3aState {}

class Magmo3aError extends Magmo3aState {
  final String message;
  Magmo3aError(this.message);
}
