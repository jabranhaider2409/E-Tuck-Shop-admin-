import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_pack/models/constants.dart';

import 'firebase_connection.dart';

class CategoryFirebaseServices {
  static Future<int> addCategory(String name) async {
    firebasefirestore
        .collection(constants.categoryTableName)
        .add({'name': name, 'mail': constants.mail}).then((value) {
      print("category added");
      return 1;
    }).catchError((e) {
      print(e.toString());
      return 0;
    });
    return 1;
  }

  static Future<void> deleteCategory(String cat) async {
    String docid = "";
    // var index = 0;
    await firebasefirestore
        .collection(constants.categoryTableName)
        .where('name', isEqualTo: cat)
        .where('mail', isEqualTo: constants.mail)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        // print(doc["name"]);
        // print(index++);
        // mylist[index++] = doc['name'];
        // mylist.add(doc['name']);
        docid = doc.id;
        // print(doc.id);
      }
    }).catchError((e) {
      print(e.toString());
    });
    await firebasefirestore
        .collection(constants.categoryTableName)
        .doc(docid)
        .delete();
// delete items contain category
    List<String> mylist = [];
    await firebasefirestore
        .collection(constants.itemsTableName)
        .where('category', isEqualTo: cat)
        .where('mail', isEqualTo: constants.mail)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        mylist.add(doc.id);
        // docid = doc.id;
        // print(doc.id);
      }
    }).catchError((e) {
      print(e.toString());
    });

    // print(mylist);

    for (var did in mylist) {
      await firebasefirestore
          .collection(constants.itemsTableName)
          .doc(did)
          .delete();
      print(did + " item deleted");
    }
  }
}
