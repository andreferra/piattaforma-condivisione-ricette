part of "profile_controller.dart";

class ProfileState extends Equatable {
  final String? newPhotoUrl;
  final Nickname? newNickname;
  final String? newBio;
  List<String> prefAlimentari;
  List<String> allergie;
  List<String> interessiCulinari;
  final FormzStatus status;
  final String? errorMessage;

  const ProfileState({
    this.newPhotoUrl,
    this.newNickname = const Nickname.pure(),
    this.newBio,
    this.prefAlimentari = const [],
    this.allergie = const [],
    this.interessiCulinari = const [],
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  ProfileState copyWith({
    String? newPhotoUrl,
    Nickname? newNickname,
    String? newBio,
    List<String>? prefAlimentari,
    List<String>? allergie,
    List<String>? interessiCulinari,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return ProfileState(
      newPhotoUrl: newPhotoUrl ?? this.newPhotoUrl,
      newNickname: newNickname ?? this.newNickname,
      newBio: newBio ?? this.newBio,
      prefAlimentari: prefAlimentari ?? this.prefAlimentari,
      allergie: allergie ?? this.allergie,
      interessiCulinari: interessiCulinari ?? this.interessiCulinari,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        newPhotoUrl,
        newNickname,
        newBio,
        prefAlimentari,
        allergie,
        interessiCulinari,
        status,
      ];
}
