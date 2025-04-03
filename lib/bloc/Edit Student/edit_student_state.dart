abstract class StudentEditState {}

class StudentEditInitial extends StudentEditState {}

class StudentEditLoading extends StudentEditState {}

class StudentEditSuccess extends StudentEditState {}

class StudentUpdatedInEditPage extends StudentEditState {}

class StudentEditFailure extends StudentEditState {
  final String errorMessage;

  StudentEditFailure({required this.errorMessage});
}

class StudentValidationError extends StudentEditState {
  final String errorMessage;

  StudentValidationError(this.errorMessage);
}
