import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:noline_admin/parlourprofile.dart';
import 'package:noline_admin/profile.dart';
import 'package:noline_admin/showbookings.dart';
import 'package:noline_admin/showweddings.dart';
import 'package:noline_admin/statics.dart';
import 'package:noline_admin/timeslots.dart';
import 'package:noline_admin/unisexprofile.dart';

import 'cancelbookings.dart';

class barbarhome extends StatefulWidget {
  String type;
  final user;
  barbarhome(this.type, this.user);
  @override
  _barbarhomeState createState() => _barbarhomeState();
}

class _barbarhomeState extends State<barbarhome> {
  Future<bool> checkblock() async {
    var toreturn;
    await Firestore.instance
        .collection(widget.type)
        .where('name', isEqualTo: widget.user["name"])
        .getDocuments()
        .then((value) {
      if (value.documents.first["blocked"])
        toreturn = true;
      else
        toreturn = false;
    });
    return toreturn;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Image.asset(
                      "assets/images/aaaaa.png",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Container(
                child: InkWell(
                  onTap: () {
                    // print("mudit");
                    print(widget.type);
                    if (widget.type.toString() == "sallons") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => profile(
                                widget.user["name"], widget.user["photos"]),
                          ));
                    } else if (widget.type == "parlours") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => parlourprofile(
                                widget.user["name"], widget.user["photos"]),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => unisexprofile(
                                widget.user["name"], widget.user["photos"]),
                          ));
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                      image: AssetImage('assets/images/profile.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(50)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(
                    widget.user["name"].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              cancelbookings(widget.user["name"]),
                        ));
                  },
                  child: Container(
                    height: 40,
                    width: 220,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                        child: Text(
                      "Cancelled Bookings",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )),
                  ),
                ),
              ),
              Center(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => showbookings(
                                          widget.user, widget.type),
                                    ));
                              },
                              child: Container(
                                width: 150,
                                height: 150,
                                // color: Colors.grey[200],
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/—Pngtree—vector calendar icon_3782860.png"),
                                        height: 60,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Bookings",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18)),
                                    ),
                                    // Image(image: ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          timeslots(widget.type, widget.user),
                                    ));
                              },
                              child: Container(
                                width: 150,
                                height: 150,
                                // color: Colors.grey[200],
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/timetable.png"),
                                        height: 50,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, bottom: 8),
                                      child: Text(
                                        "Date & Time Slots",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    // Image(image: ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            statics(widget.user, widget.type),
                                      ));
                                },
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  // color: Colors.grey[200],
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image(
                                          image: AssetImage(
                                              "assets/images/—Pngtree—vector marketing statics icon_4190469.png"),
                                          height: 60,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Statics",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18)),
                                      ),
                                      // Image(image: ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => showweddings(
                                            widget.user, widget.type),
                                      ));
                                },
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  // color: Colors.grey[200],
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image(
                                          image: AssetImage(
                                              "assets/images/icon  weddo=ing.png"),
                                          height: 60,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Weddings",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18)),
                                      ),
                                      // Image(image: ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder(
                              future: checkblock(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  return Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 40,
                                        width: 180,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Center(
                                            child: Text(
                                          "Loading",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )),
                                      ),
                                    ),
                                  );
                                else if (snapshot.hasError) {
                                  return Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 40,
                                        width: 180,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Text(
                                          "ERROR",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  if (snapshot.data == true) {
                                    return Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: InkWell(
                                        onTap: () async {
                                          var id;
                                          showLoaderDialog(context);
                                          await Firestore.instance
                                              .collection(widget.type)
                                              .where('name',
                                                  isEqualTo:
                                                      widget.user["name"])
                                              .getDocuments()
                                              .then((value) {
                                            id = value
                                                .documents.first.documentID;
                                          });
                                          await Firestore.instance
                                              .collection(widget.type)
                                              .document(id)
                                              .updateData({
                                            "blocked": false,
                                          });
                                          await Firestore.instance
                                              .collection('weddings')
                                              .where('name',
                                                  isEqualTo:
                                                      widget.user["name"])
                                              .getDocuments()
                                              .then((value) async {
                                            if (value.documents.length != 0) {
                                              var id = value
                                                  .documents.first.documentID;
                                              await Firestore.instance
                                                  .collection('weddings')
                                                  .document(id)
                                                  .updateData(
                                                      {"blocked": false});
                                            }
                                          });
                                          // awa
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 180,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Center(
                                              child: Text(
                                            "Unblock",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          )),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: InkWell(
                                        onTap: () async {
                                          var id;
                                          showLoaderDialog(context);
                                          await Firestore.instance
                                              .collection(widget.type)
                                              .where('name',
                                                  isEqualTo:
                                                      widget.user["name"])
                                              .getDocuments()
                                              .then((value) {
                                            id = value
                                                .documents.first.documentID;
                                          });
                                          await Firestore.instance
                                              .collection(widget.type)
                                              .document(id)
                                              .updateData({
                                            "blocked": true,
                                          });
                                          await Firestore.instance
                                              .collection('weddings')
                                              .where('name',
                                                  isEqualTo:
                                                      widget.user["name"])
                                              .getDocuments()
                                              .then((value) async {
                                            if (value.documents.length != 0) {
                                              var id = value
                                                  .documents.first.documentID;
                                              await Firestore.instance
                                                  .collection('weddings')
                                                  .document(id)
                                                  .updateData(
                                                      {"blocked": true});
                                            }
                                          });
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 180,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Center(
                                              child: Text(
                                            "Block",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          )),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
