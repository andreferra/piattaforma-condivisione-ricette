part of 'gaming_controller.dart';

class GamingState extends Equatable {
  final Gaming? gaming;
  final bool gameActive;

  const GamingState({
    this.gaming,
    required this.gameActive,
  });

  GamingState copyWith({
    Gaming? gaming,
    bool? gameActive,
  }) {
    return GamingState(
      gaming: gaming ?? this.gaming,
      gameActive: gameActive ?? this.gameActive,
    );
  }

  @override
  List<Object?> get props => [
        gaming,
        gameActive,
      ];
}
