class FiltroRicerca {
  List<String> tag;
  List<String> ingredienti;
  List<String> allergeni;
  List<String> tipoCucina;

  FiltroRicerca({
    required this.tag,
    required this.ingredienti,
    required this.allergeni,
    required this.tipoCucina,
  });

  FiltroRicerca copyWith({
    List<String>? tag,
    List<String>? ingredienti,
    List<String>? allergeni,
    List<String>? tipoCucina,
  }) {
    return FiltroRicerca(
      tag: tag ?? this.tag,
      ingredienti: ingredienti ?? this.ingredienti,
      allergeni: allergeni ?? this.allergeni,
      tipoCucina: tipoCucina ?? this.tipoCucina,
    );
  }
}
