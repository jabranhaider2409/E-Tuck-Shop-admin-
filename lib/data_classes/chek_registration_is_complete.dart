import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../data_classes/local_data_sever.dart';
import 'package:firebase_storage/firebase_storage.dart' as refff;
import 'firebase_connection.dart';
import '../models/constants.dart';

class ShopRegistration {
  //  check whether registration of shop is completed or not
  static Future<bool> isComplete() async {
    String docid = "";
    await firebasefirestore
        .collection(constants.shopsTableName)
        .where('mail', isEqualTo: constants.mail)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        // print(doc["name"]);
        // print(index++);
        // mylist[index++] = doc['name'];
        // mylist.add(doc['name']);
        docid = doc.id;
        // print("///////////////// " + doc.id + " //////////////////////");
      }
    }).catchError((e) {
      print(e.toString());
    });

    if (docid.length < 2) {
      return false;
    } else {
      return true;
    }
  }

  static Future<void> addShopRegistration(String shopName, String owner,
      String password, bool isactive, String cityValue, File image) async {
    String imgurl = await uloadImage(image);
    constants.deviceToken = (await FirebaseMessaging.instance.getToken())!;
    await firebasefirestore.collection(constants.shopsTableName).add({
      'name': shopName,
      'owner': owner,
      'mail': constants.mail,
      'password': password,
      'isActive': isactive,
      'shopStatus': true,
      'location': cityValue,
      'imageurl': imgurl,
      'usertoken': constants.deviceToken,
    }).then((value) {
      print("Shop registration successfull..");
      constants.shopId = value.id;
      LocalDataSever.setShopId(value.id);
      constants.shopName = shopName;
      constants.ownerName = owner;
      LocalDataSever.setShopName(shopName);
      LocalDataSever.setOwnerName(owner);
      print(value.id);
      // print(value.parent);
      // print(value.path);
    }).catchError((e) {
      print("its error ######" + e.toString());
    });
  }

  static Future<String> uloadImage(File img) async {
    String ids = DateTime.now().microsecondsSinceEpoch.toString();
    refff.Reference reff = refff.FirebaseStorage.instance
        .ref()
        .child("images")
        .child("shop" + ids);
    await reff.putFile(img);
    return await reff.getDownloadURL();
  }

  static Future<void> getShopData() async {
    await firebasefirestore
        .collection(constants.shopsTableName)
        .where('mail', isEqualTo: constants.mail)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        LocalDataSever.setOwnerName(doc['owner']);
        LocalDataSever.setShopName(doc['name']);
        LocalDataSever.setShopId(doc.id);
        constants.ownerName = doc['owner'];
        constants.shopName = doc['name'];
        constants.shopId = doc.id;
      }
    }).catchError((e) {
      print(e.toString());
    });

    try {
      constants.mail = (await LocalDataSever.getMail())!;
    } catch (e) {}
    try {
      constants.rmemberme = (await LocalDataSever.getRememberMe())!;
    } catch (e) {}
    try {
      constants.ownerName = (await LocalDataSever.getOwnerName())!;
      print("Owner Name ======= \n\n\n\n" + constants.ownerName);
    } catch (e) {
      print("erorr ============= " + e.toString());
    }
    try {
      constants.shopName = (await LocalDataSever.getShopName())!;
    } catch (e) {}
  }

  static Future<void> setShopStatusFirebase(bool val) async {
    await FirebaseFirestore.instance
        .collection(constants.shopsTableName)
        .doc(constants.shopId)
        .update({
      'shopStatus': val,
    }).then((value) => print("shop status update at firebase"));
  }

  static Future<bool> updateAccountDetails(
      String name, String shopName, String city) async {
    bool isUpdate = false;
    await FirebaseFirestore.instance
        .collection(constants.shopsTableName)
        .doc(constants.shopId)
        .update({
      'name': shopName,
      'owner': name,
      'location': city,
    }).whenComplete(() {
      isUpdate = true;
    });
    constants.ownerName = name;
    constants.shopName = shopName;
    await LocalDataSever.setOwnerName(name);
    await LocalDataSever.setShopName(shopName);
    return isUpdate;
  }

  static Future<int> changePssword(String oldpass, String newPass) async {
    print("change password at check registration");
    int isUpdate = 0;
    String FirebaseOldPassword = "";
    await FirebaseFirestore.instance
        .collection(constants.shopsTableName)
        .doc(constants.shopId)
        .get()
        .then((value) {
      FirebaseOldPassword = value['password'];
    });
    if (FirebaseOldPassword == oldpass) {
      await FirebaseFirestore.instance
          .collection(constants.shopsTableName)
          .doc(constants.shopId)
          .update({
        'password': newPass,
      }).whenComplete(() {
        isUpdate = 1;
      });
    } else {
      isUpdate = 2;
    }
    print(FirebaseOldPassword);

    return isUpdate;
  }

  static Future<String> getPassword() async {
    String pass = "";
    await FirebaseFirestore.instance
        .collection(constants.shopsTableName)
        .where('mail', isEqualTo: constants.mail)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        pass = doc["password"];
      }
    }).catchError((e) {
      print(e.toString());
    });
    return pass;
  }

  static Future<String> getPlaceOrderUserToken(String orderId) async {
    String token = "";
    String placeOrderUserMail = "";
    await FirebaseFirestore.instance
        .collection(constants.masterOrderTableName)
        .doc(orderId)
        .get()
        .then((value) {
      placeOrderUserMail = value["orderusermail"].toString();
    });

    await firebasefirestore
        .collection(constants.endUSerTableName)
        .where("mail", isEqualTo: placeOrderUserMail)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {

       token= doc['usertoken'].toString();
      }
    });

    return token;
  }
}
