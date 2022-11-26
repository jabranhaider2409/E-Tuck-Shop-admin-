import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import '../data_classes/firebase_connection.dart';
import '../models/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'local_data_sever.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<User?> signInWithGoogle() async {
  print("Sing In Button clicked");
  try {
    final GoogleSignInAccount? googleSignInAcoount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAcoount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    final userCredential = await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    // all below is for checking
    assert(!user!.isAnonymous);
    assert(await user!.getIdToken() != null);
    final User? curruntUser = await _auth.currentUser;
    assert(curruntUser!.uid == user!.uid);
    print(user);

    LocalDataSever.setName(user!.displayName.toString());
    LocalDataSever.setMail(user.email.toString());
    LocalDataSever.setImg(user.photoURL.toString());
    constants.mail = user.email.toString();
    constants.name = user.displayName.toString();
    constants.mail = user.email.toString();
    // try {
    //   String sid = (await LocalDataSever.getShopId())!;
    //   print("Going to active account = " + sid);
    //   await firebasefirestore
    //       .collection(constants.shopsTableName)
    //       .doc(sid)
    //       .update({'isActive': true});
    // } catch (e) {
    //   print("Acount not found" + e.toString());
    // }

    return user;
  } on FirebaseException catch (e) {
    print("Error ================" + e.toString());
    throw e;
  } on GoogleSignIn catch (e) {
    print("Error ================" + e.toString());
    throw e;
  }
}

Future<bool> signOut() async {
  try {
    // String shopId = (await LocalDataSever.getShopId())!;
    // print("shop id == " + shopId);

    //await deActivateAcount(shopId);

    // await LocalDataSever.setName("");
    // await LocalDataSever.setMail("");
    // await LocalDataSever.setImg("");
    // constants.name = "";
    // constants.mail = "";
    // constants.img = "";

    // await googleSignIn.signOut();
    // await _auth.signOut();

    print("Accounts are Sign Out...");
    return true;
  } catch (e) {
    print("Eroor sign out /////////// " + e.toString());
    return false;
  }
}

deActivateAcount(String shopId) async {
  await firebasefirestore
      .collection(constants.shopsTableName)
      .doc(shopId)
      .update({"isActive": false}).then((value) {
    print("Account Deactivated ... ID = " + shopId.toString());
  });
}

Future<bool> ChekLogInUser(String email, String password) async {
  bool isValid = false;
  constants.deviceToken = (await FirebaseMessaging.instance.getToken())!;
  await firebasefirestore
      .collection(constants.shopsTableName)
      .where('mail', isEqualTo: email)
      .where("password", isEqualTo: password)
      .where("isActive", isEqualTo: true)
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      constants.shopName = doc["name"];
      LocalDataSever.setShopName(doc["name"]);
      constants.ownerName = doc['owner'];
      LocalDataSever.setOwnerName(doc['owner']);
      constants.mail = doc['mail'];
      LocalDataSever.setMail(doc['mail']);
      // print(index++);
      // mylist[index++] = doc['name'];
      // mylist.add(doc['name']);
      // docid = doc.id;
      // print("shop id :" + doc.id);
      constants.shopId = doc.id;
      LocalDataSever.setShopId(doc.id);
      if (doc.id.isNotEmpty) {
        isValid = true;
      } else {
        isValid = false;
      }
    }
  }).catchError((e) {
    print(e.toString());
  });
  print(constants.shopId);
  return isValid;
}

Future<User?> signInWithGoogleForForgettPassword() async {
  print("Sing In Button clicked");
  try {
    final GoogleSignInAccount? googleSignInAcoount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAcoount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    final userCredential = await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    // all below is for checking
    assert(!user!.isAnonymous);
    assert(await user!.getIdToken() != null);
    final User? curruntUser = await _auth.currentUser;
    assert(curruntUser!.uid == user!.uid);
    print(user);

    return user;
  } on FirebaseException catch (e) {
    print("Error ================" + e.toString());
    throw e;
  } on GoogleSignIn catch (e) {
    print("Error ================" + e.toString());
    throw e;
  }
}
