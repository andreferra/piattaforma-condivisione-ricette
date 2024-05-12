import 'package:form_validation/form_validator.dart';
import 'package:formz/formz.dart';

enum NicknameValidationError { empty, invalid, yetUsed, alreadyExist}

class Nickname extends FormzInput<String, NicknameValidationError> {
  const Nickname.pure() : super.pure('');
  const Nickname.dirty([String value = '']) : super.dirty(value);

  @override
  NicknameValidationError? validator(String value) {
    if (value.isEmpty) {
      return NicknameValidationError.empty;
    } else if (value.length < 3) {
      return NicknameValidationError.invalid;
    }else {
      return null;
    }
  }

  static String? showNicknameErrorMessage(NicknameValidationError? error) {
    switch (error) {
      case NicknameValidationError.empty:
        return 'Nickname richiesto';
      case NicknameValidationError.invalid:
        return 'Il Nickname deve avere almeno 3 caratteri';
      case NicknameValidationError.alreadyExist:
        return 'Nickname già in uso';
      default:
        return null;
    }
  }
}
