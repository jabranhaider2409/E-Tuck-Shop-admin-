import 'package:connectivity/connectivity.dart';
import '../Add_item.dart';
import '../models/constants.dart';

import '../items_list_category_filter.dart';
import '../manage_category.dart';
import '../setting.dart';
import '../dashboard.dart';
import '../settings/order_history.dart';
import '../settings/panding_orders.dart';
import '../data_classes/login_google_firebase_auth.dart';
import 'package:flutter/material.dart';
import '../login.dart';

Widget sdrawer(context) {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.orange,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Text(
                    constants.ownerName.isNotEmpty
                        ? constants.ownerName.substring(0, 1)
                        : "U",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: Text(
                    constants.shopName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          title: Row(
            children: const <Widget>[
              Icon(
                Icons.add_circle_rounded,
                size: 25,
                color: Colors.orange,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("Add New Item"),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddItem()));
          },
        ),
        ListTile(
          title: Row(
            children: const <Widget>[
              Icon(
                Icons.list_alt,
                size: 25,
                color: Colors.orange,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("Manage Items"),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemsListCategoryFilter()));
          },
        ),
        ListTile(
          title: Row(
            children: const <Widget>[
              Icon(
                Icons.category_sharp,
                size: 25,
                color: Colors.orange,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("Manage Category"),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ManageCategory()));
          },
        ),
        const Divider(
          indent: 25,
          endIndent: 25,
          color: Colors.grey,
          thickness: 0.9,
        ),
        ListTile(
          title: Row(
            children: const <Widget>[
              Icon(
                Icons.history,
                size: 25,
                color: Colors.orange,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("Order history"),
              ),
            ],
          ),
          onTap: () async {
            Navigator.pop(context);
            var connectivityResult = await (Connectivity().checkConnectivity());
            if (connectivityResult == ConnectivityResult.mobile ||
                connectivityResult == ConnectivityResult.wifi) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OrdrsHistory()));
            } else {
              showNoInternetDialogue(context);
            }
          },
        ),
        ListTile(
          title: Row(
            children: const <Widget>[
              Icon(
                Icons.pending_actions,
                size: 25,
                color: Colors.orange,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("Pending orders"),
              ),
            ],
          ),
          onTap: () async {
            Navigator.pop(context);
            var connectivityResult = await (Connectivity().checkConnectivity());
            if (connectivityResult == ConnectivityResult.mobile ||
                connectivityResult == ConnectivityResult.wifi) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PandingOrders()));
            } else {
              showNoInternetDialogue(context);
            }
          },
        ),
        ListTile(
          title: Row(
            children: const <Widget>[
              Icon(
                Icons.settings,
                size: 25,
                color: Colors.orange,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("Setting"),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Setting()));
          },
        ),
        const Divider(
          indent: 25,
          endIndent: 25,
          color: Colors.grey,
          thickness: 0.9,
        ),
        ListTile(
          title: Row(
            children: const <Widget>[
              Icon(
                Icons.logout_rounded,
                size: 25,
                color: Colors.orange,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("Log Out"),
              ),
            ],
          ),
          onTap: () {
            signOutGoogleFirebase(context);
          },
        ),
      ],
    ),
  );
}

void signOutGoogleFirebase(context) async {
  bool isSignOut = await signOut();
  if (isSignOut) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const login()));
  } else {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => dashBoard()));
  }
}

void showNoInternetDialogue(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Internet"),
            content: const Text(
                "Internet connection not available.\nPlease turn on cellular data or wifi."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
                child: const Text(
                  "Ok",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              )
            ],
          ));
}
