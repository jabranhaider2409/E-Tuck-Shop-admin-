import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../settings/forget_password.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../data_classes/chek_registration_is_complete.dart';
import '../registrarion.dart';
import '../data_classes/local_data_sever.dart';
import '../models/constants.dart';
import '../data_classes/login_google_firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../dashboard.dart';

// ignore: camel_case_types
class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

// ignore: camel_case_types
class _loginState extends State<login> {
  bool _passwordVisible = false;
  bool _remem = constants.rmemberme;
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  displayMessage(String msge) {
    Fluttertoast.showToast(
      msg: msge,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.white,
      backgroundColor: Colors.grey,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    if (constants.rmemberme) {
      emailText.text = constants.mail;
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.orange,
            // decoration: const BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage("assets/loginimg.png"),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Text(
                              "Log In",
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.only(
                      top: 30,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            controller: emailText,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              labelText: 'Email',
                              hintText: 'abc@gmail.com',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email required';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 15.0,
                            top: 15,
                            bottom: 0,
                          ),
                          //padding: EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            controller: passwordText,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password required';
                              }
                              return null;
                            },
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              labelText: 'Password',
                              hintText: 'password',
                              suffixIcon: IconButton(
                                icon: Icon(_passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 20,
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var connectivityResult =
                                    await (Connectivity().checkConnectivity());
                                if (connectivityResult ==
                                        ConnectivityResult.mobile ||
                                    connectivityResult ==
                                        ConnectivityResult.wifi) {
                                  showWaitingDialogue(context);
                                  loginCheck(emailText.text, passwordText.text,
                                      context);
                                } else {
                                  showNoInternetDialogue(context);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(top: 15, bottom: 15),
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        //
                        constants.mail.isEmpty
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "OR",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25))),
                                        child: SignInButton(
                                          Buttons.GoogleDark,
                                          shape: Border.all(
                                            color: Colors.orange,
                                            width: 1,
                                            style: BorderStyle.solid,
                                          ),
                                          // text: "Sign up with Google",
                                          onPressed: () {
                                            showWaitingDialogue(context);
                                            loginSaveOnlineAndOfflineData();
                                          },
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Checkbox(
                                          onChanged: (ischeck) {
                                            if (constants.rmemberme) {
                                              LocalDataSever.setRememberMe(
                                                  false);

                                              setconstant();
                                              setState(() {
                                                _remem = false;
                                              });
                                            } else {
                                              LocalDataSever.setRememberMe(
                                                  true);

                                              setconstant();
                                              setState(() {
                                                _remem = true;
                                              });
                                            }
                                          },
                                          value: _remem,
                                        ),
                                        const Text(
                                          "Remember me",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgetPassword()));
                                    },
                                    child: const Text(
                                      "Forget Password",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  void showWaitingDialogue(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      width: 30,
                    ),
                    Text("Please wait..."),
                  ],
                ),
              ),
            ));
  }

  loginSaveOnlineAndOfflineData() async {
    var user = await signInWithGoogle();
    print("/////////////////////////////////");
    if (user != null) {
      print("User Not Null//////////////////////");
      constants.name = (await LocalDataSever.getName())!;
      constants.mail = (await LocalDataSever.getMail())!;
      constants.img = (await LocalDataSever.getImg())!;
      bool isCompleted = await ShopRegistration.isComplete();
      Navigator.of(context, rootNavigator: true).pop('dialog');
      if (isCompleted) {
        //  go to dash board
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => dashBoard()),
        );
      } else {
        //  gog to complete registration screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Registration()),
        );
      }
    }
  }

  void setconstant() async {
    constants.rmemberme = (await LocalDataSever.getRememberMe())!;
    print("locally set remmber me = " + constants.rmemberme.toString());
  }

  void loginCheck(String email, String pass, BuildContext context) async {
    // constants.deviceToken = (await FirebaseMessaging.instance.getToken())!;
    bool isvalid = await ChekLogInUser(email, pass);
    if (isvalid) {
      bool isReg = await ShopRegistration.isComplete();

      if (isReg) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => dashBoard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Registration()),
        );
      }
    } else {
      print("Wrong usename or password..");
      // passwordText.clear();
      // passwordText.text = "wrong email or pass/Account expired.";
      displayMessage("Wrong username or password");
      Navigator.of(context, rootNavigator: true).pop('dialog');
      setState(() {
        _passwordVisible = true;
      });
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
}
