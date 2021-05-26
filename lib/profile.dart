import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:async/async.dart';
import 'package:noline_admin/barbarhome.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:noline_admin/editsallon.dart';

class profile extends StatefulWidget {
  final name;
  var ls;
  profile(this.name, this.ls);
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  TextEditingController name_ = TextEditingController();
  TextEditingController price_ = TextEditingController();
  TextEditingController time_ = TextEditingController();
  final AsyncMemoizer _memoizer1 = AsyncMemoizer<QuerySnapshot>();
  final AsyncMemoizer _memoizer2 = AsyncMemoizer<QuerySnapshot>();
  final AsyncMemoizer _memoizer3 = AsyncMemoizer<QuerySnapshot>();
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<QuerySnapshot> getdoc2() {
    return Firestore.instance
        .collection('sallons')
        .where('name', isEqualTo: widget.name.toString())
        .getDocuments();
  }

  Future<List> getdoc3() async {
    var ls;
    await Firestore.instance
        .collection('sallons')
        .where('name', isEqualTo: widget.name.toString())
        .getDocuments()
        .then((value) {
      ls = value.documents.first["facilities"];
    });
    return ls;
  }

  Future<QuerySnapshot> getsalon() {
    return Firestore.instance
        .collection('sallons')
        .where('name', isEqualTo: widget.name.toString())
        .getDocuments();
  }

  Future<bool> checkrecom() async {
    var toreturn;
    await Firestore.instance
        .collection('sallons')
        .where('name', isEqualTo: widget.name)
        .getDocuments()
        .then((value) {
      if (value.documents.first["recom"] == true)
        toreturn = true;
      else
        toreturn = false;
    });
    return toreturn;
  }

