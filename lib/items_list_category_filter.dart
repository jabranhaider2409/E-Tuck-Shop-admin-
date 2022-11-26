import 'data_classes/item_firebase_services.dart';
import 'items_list.dart';
import 'package:flutter/material.dart';

import 'items_list_filtered.dart';

class ItemsListCategoryFilter extends StatefulWidget {
  ItemsListCategoryFilter({Key? key}) : super(key: key);

  @override
  State<ItemsListCategoryFilter> createState() =>
      _ItemListCategoryFilterState();
}

class _ItemListCategoryFilterState extends State<ItemsListCategoryFilter> {
  @override
  void initState() {
    super.initState();
    getdataforcategory();
  }

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
          "Filter Items",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      //drawer: sdrawer(context),
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 5,
            ),
            child: Card(
              color: Color.fromARGB(255, 63, 160, 95),
              elevation: 6,
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ItemsList()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Text(
                        "All Categories",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: Future.delayed(const Duration(seconds: 1)),
            builder: (c, s) => s.connectionState == ConnectionState.done
                ? Column(
                    children: <Widget>[
                      for (var it in listItem)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          child: Card(
                            color: const Color.fromARGB(255, 73, 155, 100),
                            elevation: 6,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ItemsListFiltered(fil: it)));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    child: Text(
                                      it,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
