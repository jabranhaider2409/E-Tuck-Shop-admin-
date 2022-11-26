import 'package:flutter/material.dart';
import 'data_classes/category_firebase_services.dart';
import 'data_classes/item_firebase_services.dart';

class ManageCategory extends StatefulWidget {
  ManageCategory({Key? key}) : super(key: key);

  @override
  State<ManageCategory> createState() => _ManageCategoryState();
}

class _ManageCategoryState extends State<ManageCategory> {
  final TextEditingController addcat = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getdataforcategory();
  }

  var _selectedLocation;
  List<String> listItem = [];
  void getdataforcategory() async {
    listItem = await ItemOperation.getListOfCategory();
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
          "Manage Category",
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
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            //   child: Text(
            //     "Add New Category",
            //     style: TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                controller: addcat,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: 'Category Name',
                  hintText: 'Fruits/Groscery',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter category name';
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
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    CategoryFirebaseServices.addCategory(addcat.text);
                    addcat.clear();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ManageCategory()));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("category Added")),
                    );
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
                    "Add Category",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Divider(
                thickness: 0.9,
                indent: 40,
                endIndent: 40,
                height: 20,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        "Note:",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "Select category for delete. When you delete category, all items that exsist under selected category will be deleted.",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  )),
            ),
            FutureBuilder(
              future: Future.delayed(const Duration(seconds: 1)),
              builder: (c, s) => s.connectionState == ConnectionState.done
                  ? listItem.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 14,
                                right: 14,
                                top: 20,
                                bottom: 10,
                              ),
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.orange, width: 1)),
                                child: DropdownButton(
                                  hint: const Text(
                                      'Select Categoty'), // Not necessary for Option 1
                                  value: _selectedLocation,
                                  onChanged: (newValue) {
                                    // print(newValue);
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
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 20,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  CategoryFirebaseServices.deleteCategory(
                                      _selectedLocation);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ManageCategory()));
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
                                    "Delete Category",
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
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Please make sure your internet connection is stable.\n OR \n No category exsist",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 149, 155, 165)),
                            ),
                          ),
                        )
                  : const Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 25),
                          child: CircularProgressIndicator()),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
