import 'package:flutter/material.dart';

class ShopSetting extends StatefulWidget {
  ShopSetting({Key? key}) : super(key: key);

  @override
  State<ShopSetting> createState() => _ShopSettingState();
}

class _ShopSettingState extends State<ShopSetting> {
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
          "Shop",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      //drawer: sdrawer(context),
      body: ListView(children: <Widget>[]),
    );
  }
}
