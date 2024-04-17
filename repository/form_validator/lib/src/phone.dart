import 'package:form_validation/form_validator.dart';

enum PhoneValidationError { error, invalid, length, prefix }

class Phone extends FormzInput<String, PhoneValidationError> {
  const Phone.pure() : super.pure('');
  const Phone.dirty([String value = '']) : super.dirty(value);

  static final _regex = RegExp(r'^[0-9]{10}$');

  @override
  PhoneValidationError? validator(String value) {
    if (value.isEmpty) {
      return PhoneValidationError.error;
    } else if (!_regex.hasMatch(value)) {
      return PhoneValidationError.invalid;
    } else if (value.length != 10) {
      return PhoneValidationError.length;
    } else if (value.startsWith('+')) {
      return PhoneValidationError.prefix;
    } else {
      return null;
    }
  }

  static String? showPhoneErrorMessage(PhoneValidationError? error) {
    switch (error) {
      case PhoneValidationError.error:
        return 'Il numero di telefono è richiesto';
      case PhoneValidationError.invalid:
        return 'Il numero di telefono non è valido';
      case PhoneValidationError.length:
        return 'Il numero di telefono deve contenere 10 cifre';
      case PhoneValidationError.prefix:
        return 'Il numero di telefono non deve contenere il prefisso';
      default:
        return null;
    }
  }
}
