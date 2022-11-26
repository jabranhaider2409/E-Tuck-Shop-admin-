import 'dart:async';
// import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_pack/data_classes/chek_registration_is_complete.dart';
import 'package:do_pack/data_classes/manage_notification.dart';
import '../models/constants.dart';
import 'package:flutter/material.dart';
import '../data_classes/item_firebase_services.dart';

class PandingOrderDetail extends StatefulWidget {
  String? orderID;
  int? chek;
  PandingOrderDetail(this.orderID, this.chek, {Key? key}) : super(key: key);

  @override
  State<PandingOrderDetail> createState() =>
      _PandingOrderDetailState(orderId: orderID, check: chek);
}

class _PandingOrderDetailState extends State<PandingOrderDetail> {
  String? orderId;
  int? check;
  _PandingOrderDetailState({this.orderId, this.check});
  String? shopName;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }

  double subtotal = 0.0;
  String deliverAdress = "";
  Timer? timer;
  void getName() async {
    timer = Timer(
      const Duration(seconds: 2),
      () {
        setState(() {
          print("set state called");
        });
      },
    );
    shopName = await ItemOperation.getOrderdShopName(orderId.toString());
    subtotal = await ItemOperation.getSubTotal(orderId.toString());
    deliverAdress = await ItemOperation.getDeliverAddress(orderId.toString());
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Order Detail",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: shopName != null
          ? ListView(
              // physics: ClampingScrollPhysics(),
              // physics: const NeverScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      shopName.toString()[0].toUpperCase() +
                          shopName.toString().substring(1),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  endIndent: 20,
                  indent: 20,
                  color: Colors.grey,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                    bottom: 10,
                  ),
                  // height: 150,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 8, 154, 115),
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          children: [
                            const Text(
                              "Payment",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Sub Total: ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Rs. " + subtotal.toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Delivery: ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: 73,
                                  child: const Text(
                                    "Rs. 50.0",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Net Total: ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Rs. " + (subtotal + 50).toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        endIndent: 20,
                        indent: 20,
                        color: Colors.grey,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 8, 148, 146),
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                              ),
                              child: Text(
                                "Delivery at",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                left: 5,
                                right: 5,
                                bottom: 10,
                              ),
                              child: Text(
                                deliverAdress,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(
                  endIndent: 20,
                  indent: 20,
                  color: Colors.grey,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: const Text(
                      "List of items",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 8, 148, 146),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 1 - 300,
                  padding: const EdgeInsets.only(
                      top: 5, left: 5, right: 5, bottom: 5),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(constants.detailMasterOrderTableName)
                          .where('masterorderdocid', isEqualTo: orderId)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data!.docs.isNotEmpty
                              ? ListView.builder(
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final res = snapshot.data!.docs[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Container(
                                        // height: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        (index + 1).toString() +
                                                            " - ",
                                                        style: const TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 170,
                                                        child: Text(
                                                          "${res['itemname']}"[
                                                                      0]
                                                                  .toUpperCase() +
                                                              "${res['itemname']}"
                                                                  .substring(1),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                      "${res['itemquantity']}"),
                                                ],
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(
                                                  "Rs. " "${res['itemtotal']}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Text(
                                      "Something went wrong...",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 149, 155, 165)),
                                    ),
                                  ),
                                );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          );
                        }
                      }),
                ),
                check == 1
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text("Order"),
                                        content: const Text(
                                            "Order status is to be changed.\nIs order deliverd at proper location?"),
                                        actions: [
                                          MaterialButton(
                                            onPressed: () async {
                                              showWaitingDialogue();
                                              //
                                              String placeOrderToken =
                                                  await ShopRegistration
                                                      .getPlaceOrderUserToken(
                                                          orderId!);
                                              //
                                              await ItemOperation
                                                  .setOrderComplete(orderId!);
                                              //
                                              await Notifications.sendPushMessage(
                                                  body:
                                                      "Order is deliverd. Tap to view details. " +
                                                          constants.shopName,
                                                  title: "Order complete",
                                                  thisDeviceToken:
                                                      placeOrderToken);
                                              //
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              // Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Yes",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop('dialog');
                                            },
                                            child: const Text(
                                              "No",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ));

                              // Navigator.pop(context);
                            },
                            child: const Text(
                              "Deliverd?",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Center(
                          child: Text(
                            "Complete",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  showWaitingDialogue() {
    showDialog(
        context: context,
        builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                  alignment: FractionalOffset.center,
                  height: 80.0,
                  padding: const EdgeInsets.all(20.0),
                  child: const CircularProgressIndicator()),
            ));
  }
}
