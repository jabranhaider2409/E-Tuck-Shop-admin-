import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'data_classes/item_firebase_services.dart';

class EditItem extends StatefulWidget {
  String? id;
  String? name;
  String? cateory;
  String? price;
  String? desc;
  String? imgurl;
  EditItem(
      {Key? key,
      this.id,
      this.name,
      this.cateory,
      this.desc,
      this.price,
      this.imgurl})
      : super(key: key);
  @override
  State<EditItem> createState() => _EditItemState(
      id: id,
      cateory: cateory,
      price: price,
      name: name,
      desc: desc,
      imgurl: imgurl);
}

class _EditItemState extends State<EditItem> {
  String? id;
  String? name;
  String? cateory;
  String? price;
  String? desc;
  String? imgurl;
  _EditItemState(
      {this.id, this.name, this.cateory, this.desc, this.price, this.imgurl});

  String j = "ds";
  TextEditingController iname = TextEditingController();
  TextEditingController idesc = TextEditingController();
  TextEditingController icat = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController iprice = TextEditingController();

  @override
  void initState() {
    super.initState();
    iname.text = name!;
    idesc.text = desc!;
    icat.text = cateory!;
    iprice.text = price!;
  }

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
          "Edit Item",
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
            const SizedBox(
              height: 50,
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                // initialValue: cateory,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                controller: icat,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: 'Item Ctegory',
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description required';
                  } else {
                    final len = value.length;
                    print(len.toString());
                    if (len > 20) return 'To long Discription';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                // initialValue: name,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                controller: iname,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: 'Item Name',
                  hintText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name required';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                // initialValue: desc,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                controller: idesc,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: 'Item Description',
                  hintText: 'eg Size/Quantity',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description required';
                  } else {
                    final len = value.length;
                    print(len.toString());
                    if (len > 30) return 'To long Discription';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                // initialValue: price,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                keyboardType: TextInputType.number,
                controller: iprice,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: 'Item price',
                  hintText: 'eg 200',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price required';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.25),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.orange),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 150,
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          '$imgurl',
                          fit: BoxFit.cover,
                        ),
                      )),
                    ],
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
                    showWaitingDialogue(context);
                    updateItem();

                    // addcat.clear();
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text("category Added")),
                    // );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal[500],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Text(
                    "Update Item",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
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

  void updateItem() async {
    await ItemOperation.updateItem(
      id!,
      iname.text,
      idesc.text,
      double.parse(iprice.text),
      icat.text,
    );
    Navigator.of(context, rootNavigator: true).pop('dialog');
    iname.clear();
    idesc.clear();
    iprice.clear();
    icat.clear();
    displayMessage("Item Updated");
    Navigator.pop(context);
  }
}
