import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty,
  invalid,
  maiusciola,
  minuscola,
  numero,
  simbolo
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');

  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (value.length < 6) {
      return PasswordValidationError.invalid;
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      return PasswordValidationError.maiusciola;
    } else if (!value.contains(RegExp(r'[a-z]'))) {
      return PasswordValidationError.minuscola;
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      return PasswordValidationError.numero;
    } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return PasswordValidationError.simbolo;
    } else {
      return null;
    }
  }

  static String? showPasswordErrorMessage(PasswordValidationError? error) {
    switch (error) {
      case PasswordValidationError.empty:
        return 'Password richiesta';
      case PasswordValidationError.invalid:
        return 'La password deve avere almeno 6 caratteri';
      case PasswordValidationError.maiusciola:
        return 'La password deve contenere almeno una lettera maiuscola';
      case PasswordValidationError.minuscola:
        return 'La password deve contenere almeno una lettera minuscola';
      case PasswordValidationError.numero:
        return 'La password deve contenere almeno un numero';
      case PasswordValidationError.simbolo:
        return 'La password deve contenere almeno un simbolo';
      default:
        return null;
    }
  }
}
