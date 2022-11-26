import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSever {
  static String nameKey = "NAMEKEY";
  static String mailKey = "MAILKEY";
  static String imgKey = "IMGKEY";
  static String remeberMe = "RKEY";
  static String shopId = "SHOPID";
  static String shopName = "SHOPNAME";
  static String ownerName = "OWNERNAME";
  static String shopStatus = "SHOPSTATUS";

  static Future<bool> setName(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(nameKey, name);
  }

  static Future<bool> setMail(String mail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(mailKey, mail);
  }

  static Future<bool> setImg(String img) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(imgKey, img);
  }

  static Future<String?> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(nameKey);
  }

  static Future<String?> getMail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(mailKey);
  }

  static Future<String?> getImg() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(imgKey);
  }

  //  set outo login remeber me

  static Future<bool> setRememberMe(bool rem) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(remeberMe, rem);
  }

  static Future<bool?> getRememberMe() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(remeberMe);
  }

  static Future<bool> setShopId(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(shopId, id);
  }

  static Future<String?> getShopId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(shopId);
  }

  static Future<bool> setShopName(String sname) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(shopName, sname);
  }

  static Future<String?> getShopName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(shopName);
  }

  static Future<bool> setOwnerName(String owner) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(ownerName, owner);
  }

  static Future<String?> getOwnerName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(ownerName);
  }

  // shop status on off
  static Future<bool> setShopStatus(bool shopstatus) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(shopstatus);
    return await preferences.setBool(shopStatus, shopstatus);
  }

  static Future<bool?> getShopStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(shopStatus);
  }
}
