// Flutter imports:
// Project imports:
import 'package:condivisionericette/screens/gaming/components/sfide_badge.dart';
import 'package:condivisionericette/screens/gaming/components/user_level_badge.dart';
import 'package:flutter/material.dart';
import 'package:model_repo/model_repo.dart';

class GamingHeader extends StatelessWidget {
  final Gaming gaming;
  const GamingHeader({required this.gaming, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          UserLevelBadge(
            point: gaming.punti,
            name: gaming.gameName,
          ),
          SfideBadge(
            sfidePartecipate: gaming.sfidePartecipate,
            sfideVinte: gaming.sfideVinte,
          ),
          InkWell(
            onTap: () => showRulesDialog(context),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.greenAccent.withOpacity(0.8),
              ),
              child: const Icon(
                Icons.question_mark_sharp,
                size: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10),
          scrollable: true,
          title: const Text('Regole del Gioco di Cucina'),
          content: const SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(10),
            child: ListBody(
              children: <Widget>[
                Text(
                    'Benvenuti al gioco di cucina! Qui troverai le regole su come guadagnare punti e interagire con la comunità. Buon divertimento!'),
                SizedBox(height: 20),
                Text('1. Completa le Ricette'),
                Text(
                    '   - Descrizione: Segui le istruzioni e completa le ricette proposte nel gioco.'),
                Text(
                    '   - Punti: Ogni ricetta completata ti fa guadagnare 100 punti.'),
                SizedBox(height: 10),
                Text('2. Pubblica le Ricette'),
                Text(
                    '   - Descrizione: Dopo aver completato una ricetta, puoi pubblicarla per condividerla con la comunità.'),
                Text(
                    '   - Punti: Ogni ricetta pubblicata ti fa guadagnare 500 punti.'),
                SizedBox(height: 10),
                Text('3. Ricevi Commenti'),
                Text(
                    '   - Descrizione: Altri giocatori possono commentare le tue ricette pubblicate. Ogni commento ricevuto ti aiuta a migliorare e interagire con gli altri.'),
                Text(
                    '   - Punti: Ogni commento ricevuto ti fa guadagnare 50 punti.'),
                SizedBox(height: 10),
                Text('4. Lascia Commenti'),
                Text(
                    '   - Descrizione: Interagisci con la comunità lasciando commenti sulle ricette degli altri giocatori.'),
                Text(
                    '   - Punti: Ogni commento lasciato ti fa guadagnare 25 punti.'),
                SizedBox(height: 10),
                Text('5. Interagisci con Altri'),
                Text(
                    '   - Descrizione: Partecipa attivamente alla comunità interagendo con altri giocatori attraverso like, risposte ai commenti e altre forme di interazione.'),
                Text(
                    '   - Punti: Ogni interazione ricevuta (come un like o una risposta ai tuoi commenti) ti fa guadagnare 10 punti.'),
                SizedBox(height: 20),
                Text('Obiettivo del Gioco'),
                Text(
                    'Il tuo obiettivo è diventare il miglior chef virtuale, accumulando il maggior numero di punti attraverso la partecipazione attiva e il completamento delle ricette.'),
                SizedBox(height: 20),
                Text('Divertiti a Cucinare!'),
                Text(
                    'Sperimenta nuove ricette, condividi le tue creazioni e interagisci con una comunità appassionata di cucina. Buon divertimento e buona cucina!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CHIUDI'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
