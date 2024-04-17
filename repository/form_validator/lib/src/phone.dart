import 'package:form_validation/form_validator.dart';

enum PhoneValidationError { error, invalid, length, prefix }

class Phone extends FormzInput<String, PhoneValidationError> {
  const Phone.pure() : super.pure('');
  const Phone.dirty([String value = '']) : super.dirty(value);

  static final _regex = RegExp(r'^[0-9]{10}$');

  @override
  PhoneValidationError? validator(String value) {
    if (_regex.hasMatch(value)) {
      return null;
    } else if (value.isEmpty) {
      return PhoneValidationError.error;
    } else if (value.length != 10) {
      return PhoneValidationError.length;
    } else if (value.startsWith('+')) {
      return PhoneValidationError.prefix;
    } else {
      return PhoneValidationError.invalid;
    }
  }

  static String? showPhoneErrorMessage(PhoneValidationError? error) {
    switch (error) {
      case PhoneValidationError.error:
        return 'Phone number required';
      case PhoneValidationError.invalid:
        return 'Invalid phone number';
      case PhoneValidationError.length:
        return 'Phone number must have 10 digits';
      case PhoneValidationError.prefix:
        return 'Phone number must not contain the prefix';
      default:
        return null;
    }
  }
}
