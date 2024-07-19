import 'package:flutter/material.dart';
import 'package:jevlis_ka/constants/json_string_constants.dart';
import 'package:jevlis_ka/models/order_model.dart';
import 'package:jevlis_ka/services/cloud/admin_canteen_service.dart';

class OrderLogView extends StatefulWidget {
  final String adminCanteenId;
  const OrderLogView({super.key, required this.adminCanteenId});

  @override
  State<OrderLogView> createState() => _OrderLogViewState();
}

class _OrderLogViewState extends State<OrderLogView> {
  late final FirebaseAdminService _adminService;

  @override
  void initState() {
    _adminService = FirebaseAdminService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _adminService.getOrders(adminCanteenId: widget.adminCanteenId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final allOrders = (snapshot.data!.toList());
          allOrders.removeWhere((order) =>
              order.orderStatus == orderReady ||
              order.orderStatus == orderCancelled);
          print("orders recorded");
          return Scaffold(
            appBar: AppBar(
              title: const Text("Order log"),
            ),
            body: ListView.builder(
              itemCount: allOrders.length,
              itemBuilder: (context, index) {
                final CanteenOrder order = allOrders[index];
                return OrderCard(
                    order: order,
                    onReady: () async {
                      await _adminService.makeOrderReady(orderId: order.id);
                    },
                    onCancel: () async {
                      await _adminService.makeOrderCancel(orderId: order.id);
                    });
              },
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

typedef VoidCallback = void Function();

class OrderCard extends StatelessWidget {
  final CanteenOrder order;
  final VoidCallback onReady;
  final VoidCallback onCancel;

  const OrderCard(
      {super.key,
      required this.order,
      required this.onReady,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.black26,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "OrderID:   ${order.id}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Row(
                  children: [
                    IconButton.filled(
                      onPressed: onReady,
                      icon: const Icon(
                        Icons.check_box,
                      ),
                      color: Colors.green,
                      padding: const EdgeInsets.all(5.0),
                    ),
                    IconButton.filled(
                      onPressed: onCancel,
                      icon: const Icon(
                        Icons.indeterminate_check_box,
                      ),
                      color: Colors.red,
                      padding: const EdgeInsets.all(5.0),
                    )
                  ],
                ),
              ],
            ),
          ),
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Name",
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Qty",
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Price",
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            Column(
              children: [
                Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: order.orderItems.length,
                      itemBuilder: (context, index) {
                        final orderItem = order.orderItems[index];
                        return Row(
                          children: [
                            Text("${(index + 1).toString()}.  "),
                            Text(orderItem.name),
                            Text(orderItem.quantity.toString()),
                            const Text("X"),
                            Text("₹ ${orderItem.price.toString()}")
                          ],
                        );
                      },
                    )),
              ],
            )
          ])
        ],
      ),
    );
  }
}
