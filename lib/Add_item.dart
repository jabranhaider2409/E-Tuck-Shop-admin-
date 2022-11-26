import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'data_classes/item_firebase_services.dart';

class AddItem extends StatefulWidget {
  AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  void initState() {
    super.initState();
    getdataforcategory();
  }

  final TextEditingController iname = TextEditingController();
  final TextEditingController idesc = TextEditingController();

  final TextEditingController iprice = TextEditingController();

  var _selectedLocation;
  List<String> listItem = [];
  void getdataforcategory() async {
    listItem = await ItemOperation.getListOfCategory();
    // listItem.add("Krakry");
  }

  displayMessage(String msge) {
    Fluttertoast.showToast(
      msg: msge,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.white,
      backgroundColor: Colors.grey,
    );
  }

  File? _image;
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
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
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
        maxHeight: 300,
        maxWidth: 300,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        cropStyle: CropStyle.rectangle,
      );
      setState(() {
        if (croppedFile != null) {
          _image = File(croppedFile.path);
          displayMessage("img selected");
        }
      });
    }
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
          "Add New Item",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 2)),
          builder: (c, s) => true
              ? listItem.isNotEmpty
                  ? ListView(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 14,
                            right: 14,
                            top: 20,
                            bottom: 10,
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.orange, width: 1)),
                            child: DropdownButton(
                              hint: const Text(
                                  'Select Categoty'), // Not necessary for Option 1
                              value: _selectedLocation,
                              onChanged: (newValue) {
                                print(newValue);
                                setState(() {
                                  _selectedLocation = newValue;
                                });
                              },
                              items: listItem.map((location) {
                                return DropdownMenuItem(
                                  child: Text(location),
                                  value: location,
                                );
                              }).toList(),
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              isExpanded: true,

                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: TextFormField(
                            // autofocus: true,
                            // enableInteractiveSelection: false,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
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
                        // TextField(),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 20,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.25),
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.orange),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 150,
                              width: 100,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: _image == null
                                        ? const Center(
                                            child: Text("No image selected."))
                                        : Image.file(
                                            _image!,
                                            fit: BoxFit.cover,
                                          ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.30,
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
                            top: 10,
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  _image != null) {
                                showWaitingDialogue(context);
                                await ItemOperation.addItem(
                                    iname.text,
                                    idesc.text,
                                    double.parse(iprice.text),
                                    _selectedLocation,
                                    _image!);
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                                iname.clear();
                                idesc.clear();
                                iprice.clear();
                                // _image = null;
                                displayMessage("Product Saved");
                                // Focus.of(context).unfocus();

                                setState(() {
                                  _image = null;
                                });
                                // addcat.clear();
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(content: Text("category Added")),
                                // );
                              } else if (_image == null) {
                                displayMessage("Select image");
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
                                "Add Item",
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
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    )
              : const Center(
                  child: CircularProgressIndicator(),
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
}
