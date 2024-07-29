import 'package:flutter/material.dart';
import 'package:jevlis_ka/constants/json_string_constants.dart';
import 'package:jevlis_ka/models/order_model.dart';
import 'package:jevlis_ka/services/cloud/firebase_admin_service.dart';

class OrderHistoryView extends StatefulWidget {
  final String adminCanteenId;
  const OrderHistoryView({super.key, required this.adminCanteenId});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
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
            final allOrders = snapshot.data!.toList();
            allOrders.removeWhere((order) => order.orderStatus == orderPlaced);
            allOrders.sort(
                (b, a) => a.orderPlacingTime.compareTo(b.orderPlacingTime));
            final readyOrders = allOrders
                .where((element) => element.orderStatus == orderReady)
                .toList();
            final finishedOrders = allOrders
                .where((element) =>
                    element.orderStatus == orderCancelled ||
                    element.orderStatus == orderPicked)
                .toList();
            final historyOrders = [...readyOrders, ...finishedOrders];
            return Scaffold(
              body: ListView.builder(
                  itemCount: historyOrders.length,
                  itemBuilder: (context, index) {
                    final CanteenOrder order = historyOrders.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: OrderHistoryCard(
                          order: order,
                          onCancel: () async {
                            await _adminService.updateOrderStatus(
                                orderId: order.id, orderStatus: orderCancelled);
                          },
                          onPickedUp: () async {
                            await _adminService.updateOrderStatus(
                                orderId: order.id, orderStatus: orderPicked);
                          }),
                    );
                  }),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

typedef VoidCallback = void Function();

class OrderHistoryCard extends StatelessWidget {
  final CanteenOrder order;
  final VoidCallback onPickedUp;
  final VoidCallback onCancel;

  const OrderHistoryCard(
      {super.key,
      required this.order,
      required this.onCancel,
      required this.onPickedUp});

  @override
  Widget build(BuildContext context) {
    final String status =
        order.orderStatus == orderReady ? "IS READY FOR PICK UP" : "";

    return Card(
      elevation: 12,
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      color: order.orderStatus == orderReady
          ? Colors.grey.shade200
          : Colors.grey.shade700,
      shadowColor: Colors.black26,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "OrderID:   ${order.id} \n $status",
                    style: Theme.of(context).textTheme.titleSmall,
                    softWrap: true,
                  ),
                ),
                if (order.orderStatus == orderReady) ...{
                  Row(
                    children: [
                      IconButton.filled(
                        onPressed: onPickedUp,
                        icon: const Icon(
                          Icons.emoji_people_outlined,
                        ),
                        color: Colors.green,
                        padding: const EdgeInsets.only(right: 5.0),
                      ),
                      IconButton.filled(
                        onPressed: onCancel,
                        icon: const Icon(
                          Icons.indeterminate_check_box,
                        ),
                        color: Colors.red,
                        padding: const EdgeInsets.only(right: 10.0),
                      ),
                    ],
                  ),
                }
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(children: [
              Column(
                children: [
                  Container(
                      // padding: const EdgeInsets.only(bottom: 12),
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: order.orderItems.length,
                        itemBuilder: (context, index) {
                          final orderItem = order.orderItems[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: Row(
                                    children: [
                                      Text("${(index + 1).toString()}.   "),
                                      Flexible(
                                        child: Text(
                                          orderItem.name,
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Text(
                                      orderItem.quantity.toString(),
                                      textAlign: TextAlign.center,
                                    )),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Text(
                                      "₹ ${orderItem.price.toString()}",
                                      textAlign: TextAlign.center,
                                    ))
                              ],
                            ),
                          );
                        },
                      )),
                  const Divider(),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 6.0, bottom: 8.0, right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Total Price: ${order.totalPrice}",
                            style: Theme.of(context).textTheme.titleSmall,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ]),
          )
        ],
      ),
    );
  }
}
