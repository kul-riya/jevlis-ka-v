import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jevlis_ka/components/dialogs/delete_item_dialog.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:jevlis_ka/services/cloud/cloud_storage_exceptions.dart';
import 'package:jevlis_ka/services/cloud/firebase_admin_service.dart';

class CreateUpdateItemView extends StatefulWidget {
  final MenuItem item;
  const CreateUpdateItemView({super.key, required this.item});

  @override
  State<CreateUpdateItemView> createState() => _CreateUpdateItemViewState();
}

class _CreateUpdateItemViewState extends State<CreateUpdateItemView> {
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _priceController;
  late final FirebaseAdminService _adminService;
  bool _isHidden = false;
  bool _isVeg = false;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.item.name);
    _categoryController = TextEditingController(text: widget.item.category);
    _priceController =
        TextEditingController(text: widget.item.price.toString());
    _isHidden = widget.item.isHidden;
    _isVeg = widget.item.isVeg;
    _adminService = FirebaseAdminService();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuItem = widget.item;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit menu: ${menuItem.name}"),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            TextFormField(
              controller: _nameController,
              autofocus: true,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Availability",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.visibility_off_outlined,
                      color: _isHidden ? Colors.black : Colors.grey.shade300,
                    ),
                    Switch(
                        activeColor: Colors.green.shade300,
                        value: !_isHidden,
                        onChanged: (value) {
                          setState(() {
                            _isHidden = !value;
                          });
                        }),
                    Icon(
                      Icons.visibility,
                      color: _isHidden ? Colors.grey.shade300 : Colors.black,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Veg",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: _isVeg ? Colors.red.shade100 : Colors.red,
                    ),
                    Switch(
                        activeColor: Colors.green.shade300,
                        value: _isVeg,
                        onChanged: (value) {
                          setState(() {
                            _isVeg = value;
                          });
                        }),
                    Icon(
                      Icons.circle,
                      color: _isVeg ? Colors.green : Colors.green.shade100,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 24, right: 24),
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () async {
                  final bool shouldDelete =
                      await showDeleteItemDialog(context, name: menuItem.name);
                  if (shouldDelete) {
                    try {
                      await _adminService.deleteItem(id: menuItem.id);
                    } catch (e) {
                      throw CouldNotDeleteItemException();
                    }

                    context.pop();
                  }
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                )),
            const SizedBox(
              width: 12,
            ),
            TextButton(
                onPressed: () {
                  context.goNamed("home-screen");
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black54),
                )),
            const SizedBox(
              width: 12,
            ),
            TextButton(
                onPressed: () async {
                  await _adminService.updateItem(
                      item: MenuItem(
                          category: _categoryController.text,
                          isHidden: _isHidden,
                          isVeg: _isVeg,
                          imagePath: menuItem.imagePath,
                          id: menuItem.id,
                          name: _nameController.text,
                          price: double.parse(_priceController.text),
                          canteenId: menuItem.canteenId));
                },
                child: const Text(
                  "Apply",
                  style: TextStyle(color: Colors.green),
                ))
          ],
        ),
      ),
    );
  }
}
