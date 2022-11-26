import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
// import '../data_classes/manage_notification.dart';
import '../settings/panding_orders.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../data_classes/chek_registration_is_complete.dart';
import '../data_classes/local_data_sever.dart';
import '../models/constants.dart';
import '../settings/peending_order_detail.dart';
import '../widgets/sidedrawer.dart';
import 'package:flutter/material.dart';

class dashBoard extends StatefulWidget {
  dashBoard({Key? key}) : super(key: key);

  @override
  State<dashBoard> createState() => _dashBoardState();
}

class _dashBoardState extends State<dashBoard> {
  var shopOn = constants.shopStatus;
  late AndroidNotificationChannel channel;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  // String thisDeviceToken = "";
  @override
  void initState() {
    requestPermission();
    loadFcm();
    listenFcm();

    // getToken();
    FirebaseMessaging.instance.subscribeToTopic("Shops");
    super.initState();
  }

  void listenFcm() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              playSound: true,
              color: Colors.orange,

              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
    FirebaseMessaging.onBackgroundMessage((message) async {});
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!\nm\nh\ng\n');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                    notification.title!,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  content: Text(notification.body! +
                      "\nClick open to view details of order."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PandingOrders()));
                      },
                      child: const Text(
                        "Open",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ));
      }
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted pervisional permission");
    } else {
      print("User undeclined permission");
    }
  }

  void loadFcm() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
        enableLights: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  // void getToken() async {
  //   await FirebaseMessaging.instance.getToken().then((value) {
  //     // print("\n\ntoken == " + value.toString() + "\n\n");
  //     setState(() {
  //       thisDeviceToken = value.toString();
  //     });
  //   });
  // }

  @override
  void dispose() {
    shopOnOff(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 35,
        ),
        // centerTitle: true,
        title: Text(
          constants.shopName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Text(
                  "Shop Status",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                ),
              ),
              Switch(
                  activeColor: Colors.black,
                  value: shopOn,
                  onChanged: (val) {
                    setState(() {
                      shopOn = !shopOn;
                      shopOnOff(shopOn);
                    });
                  }),
            ],
          ),
        ],
      ),
      drawer: sdrawer(context),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
              left: 10,
              right: 10,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Panding order's",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              // top: 20,
              left: 8,
              right: 8,
            ),
            child: SizedBox(
              height: 170,
              // width: MediaQuery.of(context).size.width * 0.5,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(constants.masterOrderTableName)
                      .where('toshopdoc', isEqualTo: constants.shopId)
                      .where('ispendding', isEqualTo: true)
                      // .orderBy("createdAt", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data?.docs.length != 0) {
                      return snapshot.connectionState != ConnectionState.done
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                final res = snapshot.data!.docs[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.orange,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Order No: ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                res.id,
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 236, 231, 231)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Deliverd at: ",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "${res['orderuseraddress']}"
                                                      .substring(0, 20) +
                                                  "...",
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 236, 231, 231)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Net Total: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                "${res['nettotal']}",
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: MaterialButton(
                                            onPressed: () async {
                                              var connectivityResult =
                                                  await (Connectivity()
                                                      .checkConnectivity());
                                              if (connectivityResult ==
                                                      ConnectivityResult
                                                          .mobile ||
                                                  connectivityResult ==
                                                      ConnectivityResult.wifi) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PandingOrderDetail(
                                                                res.id, 1)));
                                              } else {
                                                showNoInternetDialogue(context);
                                              }
                                            },
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Text(
                                                "View Order Details"),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            );
                    } else {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "No pending order",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 149, 155, 165)),
                          ),
                        ),
                      );
                    }
                  }),
            ),
          ),
          const Divider(
            endIndent: 20,
            indent: 20,
            color: Color.fromARGB(255, 206, 200, 200),
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
              left: 10,
              right: 10,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Completed order's",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              // top: 20,
              left: 8,
              right: 8,
            ),
            child: SizedBox(
              height: 170,
              // width: MediaQuery.of(context).size.width * 0.5,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(constants.masterOrderTableName)
                      .where('toshopdoc', isEqualTo: constants.shopId)
                      .where('ispendding', isEqualTo: false)
                      // .orderBy("createdAt", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data?.docs.length != 0) {
                      return snapshot.connectionState != ConnectionState.done
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                final res = snapshot.data!.docs[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.orange,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Order No: ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                res.id,
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 236, 231, 231)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Deliverd at: ",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "${res['orderuseraddress']}"
                                                      .substring(0, 20) +
                                                  "...",
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 236, 231, 231)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Net Total: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                "${res['nettotal']}",
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: MaterialButton(
                                            onPressed: () async {
                                              var connectivityResult =
                                                  await (Connectivity()
                                                      .checkConnectivity());
                                              if (connectivityResult ==
                                                      ConnectivityResult
                                                          .mobile ||
                                                  connectivityResult ==
                                                      ConnectivityResult.wifi) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PandingOrderDetail(
                                                                res.id, 0)));
                                              } else {
                                                showNoInternetDialogue(context);
                                              }
                                            },
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Text(
                                                "View Order Details"),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            );
                    } else {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "No order is completed yet",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 149, 155, 165)),
                          ),
                        ),
                      );
                    }
                  }),
            ),
          ),
          const Divider(
            endIndent: 20,
            indent: 20,
            color: Color.fromARGB(255, 206, 200, 200),
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

Future<void> shopOnOff(bool val) async {
  constants.shopStatus = val;
  await LocalDataSever.setShopStatus(val);
  ShopRegistration.setShopStatusFirebase(val);
}
