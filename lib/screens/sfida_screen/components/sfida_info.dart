// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:model_repo/model_repo.dart';

class SfidaInfo extends StatefulWidget {
  final Sfidegame sfide;
  const SfidaInfo({super.key, required this.sfide});

  @override
  State<SfidaInfo> createState() => _SfidaInfoState();
}

class _SfidaInfoState extends State<SfidaInfo> {
  Sfidegame get sfide => widget.sfide;
  late Timer? _timer;
  Duration _countdownDuration = const Duration();

  void _startCountDown() {
    if (sfide.dataFine != null) {
      final now = DateTime.now();
      if (sfide.dataFine!.isAfter(now)) {
        _countdownDuration = sfide.dataFine!.difference(now);
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

  @override
  void initState() {
    _startCountDown();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                const Text("Descrizione della sfida:",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 10),
                Text(sfide.description, style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text("Punti:",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 10),
                Text(sfide.punti.toString(),
                    style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text("Gioactori iscritti:",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 10),
                Text(sfide.partecipanti.toString(),
                    style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
          Column(
            children: [
              const Text("Data fine:",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 10),
              Text(_formatEndTime(sfide.dataFine!),
                  style: const TextStyle(fontSize: 20)),
            ],
          )
        ],
      ),
    );
  }
}
