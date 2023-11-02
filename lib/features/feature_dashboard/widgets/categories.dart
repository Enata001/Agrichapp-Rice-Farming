import 'package:agrichapp/features/feature_videos/screens/videos_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

// import '../models/category.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late TextEditingController searchController;

  @override
  void initState() {
    // TODO: implement initState
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  final List<String> _categories = [
    'Harvesting',
    'Spraying',
    'Modern',
    'Machine'
  ];

  String result = "";
  final List<String> searchedList = [];

  final searchStyle = const InputDecoration(
    filled: true,
    fillColor: Colors.white,
    labelText: "Search",
    labelStyle: TextStyle(
      color: Colors.grey,
      fontSize: 14,
    ),
  );

  void search(String value) async {
    searchedList.clear();

    if (searchController.text.isEmpty) {
      setState(() {});
      return;
    }
    for (String element in _categories) {
      if (element.toLowerCase().contains(value.toLowerCase())) {
        searchedList.add(element);
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(
              vertical: MediaQuery.sizeOf(context).height * 0.05,
              horizontal: 30),
          child: TextField(
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            controller: searchController,
            decoration: searchStyle.copyWith(
              suffixIcon: IconButton(
                onPressed: () {
                  searchController.clear();
                  search(result);
                },
                icon: const Icon(Icons.search),
              ),
            ),
            onChanged: (value) {
              result = value;
              search(value);
              if (kDebugMode) {
                print(searchedList);
              }
            },
          ),
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.03,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          alignment: Alignment.center,
          child: Text(
            'Choose a Category',
            style: Theme.of(context).textTheme.titleLarge,
            textScaleFactor: 0.7,
          ),
        ),
        Container(
          height: MediaQuery.sizeOf(context).height * 0.5,
          margin: const EdgeInsets.only(
            top: 10,
          ),
          child: ((searchedList.isEmpty && searchController.text.isNotEmpty)
              ? const Center(
                  child: Text('No Results'),
                )
              : (searchController.text.isEmpty && searchedList.isEmpty)
                  ? ListView.builder(
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  blurStyle: BlurStyle.outer,
                                  color: Colors.grey.shade300,
                                )
                              ]),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    child: VideoScreen(
                                      title: _categories[index],
                                    ),
                                    type: PageTransitionType.size,
                                    alignment: Alignment.bottomRight),
                              );
                            },
                            child: Text(
                              _categories[index],
                              style: Theme.of(context).textTheme.labelMedium,
                              textScaleFactor: 0.8,
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: searchedList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  blurStyle: BlurStyle.outer,
                                  color: Colors.grey.shade300,
                                )
                              ]),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    child: VideoScreen(
                                      title: searchedList[index],
                                    ),
                                    type: PageTransitionType.size,
                                    alignment: Alignment.bottomRight),
                              );
                            },
                            child: Text(
                              searchedList[index],
                              style: Theme.of(context).textTheme.labelMedium,
                              textScaleFactor: 0.8,
                            ),
                          ),
                        );
                      },
                    )),
        )
      ],
    );
  }
}
