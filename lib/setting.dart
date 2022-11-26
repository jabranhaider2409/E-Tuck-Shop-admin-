import '../models/constants.dart';
import '../settings/change_password.dart';

import '../settings/shop.dart';

import '../settings/edit_account.dart';
import 'package:flutter/material.dart';

import '../data_classes/local_data_sever.dart';

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  bool _remem = constants.rmemberme;
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
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountSetting()));
                },
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Edit Account Details",
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(
                          Icons.edit,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePassword()));
                },
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Change Password",
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(
                          Icons.password,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 5, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Remember my Account",
                        style: TextStyle(fontSize: 18),
                      ),
                      Checkbox(
                        onChanged: (ischeck) {
                          if (constants.rmemberme) {
                            LocalDataSever.setRememberMe(false);

                            setconstant();
                            setState(() {
                              _remem = false;
                            });
                          } else {
                            LocalDataSever.setRememberMe(true);

                            setconstant();
                            setState(() {
                              _remem = true;
                            });
                          }
                        },
                        value: _remem,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  void setconstant() async {
    constants.rmemberme = (await LocalDataSever.getRememberMe())!;
  }
}
