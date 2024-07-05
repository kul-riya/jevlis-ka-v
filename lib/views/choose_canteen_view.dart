// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:jevlis_ka/constants/routes.dart';
// import 'package:jevlis_ka/views/canteen_menu_view.dart';

class CanteenCard extends StatelessWidget {
  const CanteenCard({super.key, required this.name, this.imagePath});
  final String name;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ),
      onTap: () {
        CollectionReference canteens =
            FirebaseFirestore.instance.collection('Canteens');
        canteens.get().then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((doc) {
            print('${doc.id} => ${doc.data()}');
          });
        });
        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil(userHomeRoute, (route) => false);
      },
    );
  }
}

class ChooseCanteenView extends StatelessWidget {
  const ChooseCanteenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
        elevation: 0,
        title: Image.asset(
          '/home/kul-riya/Developer/Flutter/jevlis_ka/lib/assets/images/hat_logo_white-removebg-preview.png',
          fit: BoxFit.contain,
          height: 65,
        ),
        toolbarHeight: 65,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_sharp))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Choose a Canteen:",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const CanteenCard(name: "one"),
            ],
          ),
        ),
      ),
    );
  }
}
