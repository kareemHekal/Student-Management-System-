
abstract class StudentState {}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentAddedSuccess extends StudentState {}

class StudentAddedFailure extends StudentState {
  final String errorMessage;
  StudentAddedFailure(this.errorMessage);
}
class StudentUpdated extends StudentState {}
class StudentValidationError extends StudentState {
  final String errorMessage;
  StudentValidationError(this.errorMessage);
}
