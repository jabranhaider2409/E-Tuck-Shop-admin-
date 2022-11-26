import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_pack/models/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as refff;

import 'firebase_connection.dart';

class ItemOperation {
  static Future<void> addItem(
      String name, String desc, double price, String category, File img) async {
    String imgurl = await uloadImage(img);
    firebasefirestore.collection(constants.itemsTableName).add({
      'name': name,
      'description': desc,
      'price': price,
      'category': category,
      'mail': constants.mail,
      'url': imgurl
    }).then((value) {
      print("Item added successfully..");
    }).catchError((e) {
      print(e.toString());
    });
  }

  static Future<void> deleteItem(String id) async {
    String imgurl = "";
    await firebasefirestore
        .collection(constants.itemsTableName)
        .doc(id)
        .get()
        .then((value) {
      imgurl = value.get('url').toString();
    });
    await refff.FirebaseStorage.instance.refFromURL(imgurl).delete();

    await firebasefirestore
        .collection(constants.itemsTableName)
        .doc(id)
        .delete();
  }

  static Future<void> updateItem(
    String id,
    String name,
    String desc,
    double price,
    String catgory,
  ) async {
    await firebasefirestore
        .collection(constants.itemsTableName)
        .doc(id)
        .update({
      'name': name,
      'description': desc,
      'price': price,
      'category': catgory,
    });
    print("Item updated");
  }

  static Future<List<String>> getListOfCategory() async {
    List<String> mylist = [];
    // var index = 0;
    await firebasefirestore
        .collection(constants.categoryTableName)
        .where('mail', isEqualTo: constants.mail)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        // print(doc["name"]);
        // print(index++);
        // mylist[index++] = doc['name'];
        mylist.add(doc['name']);
      }
    }).catchError((e) {
      print(e.toString());
    });
    print(mylist);

    return mylist;
  }

  static Future<String> uloadImage(File img) async {
    String ids = DateTime.now().microsecondsSinceEpoch.toString();
    refff.Reference reff = refff.FirebaseStorage.instance
        .ref()
        .child("images")
        .child("item" + ids);
    await reff.putFile(img);
    return await reff.getDownloadURL();
  }

  static Future<String> getOrderdShopName(String docId) async {
    print(docId);
    String shopname = "";
    String shopDocId = "";
    await FirebaseFirestore.instance
        .collection(constants.masterOrderTableName)
        .doc(docId)
        .get()
        .then((value) {
      shopDocId = "${value['toshopdoc']}";
    });
    await FirebaseFirestore.instance
        .collection("shops")
        .doc(shopDocId)
        .get()
        .then((value) {
      shopname = "${value['name']}";
    });
    print(shopname + "   name");

    return shopname;
  }

  static Future<double> getSubTotal(String orderId) async {
    double subtotal = 0.0;
    await FirebaseFirestore.instance
        .collection(constants.masterOrderTableName)
        .doc(orderId)
        .get()
        .then((value) {
      subtotal = double.parse("${value['subtotal']}");
    });

    return subtotal;
  }

  static Future<String> getDeliverAddress(String orderId) async {
    String address = "";
    await FirebaseFirestore.instance
        .collection(constants.masterOrderTableName)
        .doc(orderId)
        .get()
        .then((value) {
      address = "Name: " +
          value['orderusername'] +
          "\n\n" +
          value['orderuseraddress'] +
          ",  " +
          value['orderuserlocation'];
    });

    return address;
  }

  static Future<void> setOrderComplete(String orderId) async {
    await FirebaseFirestore.instance
        .collection(constants.masterOrderTableName)
        .doc(orderId)
        .update({
      "ispendding": false,
    });
  }
}
