part of "profile_controller.dart";

class ProfileState extends Equatable {
  final String? newPhotoUrl;
  final Nickname? newNickname;
  final Bio? newBio;
  final Allergeni? allergeno;
  final InteressiCulinari? interesseCulinario;
  final PreferenzeAlimentari? alimentoPreferito;
  final List<String> prefAlimentari;
  final List<String> allergie;
  final List<String> interessiCulinari;
  final FormzStatus  status;
  final String? errorMessage;
  final Uint8List? newPhoto;

  const ProfileState({
    this.newPhotoUrl,
    this.allergeno = const Allergeni.pure(),
    this.interesseCulinario = const InteressiCulinari.pure(),
    this.newNickname = const Nickname.pure(),
    this.alimentoPreferito = const PreferenzeAlimentari.pure(),
    this.newBio = const Bio.pure(),
    this.prefAlimentari = const [],
    this.allergie = const [],
    this.interessiCulinari = const [],
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.newPhoto,
  });

  ProfileState copyWith({
    String? newPhotoUrl,
    Nickname? newNickname,
    Bio? newBio,
    InteressiCulinari? interesseCulinario,
    Allergeni? allergeno,
    List<String>? prefAlimentari,
    List<String>? allergie,
    PreferenzeAlimentari? alimentoPreferito,
    List<String>? interessiCulinari,
    FormzStatus? status,
    String? errorMessage,
    Uint8List? newPhoto,
  }) {
    return ProfileState(
      newPhotoUrl: newPhotoUrl ?? this.newPhotoUrl,
      newNickname: newNickname ?? this.newNickname,
      newBio: newBio ?? this.newBio,
      allergeno: allergeno ?? this.allergeno,
      prefAlimentari: prefAlimentari ?? this.prefAlimentari,
      allergie: allergie ?? this.allergie,
      alimentoPreferito: alimentoPreferito ?? this.alimentoPreferito,
      interessiCulinari: interessiCulinari ?? this.interessiCulinari,
      interesseCulinario: interesseCulinario ?? this.interesseCulinario,
      status: status ?? this.status,
      errorMessage: errorMessage,
      newPhoto: newPhoto ?? this.newPhoto,
    );
  }

  @override
  List<Object?> get props =>
      [
        newPhotoUrl,
        newNickname,
        newBio,
        prefAlimentari,
        allergie,
        interessiCulinari,
        alimentoPreferito,
        interesseCulinario,
        allergeno,
        newPhoto,
        status,
      ];
}
