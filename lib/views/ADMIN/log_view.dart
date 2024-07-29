import 'package:flutter/material.dart';
import 'package:jevlis_ka/constants/json_string_constants.dart';
import 'package:jevlis_ka/models/order_model.dart';
import 'package:jevlis_ka/services/cloud/firebase_admin_service.dart';

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
          allOrders.removeWhere((order) => order.orderStatus != orderPlaced);
          allOrders
              .sort((b, a) => a.orderPlacingTime.compareTo(b.orderPlacingTime));

          // print("orders recorded");
          return Scaffold(
            body: ListView.builder(
              itemCount: allOrders.length,
              itemBuilder: (context, index) {
                final CanteenOrder order = allOrders[index];
                return OrderCard(
                    order: order,
                    onReady: () async {
                      await _adminService.updateOrderStatus(
                          orderId: order.id, orderStatus: orderReady);
                    },
                    onCancel: () async {
                      await _adminService.updateOrderStatus(
                          orderId: order.id, orderStatus: orderCancelled);
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

class OrderCard extends StatefulWidget {
  final CanteenOrder order;
  final VoidCallback onReady;
  final VoidCallback onCancel;

  const OrderCard(
      {super.key,
      required this.order,
      required this.onReady,
      required this.onCancel});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    final orderItems = widget.order.orderItems;
    return Card(
      elevation: 12,
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      color: Colors.white,
      shadowColor: Colors.black26,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "OrderID:   ${widget.order.id}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Row(
                  children: [
                    IconButton.filled(
                      onPressed: widget.onCancel,
                      icon: const Icon(
                        Icons.indeterminate_check_box,
                      ),
                      color: Colors.red,
                      padding: const EdgeInsets.only(right: 10.0),
                    ),
                    IconButton.filled(
                      onPressed: widget.onCancel,
                      icon: const Icon(
                        Icons.indeterminate_check_box,
                      ),
                      color: Colors.red,
                      padding: const EdgeInsets.only(right: 10.0),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ["Name", "0.40"],
                  ["Qty", "0.15"],
                  ["Price Per Item", "0.15"]
                ].map((header) {
                  final itemWidth = double.parse(header[1]);
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * itemWidth,
                    child: Text(
                      header[0],
                      style: Theme.of(context).textTheme.labelMedium,
                      textAlign: TextAlign.center,
                    ),
                  );
                }).toList(),
              ),
              const Divider(),
              Column(
                children: [
                  Container(
                      // padding: const EdgeInsets.only(bottom: 12),
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: orderItems.length,
                        itemBuilder: (context, index) {
                          final orderItem = orderItems[index];
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
                            "Total Price: ${widget.order.totalPrice}",
                            style: Theme.of(context).textTheme.labelLarge,
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
