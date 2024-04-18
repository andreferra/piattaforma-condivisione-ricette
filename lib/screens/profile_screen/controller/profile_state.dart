part of "profile_controller.dart";

class ProfileState extends Equatable {
  final String? newPhotoUrl;
  final Nickname? newNickname;
  final Bio? newBio;
  final Allergeni? allergeno;
  final List<String> prefAlimentari;
  final List<String> allergie;
  final List<String> interessiCulinari;
  final FormzStatus status;
  final String? errorMessage;

  const ProfileState({
    this.newPhotoUrl,
    this.allergeno = const Allergeni.pure(),
    this.newNickname = const Nickname.pure(),
    this.newBio = const Bio.pure(),
    this.prefAlimentari = const [],
    this.allergie = const [],
    this.interessiCulinari = const [],
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  ProfileState copyWith({
    String? newPhotoUrl,
    Nickname? newNickname,
    Bio? newBio,
    Allergeni? allergeno,
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
      allergeno: allergeno ?? this.allergeno,
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
        allergeno,
        status,
      ];
}
