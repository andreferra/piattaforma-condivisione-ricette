

import 'package:form_validation/form_validator.dart';

enum PreferenzeValidatorError { invalid, format}

const String kPreferenzePattern = r'^[a-zA-Z]+$';

class PreferenzeAlimentari extends FormzInput<String, PreferenzeValidatorError> {
  const PreferenzeAlimentari.pure() : super.pure('');
  const PreferenzeAlimentari.dirty(String value) : super.dirty(value);

  static final _regex = RegExp(kPreferenzePattern);

  @override
  PreferenzeValidatorError? validator(String value) {
    if (!_regex.hasMatch(value)) {
      return PreferenzeValidatorError.invalid;
    } else if (value
        .contains(RegExp(r'[0-9] | [!@#<>?":_`~;[\]\\|=+)(*&^%$£]'))) {
      return PreferenzeValidatorError.format;
    } else {
      return null;
    }
  }

  static String? showPreferenzeErrorMessage(PreferenzeValidatorError? error) {
    switch (error) {
      case PreferenzeValidatorError.format:
        return 'Le preferenze alimentari possono contenere solo lettere';
      case PreferenzeValidatorError.invalid:
        return 'Le preferenze alimentari possono contenere solo lettere';
      default:
        return null;
    }
  }
}