import 'package:form_validation/form_validator.dart';

enum InteressiCulinariValidatorError {  invalid, format }

const String kInteressiPattern = r'^[a-zA-Z]+$';


class InteressiCulinari extends FormzInput<String, InteressiCulinariValidatorError> {
  const InteressiCulinari.pure() : super.pure('');
  const InteressiCulinari.dirty(String value) : super.dirty(value);

  static final _regex = RegExp(kInteressiPattern);

  @override
  InteressiCulinariValidatorError? validator(String value) {
    if (!_regex.hasMatch(value)) {
      return InteressiCulinariValidatorError.invalid;
    } else if (value
        .contains(RegExp(r'[0-9] | [!@#<>?":_`~;[\]\\|=+)(*&^%$£]'))) {
      return InteressiCulinariValidatorError.format;
    } else {
      return null;
    }
  }

  static String? showInteressiCulinariErrorMessage(InteressiCulinariValidatorError? error) {
    switch (error) {
      case InteressiCulinariValidatorError.format:
        return 'Gli interessi culinari possono contenere solo lettere';
      case InteressiCulinariValidatorError.invalid:
        return 'Gli interessi culinari possono contenere solo lettere';
      default:
        return null;
    }
  }
}
