import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condivisionericette/screens/public_profile/public_profile_screen.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';

class ClassificaUtenti extends StatefulWidget {
  final String mioId;
  const ClassificaUtenti({super.key, required this.mioId});

  @override
  State<ClassificaUtenti> createState() => _ClassificaUtentiState();
}

class _ClassificaUtentiState extends State<ClassificaUtenti> {
  String get mioId => widget.mioId;

  final FirebaseRepository firebase = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.5,
      child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where('gameActive', isEqualTo: true)
              .orderBy('gaming.punti', descending: true)
              .limit(10)
              .get(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snap.hasError) {
              return const Center(
                child: Text('Errore nel caricamento dei dati'),
              );
            }
            return Column(
              children: [
                const Text("Migliori 10 giocatori",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemCount: snap.data!.docs.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      style: ListTileStyle.list,
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        child: Text('${i + 1}'),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PublicProfile(
                                snap.data!.docs[i]['uid'], mioId)));
                      },
                      title: Text(snap.data!.docs[i]['nickname']),
                      subtitle: Text(
                          snap.data!.docs[i]['gaming']['punti'].toString()),
                    );
                  },
                ),
              ],
            );
          }),
    );
  }
}
