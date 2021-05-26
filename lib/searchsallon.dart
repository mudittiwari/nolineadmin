import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noline_admin/widgets.dart';

class searchsallon extends StatefulWidget {
  @override
  _searchsallonState createState() => _searchsallonState();
}

class _searchsallonState extends State<searchsallon> {
  Widget searchone = Text("");
  // Widget searchtwo = Text("");
  var queryResultSet1 = [];
  // var queryResultSet2 = [];
  var tempSearchStore1 = [];
  // var tempSearchStore2 = [];
  searchbyname(String value) async {
    await Firestore.instance
        .collection('sallons')
        .where('key', isEqualTo: value.toUpperCase().toString())
        .getDocuments()
        .then((QuerySnapshot docs) {
      print(docs.documents.length);
      for (int i = 0; i < docs.documents.length; ++i) {
        queryResultSet1.add(docs.documents[i]);
        tempSearchStore1.add(docs.documents[i]);
      }
    });
  }

  initiateSearch(value) async {
    if (value.length == 0) {
      setState(() {
        searchone = Text("");
        queryResultSet1 = [];
        tempSearchStore1 = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet1.length == 0 && value.length == 1) {
      setState(() {
        searchone = Center(
          child: CircularProgressIndicator(),
        );
      });
      await searchbyname(value);
      setState(() {
        searchone = Container(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // print(tempSearchStore1[0]["photo_url"]);
              return searchressal(context, tempSearchStore1[index]);
            },
            itemCount: tempSearchStore1.length,
          ),
        );
      });
    } else {
      print(capitalizedValue);
      tempSearchStore1 = [];
      queryResultSet1.forEach((element) {
        if (element["name"].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore1.add(element);
          });
        }
        setState(() {
          searchone = Container(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                print(tempSearchStore1);
                return searchressal(context, tempSearchStore1[index]);
              },
              itemCount: tempSearchStore1.length,
            ),
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // toolbarHeight: 70,
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                // print(DateTime.now().month)
                initiateSearch(value);
              },
              decoration: InputDecoration(
                  hintText: "Search",
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [searchone],
          ),
        ));
  }
}