  TextEditingController price = new TextEditingController();
  showLoaderDialog4(BuildContext context, String name) {
    AlertDialog alert = AlertDialog(
        actions: [
          Container(
            margin: EdgeInsets.only(left: 7),
            child: FlatButton(
              onPressed: () async {
                print("mudit");
                var id;
                var doc;
                showLoaderDialog(context);
                await Firestore.instance
                    .collection('sallons')
                    .where('name', isEqualTo: widget.name)
                    .getDocuments()
                    .then((value) {
                  doc = value.documents.first;
                  id = value.documents.first.documentID;
                });
                print(name);
                await Firestore.instance
                    .collection('sallons')
                    .document(id)
                    .updateData({
                  name: price.text,
                });
                price.text = "";
                await Firestore.instance
                    .collection('sallons')
                    .where('name', isEqualTo: widget.name)
                    .getDocuments()
                    .then((value) {
                  doc = value.documents.first;
                  // id = value.documents.first.documentID;
                });
                Map ls = doc.data.map((key, value) {
                  return MapEntry(key, value);
                });
                ls.remove("name");
                ls.remove("photo_url");
                ls.remove("key");
                ls.remove("address");
                ls.remove("phone_number");
                ls.remove("recom");
                ls.remove("photos");
                ls.remove("about");
                ls.remove("min");
                ls.remove("timeslots");
                ls.remove("facilities");
                ls.remove("time_list");
                ls.remove("blocked");
                ls.remove("latitude");
                ls.remove("longitude");
                List temp = new List();
                for (var item in ls.values.toList()) {
                  temp.add(int.parse(item));
                }
                await Firestore.instance
                    .collection('sallons')
                    .document(id)
                    .updateData({
                  "min": temp.reduce(
                      (current, next) => current < next ? current : next),
                });
                print("tometo");
                Navigator.pop(context);
                Navigator.pop(context);
                setState(() {});
              },
              child: Text("Update"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 7),
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
                price.text = "";
                // address.text = "";
                // number.text = "";
              },
              child: Text("Cancel"),
            ),
          )
        ],
        content: SingleChildScrollView(
          child: new Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: TextField(
                      controller: price,
                      decoration: InputDecoration(
                          hintText: "Type new price of service"),
                    )),
              ],
            ),
          ),
        ));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          expandedHeight: 250,
          centerTitle: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Swiper(
              itemCount: widget.ls.length,
              itemBuilder: (context, index) => Image.network(
                widget.ls[index],
                fit: BoxFit.cover,
              ),
              autoplay: true,
              pagination: SwiperPagination(
                alignment: Alignment.bottomCenter,
                builder: new DotSwiperPaginationBuilder(
                    color: Colors.white, activeColor: Color(0xffFFBA9D)),
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    FutureBuilder(
                      future: getsalon(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        else if (snapshot.hasError)
                          return Icon(Icons.error);
                        else {
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.name.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        snapshot.data.documents.first["address"]
                                            .toString(),
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          launch(
                                              "https://www.google.com/maps/search/?api=1&query=${snapshot.data.documents.first["latitude"]},${snapshot.data.documents.first["longitude"]}");
                                        },
                                        child: Icon(Icons.location_on),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    snapshot.data.documents.first["about"],
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Ammenities:",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    FutureBuilder(
                      future: getdoc3(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        else if (snapshot.hasError)
                          return Icon(Icons.error);
                        else {
                          return Container(
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data[index],
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Services:",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    FutureBuilder(
                      future: getdoc2(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        else if (snapshot.hasError)
                          return Icon(Icons.error);
                        else {
                          Map ls = snapshot.data.documents
                              .elementAt(0)
                              .data
                              .map((key, value) {
                            return MapEntry(key, value);
                          });
                          ls.remove("name");
                          ls.remove("photo_url");
                          ls.remove("key");
                          ls.remove("address");
                          ls.remove("phone_number");
                          ls.remove("recom");
                          ls.remove("photos");
                          ls.remove("about");
                          ls.remove("min");
                          ls.remove("timeslots");
                          ls.remove("blocked");
                          ls.remove("time_list");
                          ls.remove("facilities");
                          ls.remove("latitude");
                          ls.remove("longitude");
                          List keys = ls.keys.toList();
                          // print(ls);
                          return Container(
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: ls.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        keys[index],
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              ls[keys[index]],
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: InkWell(
                                                child: Icon(Icons.edit),
                                                onTap: () {
                                                  showLoaderDialog4(
                                                      context, keys[index]);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            padding: EdgeInsets.all(18),
                            color: Colors.red,
                            onPressed: () async {
                              showLoaderDialog(context);
                              Firestore.instance
                                  .collection('sallons')
                                  .where('name', isEqualTo: widget.name)
                                  .getDocuments()
                                  .then((value) {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => editsallon(
                                          value.documents.first.documentID),
                                    ));
                              });
                            },
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ])))
        ]))
      ]),
      floatingActionButton: Builder(
        builder: (context) {
          return FutureBuilder(
            future: checkrecom(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () async {},
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(25)),
                        height: 50,
                        width: MediaQuery.of(context).size.width * .5,
                        child: Center(
                            child: Text(
                          "Loading",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () async {},
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(25)),
                        height: 50,
                        width: MediaQuery.of(context).size.width * .5,
                        child: Center(
                            child: Text(
                          "ERROR",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                      ),
                    ),
                  ),
                );
              } else {
                if (snapshot.data == true) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () async {
                          var id;
                          showLoaderDialog(context);
                          await Firestore.instance
                              .collection('sallons')
                              .where('name', isEqualTo: widget.name)
                              .getDocuments()
                              .then((value) {
                            id = value.documents.first.documentID;
                          });
                          await Firestore.instance
                              .collection('sallons')
                              .document(id)
                              .updateData({
                            "recom": false,
                          });
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(25)),
                          height: 50,
                          width: MediaQuery.of(context).size.width * .9,
                          child: Center(
                              child: Text(
                            "Remove from recommended",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () async {
                          var id;
                          showLoaderDialog(context);
                          await Firestore.instance
                              .collection('sallons')
                              .where('name', isEqualTo: widget.name)
                              .getDocuments()
                              .then((value) {
                            id = value.documents.first.documentID;
                          });
                          await Firestore.instance
                              .collection('sallons')
                              .document(id)
                              .updateData({
                            "recom": true,
                          });
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(25)),
                          height: 50,
                          width: MediaQuery.of(context).size.width * .9,
                          child: Center(
                              child: Text(
                            "Add to recommended",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                        ),
                      ),
                    ),
                  );
                }
              }
            },
          );
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
