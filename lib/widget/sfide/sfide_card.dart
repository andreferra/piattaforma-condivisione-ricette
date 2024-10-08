// Dart imports:
import 'dart:async';

// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:model_repo/model_repo.dart';

class SfideCard extends StatefulWidget {
  final Sfidegame? sfida;
  final bool old;
  final bool short;
  const SfideCard(
      {super.key, required this.sfida, this.old = false, this.short = false});

  @override
  State<SfideCard> createState() => _SfideCardState();
}

class _SfideCardState extends State<SfideCard> {
  final FirebaseRepository firebase = FirebaseRepository();
  Sfidegame get sfida => widget.sfida!;
  bool get short => widget.short;
  late Timer _timer;
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

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      return '$days giorni, $hours ore';
    } else if (hours > 0) {
      return '$hours ore, $minutes minuti';
    } else if (minutes > 0) {
      return '$minutes minuti, $seconds secondi';
    } else {
      return '$seconds secondi';
    }
  }

  @override
  void initState() {
    _startCountDown();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          transform: GradientRotation(0.5),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      short ? sfida.name.split(':').last : sfida.name,
                      style: TextStyle(
                        fontSize: short ? 22 : 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    if (!short)
                      Text(
                        '${sfida.description.substring(0, 100)}...',
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sfida.partecipanti.toString(),
                      style: TextStyle(
                        fontSize: short ? 22.0 : 26.0,
                      ),
                    ),
                    if (!short) const SizedBox(height: 8.0),
                    Text(
                      'Partecipanti',
                      style: TextStyle(
                        fontSize: short ? 12 : 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (sfida.dataFine != null && !widget.old)
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatDuration(_countdownDuration),
                        style: TextStyle(
                          fontSize: short ? 22 : 26.0,
                        ),
                      ),
                      if (!short) const SizedBox(height: 8.0),
                      Text(
                        'Termine della gara',
                        style: TextStyle(
                          fontSize: short ? 12 : 16.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.old && sfida.classifica.isNotEmpty)
                FutureBuilder<String>(
                  future: firebase.getNicknameFromSfida(sfida),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return const Text('Errore nel caricamento dei dati');
                    }
                    return Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 26.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Vincitore',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
