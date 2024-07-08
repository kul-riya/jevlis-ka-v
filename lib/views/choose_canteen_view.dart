// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:jevlis_ka/constants/routes.dart';
import 'package:jevlis_ka/models/canteen_model.dart';
import 'package:jevlis_ka/services/cloud/firebase_canteen_service.dart';

class CanteenCard extends StatelessWidget {
  const CanteenCard({
    super.key,
    required this.name,
    required this.imagePath,
  });
  final String name;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.background),
          child: Center(
            child: Text(
              name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ),
    );
  }
}

class ChooseCanteenView extends StatefulWidget {
  const ChooseCanteenView({super.key});

  @override
  State<ChooseCanteenView> createState() => _ChooseCanteenViewState();
}

class _ChooseCanteenViewState extends State<ChooseCanteenView> {
  late final FirebaseCanteenService _canteenService;

  @override
  void initState() {
    _canteenService = FirebaseCanteenService();
    super.initState();
  }

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
      body: StreamBuilder(
        stream: _canteenService.getCanteens(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                final allCanteens = snapshot.data as Iterable<Canteen>;
                return CanteenListView(
                  canteens: allCanteens,
                  onTap: (canteenId) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      userHomeRoute,
                      (route) => false,
                      arguments: canteenId,
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

typedef UserHomeCallBack = void Function(String canteenId);

class CanteenListView extends StatelessWidget {
  const CanteenListView(
      {super.key, required this.canteens, required this.onTap});

  final Iterable<Canteen> canteens;
  final UserHomeCallBack onTap;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: canteens.length,
      itemBuilder: (context, index) {
        final canteen = canteens.elementAt(index);
        return GestureDetector(
          onTap: () {
            onTap(canteen.canteenId);
          },
          child: CanteenCard(
            name: canteen.name,
            imagePath: canteen.imagePath,
          ),
        );
      },
    );
  }
}
