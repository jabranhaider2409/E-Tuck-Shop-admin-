import 'package:country_state_city_picker/country_state_city_picker.dart';

import '../data_classes/chek_registration_is_complete.dart';
import '../models/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountSetting extends StatefulWidget {
  AccountSetting({Key? key}) : super(key: key);

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  TextEditingController name = TextEditingController();
  TextEditingController shopName = TextEditingController();

  void displayMessage(String str) {
    Fluttertoast.showToast(
      msg: str,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.white,
      backgroundColor: Colors.grey,
    );
  }

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.value = TextEditingValue(text: constants.ownerName);
    shopName.value = TextEditingValue(text: constants.shopName);
  }

  final _formKey = GlobalKey<FormState>();
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
                  "Account Details",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                initialValue: constants.mail,
                readOnly: true,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: 'E-mail',
                ),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                // initialValue: constants.name,
                controller: shopName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Shop Name required';
                  }
                  return null;
                },
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    labelText: 'Shop Name',
                    hintText: 'Zomato Mart'),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                controller: name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Owner Name required';
                  }
                  return null;
                },
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    labelText: 'Owner Name',
                    hintText: 'Jabran Haider'),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  SelectState(
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    onCountryChanged: (value) {
                      if (value == "🇵🇰    Pakistan") {
                        setState(() {
                          print(value.toString() + "Country name Selected");
                          countryValue = value;
                        });
                      }
                    },
                    onStateChanged: (value) {
                      setState(() {
                        stateValue = value;
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        cityValue = value;
                      });
                    },
                  ),
                ],
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
                    if (countryValue == "🇵🇰    Pakistan") {
                      if (stateValue != "" && cityValue != "") {
                        updateAccountData(name.text, shopName.text, cityValue);
                        showWaitingDialogue(context);
                      } else {
                        displayMessage("Select State and City");
                      }
                    } else {
                      displayMessage("Country must be Pakistan");
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

  Future<void> updateAccountData(
      String name, String shopeName, String cityval) async {
    bool isUpdate =
        await ShopRegistration.updateAccountDetails(name, shopeName, cityval);
    if (isUpdate) {
      displayMessage("Account Updated");
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.pop(context);
    } else {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      displayMessage("Unable to Update");
    }
  }
}
