// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:model_repo/model_repo.dart';

// Project imports:
import 'package:condivisionericette/utils/constant.dart';

class NextSfideListComponents extends StatefulWidget {
  final Sfidegame sfidegame;
  const NextSfideListComponents({super.key, required this.sfidegame});

  @override
  State<NextSfideListComponents> createState() =>
      _NextSfideListComponentsState();
}

class _NextSfideListComponentsState extends State<NextSfideListComponents> {
  Sfidegame get sfida => widget.sfidegame;
  late Timer? _timer;
  Duration _countdownDuration = const Duration();

  void _startCountDown() {
    if (sfida.dataFine != null) {
      final now = DateTime.now();
      if (sfida.dataFine!.isAfter(now)) {
        _countdownDuration = sfida.dataFine!.difference(now);
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_countdownDuration.inSeconds == 0 ||
              _countdownDuration.isNegative) {
            timer.cancel();
          } else {
            setState(() {
              _countdownDuration =
                  _countdownDuration - const Duration(seconds: 1);
            });
          }
        });
      }
    }
  }

  String _formatEndTime(DateTime endTime) {
    final now = DateTime.now();
    if (endTime.isBefore(now)) {
      return 'L\'evento è già terminato';
    }

    final duration = endTime.difference(now);
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    if (days > 1) {
      return 'Termina tra: $days giorni';
    } else if (days > 0) {
      return 'Termina tra: $days giorno';
    } else if (hours > 1) {
      return 'Termina tra: $hours ore';
    } else if (hours > 0) {
      return 'Termina tra: $hours ora';
    } else if (minutes > 1) {
      return 'Termina tra: $minutes minuti';
    } else {
      return 'Termina tra: $seconds secondi';
    }
  }

  String _formatStartTime(DateTime startTime) {
    final now = DateTime.now();
    if (startTime.isBefore(now)) {
      return 'L\'evento è già iniziato';
    }

    final duration = startTime.difference(now);
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 1) {
      return 'Inizia tra: $days giorni';
    } else if (days > 0) {
      return 'Inizia tra: $days giorno';
    } else if (hours > 1) {
      return 'Inizia tra: $hours ore';
    } else if (hours > 0) {
      return 'Inizia tra: $hours ora';
    } else if (minutes > 1) {
      return 'Inizia tra: $minutes minuti';
    } else if (minutes > 0) {
      return 'Inizia tra: $minutes minuto';
    } else {
      return 'Inizia tra: $seconds secondi';
    }
  }

  @override
  void initState() {
    _startCountDown();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer!.isActive) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.deepOrange, Colors.redAccent],
          transform: GradientRotation(0.5),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sfida.name.split(':').last,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: secondaryColor,
                    ),
                  ),
                  Text(
                    sfida.description.length > 150
                        ? '${sfida.description.substring(0, 150)}...'
                        : sfida.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatStartTime(sfida.dataInizio!),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _formatEndTime(sfida.dataFine!),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
