import 'package:do_pack/data_classes/chek_registration_is_complete.dart';
import 'package:do_pack/models/constants.dart';
import 'package:do_pack/registrarion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data_classes/login_google_firebase_auth.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  displayMessage(String msge) {
    Fluttertoast.showToast(
      msg: msge,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.white,
      backgroundColor: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 25,
        ),
        //centerTitle: true,
        title: const Text(
          "Forget Password",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(children: <Widget>[
        SizedBox(
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Log in with Google Account then you will be able to reset your password.",
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 175, 174, 174),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: SignInButton(
                Buttons.GoogleDark,
                shape: Border.all(
                  color: Colors.orange,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                elevation: 6,
                text: "Confirm Account",
                onPressed: () {
                  CheckUserForgetPassword();
                },
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  CheckUserForgetPassword() async {
    var user = await signInWithGoogleForForgettPassword();
    // print("/////////////////////////////////");
    if (user != null) {
      if (user.email.toString() == constants.mail) {
        String pass = await ShopRegistration.getPassword();
        if (pass.trim() == "") {
          displayMessage("Registration incomplete");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Registration()));
        } else {
          showDialog(
              context: context,
              builder: (_) => Dialog(
                    backgroundColor: Colors.orange,
                    child: Container(
                        alignment: FractionalOffset.center,
                        height: 120.0,
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Text(
                              "Your Account Password",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  '" ' + pass + ' "',
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ))
                          ],
                        )),
                  ));
        }
      } else {
        displayMessage("E-Mail not match");
      }
    } else {
      displayMessage("Unable Login");
    }
  }
}
