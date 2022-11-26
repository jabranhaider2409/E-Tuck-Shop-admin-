import 'dart:io';

import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:location/location.dart';

import 'dashboard.dart';
import 'data_classes/chek_registration_is_complete.dart';
// import 'location_helper.dart';
// import '../data_classes/login_google_firebase_auth.dart';

class Registration extends StatefulWidget {
  Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool _passwordVisible = false;
  bool _cpasswordVisible = false;
  TextEditingController name = TextEditingController();
  TextEditingController shopName = TextEditingController();
  TextEditingController newPasword = TextEditingController();
  TextEditingController confirmPasword = TextEditingController();
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  final _formKey = GlobalKey<FormState>();
  displayMessage(String msge) {
    Fluttertoast.showToast(
      msg: msge,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.white,
      backgroundColor: Colors.grey,
    );
  }

  File? image;
  final picker = ImagePicker();
  Future pickImage(ImageSource src) async {
    final pick = await picker.pickImage(source: src);
    if (pick != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pick.path,
        // aspectRatioPresets: [
        //   CropAspectRatioPreset.square,
        //   CropAspectRatioPreset.original,
        // ],
        aspectRatio: const CropAspectRatio(ratioX: 1.7, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.orangeAccent,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
        // maxHeight: 300,
        // maxWidth: 300,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        cropStyle: CropStyle.rectangle,
      );
      setState(() {
        if (croppedFile != null) {
          image = File(croppedFile.path);
          displayMessage("img selected");
        }
      });
    }
  }
  // String? locationImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "Registration",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
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
                    hintText: 'Shahzad'),
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
                // top: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.orange),
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 180,
                // width: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: image == null
                          ? const Center(
                              child: Text("Shop image not selected."))
                          : Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ),
                    )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.30,
                  vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  // displayMessage("select img pressed");
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Image Picker'),
                      content: const Text("Select image from"),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            pickImage(ImageSource.gallery);
                            Navigator.of(context).pop();
                          },
                          child: const Text("Gellary"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            pickImage(ImageSource.camera);
                            Navigator.of(context).pop();
                          },
                          child: const Text("Camera"),
                        ),
                      ],
                    ),
                  );
                  // pickImage();
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Text(
                    "Select Image",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
                    if (countryValue == "🇵🇰    Pakistan") {
                      if (stateValue != "" && cityValue != "") {
                        if (image != null) {
                          showWaitingDialogue(context);
                          addShopData();
                        } else {
                          displayMessage("Select image");
                        }
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
                    "Register Shop",
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

  void addShopData() async {
    await ShopRegistration.addShopRegistration(
        shopName.text, name.text, newPasword.text, true, cityValue, image!);
    bool isCompleted = await ShopRegistration.isComplete();
    if (isCompleted) {
      //  go to dash board
      displayMessage("Registration Success");
      Navigator.of(context, rootNavigator: true).pop('dialog');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => dashBoard()),
      );
    } else {
      //  gog to complete registration screen
      Navigator.of(context, rootNavigator: true).pop('dialog');
      displayMessage("Something went wrong");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Registration()),
      );
    }
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
}
