// ignore_for_file: avoid_print

import 'package:firebase_ui_storage/firebase_ui_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jevlis_ka/models/canteen_model.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_bloc.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_event.dart';
import 'package:jevlis_ka/services/cloud/firebase_canteen_service.dart';

// ignore: must_be_immutable
class CanteenCard extends StatelessWidget {
  CanteenCard(
      {super.key,
      required this.name,
      required this.imagePath,
      required this.location,
      required this.canteenService});
  final String name;
  final String imagePath;
  final String location;
  FirebaseCanteenService canteenService;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: StorageImage(
                ref: canteenService.getImageReference(imagePath: imagePath),
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    location,
                    style: Theme.of(context).textTheme.labelSmall,
                  )
                ],
              ),
            )
          ],
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
                return ListView.builder(
                  itemCount: allCanteens.length,
                  itemBuilder: (context, index) {
                    final canteen = allCanteens.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        context.read<AuthBloc>().add(AuthEventCanteenSelected(
                            canteenId: canteen.canteenId, name: canteen.name));
                      },
                      child: CanteenCard(
                        name: canteen.name,
                        imagePath: canteen.imagePath,
                        location: canteen.location,
                        canteenService: _canteenService,
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// typedef UserHomeCallBack = void Function(String canteenId);

// class CanteenListView extends StatelessWidget {
//   const CanteenListView(
//       {super.key, required this.canteens, required this.onTap});

//   final Iterable<Canteen> canteens;
//   final UserHomeCallBack onTap;
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: canteens.length,
//       itemBuilder: (context, index) {
//         final canteen = canteens.elementAt(index);
//         return GestureDetector(
//           onTap: () {
//             onTap(canteen.canteenId);
//           },
//           child: CanteenCard(
//             name: canteen.name,
//             imagePath: canteen.imagePath,
//             location: canteen.location,
//           ),
//         );
//       },
//     );
//   }
// }
