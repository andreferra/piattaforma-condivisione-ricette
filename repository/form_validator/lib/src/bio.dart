import 'package:form_validation/form_validator.dart';

enum BioValidatorError { empty, invalid, tooLong }

class Bio extends FormzInput<String, BioValidatorError> {
  const Bio.pure() : super.pure('');
  const Bio.dirty([String value = '']) : super.dirty(value);

  @override
  BioValidatorError? validator(String value) {
    if (value.isEmpty) {
      return BioValidatorError.empty;
    } else if (value.length > 100) {
      return BioValidatorError.tooLong;
    } else {
      return null;
    }
  }

  static String? showBioErrorMessage(BioValidatorError? error) {
    switch (error) {
      case BioValidatorError.empty:
        return 'Bio richiesta';
      case BioValidatorError.tooLong:
        return 'Il Bio deve avere al massimo 100 caratteri';
      default:
        return null;
    }
  }
}
