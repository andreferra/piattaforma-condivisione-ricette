part of 'setting_controller.dart';

class SettingState extends Equatable {
  final Email? newEmail;
  final Password? newPassword;
  final FormzStatus status;
  final String? errorMessage;
  final bool? notification;

  const SettingState({
    this.newEmail = const Email.pure(),
    this.newPassword = const Password.pure(),
    this.notification,
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  SettingState copyWith({
    Email? newEmail,
    Password? newPassword,
    bool? notification,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return SettingState(
      newEmail: newEmail ?? this.newEmail,
      newPassword: newPassword ?? this.newPassword,
      notification: notification ?? this.notification,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [newEmail, newPassword,notification,  status, errorMessage];
}
