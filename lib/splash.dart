import '/data_classes/chek_registration_is_complete.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import '/data_classes/local_data_sever.dart';
import '/models/constants.dart';
import 'package:page_transition/page_transition.dart';
// import '/registrarion.dart';
import 'package:flutter/material.dart';
import 'login.dart';

// ignore: camel_case_types
class splash extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  splash({Key? key}) : super(key: key);

  @override
  _splashState createState() => _splashState();
}

// ignore: camel_case_types
class _splashState extends State<splash> {
  @override
  void initState() {
    super.initState();
    setgetRememberme();
  }

  setgetRememberme() async {
    // LocalDataSever.setRememberMe(false);
    try {
      constants.mail = (await LocalDataSever.getMail())!;
    } catch (e) {}
    try {
      constants.shopId = (await LocalDataSever.getShopId())!;
    } catch (e) {}
    try {
      constants.rmemberme = (await LocalDataSever.getRememberMe())!;
    } catch (e) {}
    try {
      constants.ownerName = (await LocalDataSever.getOwnerName())!;
    } catch (e) {}
    try {
      constants.shopName = (await LocalDataSever.getShopName())!;
    } catch (e) {}
    try {
      constants.shopStatus = (await LocalDataSever.getShopStatus())!;
    } catch (e) {}
    if (constants.ownerName.isEmpty ||
        constants.shopName.isEmpty ||
        constants.shopId.isEmpty) {
      await ShopRegistration.getShopData();
    }
    // Timer(const Duration(seconds: 4), () {
    //   print("Navigating \n\n\n\n");
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => const login()));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/applogo.png',
            height: 100,
            width: 100,
          ),
          const Text(
            "Do Pack",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const CircularProgressIndicator(
            color: Colors.red,
          )
        ],
      ),
      nextScreen: const login(),
      duration: 3000,
      splashIconSize: 250,
      backgroundColor: const Color.fromARGB(255, 175, 112, 30),
      splashTransition: SplashTransition.sizeTransition,
      pageTransitionType: PageTransitionType.rightToLeftWithFade,
      animationDuration: const Duration(seconds: 1),
    );
  }
}
