import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data_classes/chek_registration_is_complete.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  void displayMessage(String str) {
    Fluttertoast.showToast(
      msg: str,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.white,
      backgroundColor: Colors.grey,
    );
  }

  TextEditingController oldPasword = TextEditingController();

  TextEditingController newPasword = TextEditingController();
  TextEditingController confirmPasword = TextEditingController();
  bool _oldpasswordVisible = false;

  bool _passwordVisible = false;
  bool _cpasswordVisible = false;

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
          "Setting",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      //drawer: sdrawer(context),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: const Center(
                child: Text(
                  "Change Password",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
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
                controller: oldPasword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Old Password required';
                  }
                  return null;
                },
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                obscureText: !_oldpasswordVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: 'Old Password',
                  hintText: 'password',
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _oldpasswordVisible = !_oldpasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 25,
                bottom: 10,
              ),
              child: Divider(
                thickness: 1,
                // height: 20,
                color: Colors.grey,
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
                controller: newPasword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password required';
                  } else if (value.length < 6) {
                    return "Password is too week.";
                  }
                  return null;
                },
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: 'New Password',
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
                left: 15.0,
                right: 15.0,
                top: 15,
                bottom: 0,
              ),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: confirmPasword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password required';
                  } else if (value != newPasword.text) {
                    return "Password not match";
                  }
                  return null;
                },
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                obscureText: !_cpasswordVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: 'Confirm Password',
                  hintText: 'password',
                  suffixIcon: IconButton(
                    icon: Icon(_cpasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _cpasswordVisible = !_cpasswordVisible;
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    changePassword(oldPasword.text, newPasword.text);
                    showWaitingDialogue(context);
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
                    "Update",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
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

  Future<void> changePassword(String oldPass, String newPass) async {
    var isUpdate = await ShopRegistration.changePssword(oldPass, newPass);
    if (isUpdate == 1) {
      displayMessage("Password Updated");
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.pop(context);
    } else if (isUpdate == 2) {
      displayMessage("Old Password Not Correcct");
      Navigator.of(context, rootNavigator: true).pop('dialog');
    } else {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      displayMessage("Unable to Update");
    }
  }
}
