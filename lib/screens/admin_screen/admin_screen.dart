// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:model_repo/model_repo.dart';

// Project imports:
import 'package:condivisionericette/screens/admin_screen/components/add_new_challenge.dart';
import 'package:condivisionericette/widget/sfide/sfide_card.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  AuthenticationRepository auth = AuthenticationRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen'),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await auth.signOut();
              }),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const AddNewChallenge(),
            ),
            const Divider(
              color: Colors.white,
              thickness: 2,
            ),
            const Text("SFIDE PRESENTI", style: TextStyle(fontSize: 20)),
            FutureBuilder(
              future: firestore
                  .collection("sfide")
                  .where("dataFine", isGreaterThan: DateTime.now())
                  .orderBy("dataInizio", descending: false)
                  .get()
                  .catchError((error) {
                print("Error: $error");
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Text('No sfide found');
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: SfideCard(
                          sfida: Sfidegame.fromMap(
                              snapshot.data!.docs[index].data())),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
