import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_storage/firebase_ui_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:jevlis_ka/services/cloud/firebase_canteen_service.dart';

class EditMenuItemView extends StatefulWidget {
  final String adminCanteenId;
  const EditMenuItemView({super.key, required this.adminCanteenId});

  @override
  State<EditMenuItemView> createState() => _EditMenuItemViewState();
}

class _EditMenuItemViewState extends State<EditMenuItemView> {
  late final FirebaseCanteenService _canteenService;
  @override
  void initState() {
    _canteenService = FirebaseCanteenService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _canteenService.getMenuItems(canteenId: widget.adminCanteenId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final allMenuItems = snapshot.data as Iterable<MenuItem>;
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 280,
                    childAspectRatio: 1,
                    crossAxisSpacing: 40,
                    mainAxisSpacing: 40),
                itemCount: allMenuItems.length,
                itemBuilder: (context, index) {
                  final menuItem = allMenuItems.elementAt(index);
                  return MenuItemWidget(
                    menuItem: menuItem,
                    imageRef: _canteenService.getImageReference(
                        imagePath: menuItem.imagePath),
                    onToggleVisibility: (bool isHidden) async {
                      await _canteenService.updateVisibility(
                          isHidden, menuItem.id);
                    },
                    onEdit: () {
                      context.pushNamed("edit-item",
                          pathParameters: {"itemId": menuItem.id},
                          extra: menuItem);
                    },
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

typedef VoidCallback = void Function();
typedef BoolCallback = void Function(bool isHidden);

class MenuItemWidget extends StatelessWidget {
  final MenuItem menuItem;
  final Reference imageRef;
  final BoolCallback onToggleVisibility;
  final VoidCallback onEdit;
  const MenuItemWidget(
      {super.key,
      required this.menuItem,
      required this.imageRef,
      required this.onToggleVisibility,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: constraints.biggest.height * 0.65,
                width: double.infinity,
                child: StorageImage(
                  ref: imageRef,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    menuItem.name,
                                    style: const TextStyle(fontSize: 13.5),
                                    softWrap: true,
                                  ),
                                  const SizedBox(
                                    height: 2.0,
                                  ),
                                  Text(
                                    '₹ ${menuItem.price}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          onToggleVisibility(
                                              !menuItem.isHidden);
                                        },
                                        icon: Icon(menuItem.isHidden
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility)),
                                    IconButton(
                                        onPressed: onEdit,
                                        icon: const Icon(Icons.edit_outlined))
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
