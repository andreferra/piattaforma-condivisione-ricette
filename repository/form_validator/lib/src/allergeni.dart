import 'package:form_validation/form_validator.dart';

enum AllergeniValidatorError { empty, invalid, format }

const String kAllergeniPattern = r'^[a-zA-Z]+$';

class Allergeni extends FormzInput<String, AllergeniValidatorError> {
  const Allergeni.pure() : super.pure('');
  const Allergeni.dirty(String value) : super.dirty(value);

  static final _regex = RegExp(kAllergeniPattern);

  @override
  AllergeniValidatorError? validator(String value) {
    if (value.isEmpty) {
      return AllergeniValidatorError.empty;
    } else if (!_regex.hasMatch(value)) {
      return AllergeniValidatorError.invalid;
    } else if (value
        .contains(RegExp(r'[0-9] | [!@#<>?":_`~;[\]\\|=+)(*&^%$£]'))) {
      return AllergeniValidatorError.format;
    } else {
      return null;
    }
  }

  static String? showAllergeniErrorMessage(AllergeniValidatorError? error) {
    switch (error) {
      case AllergeniValidatorError.empty:
        return 'Allergeni richiesti';
      case AllergeniValidatorError.format:
        return 'Gli allergeni possono contenere solo lettere';
      case AllergeniValidatorError.invalid:
        return 'Gli allergeni possono contenere solo lettere';
      default:
        return null;
    }
  }
}
