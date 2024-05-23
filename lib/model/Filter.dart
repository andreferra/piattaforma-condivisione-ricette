class FiltroRicerca {
  List<String> tag;
  List<String> ingredienti;
  List<String> allergeni;

  FiltroRicerca({
    required this.tag,
    required this.ingredienti,
    required this.allergeni,
  });

  FiltroRicerca copyWith({
    List<String>? tag,
    List<String>? ingredienti,
    List<String>? allergeni,
  }) {
    return FiltroRicerca(
      tag: tag ?? this.tag,
      ingredienti: ingredienti ?? this.ingredienti,
      allergeni: allergeni ?? this.allergeni,
    );
  }

  FiltroRicerca.empty()
      : tag = [],
        ingredienti = [],
        allergeni = [];
}
