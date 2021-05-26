import 'package:flutter/material.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:noline_admin/searchbooking.dart';
import 'package:noline_admin/searchparlour.dart';
import 'package:noline_admin/searchsallon.dart';
import 'package:noline_admin/searchunisex.dart';
import 'addparlour.dart';
import 'addwedding.dart';
import 'main.dart';
import 'addsallon.dart';
import 'addunisex.dart';

class admindashboard extends StatefulWidget {
  @override
  _admindashboardState createState() => _admindashboardState();
}

class _admindashboardState extends State<admindashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController name_ = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController number = new TextEditingController();
  TextEditingController about = new TextEditingController();
  showLoader(BuildContext context) {
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

  showLoaderDialog4(BuildContext context) {
    AlertDialog alert = AlertDialog(
        actions: [
          Container(
            margin: EdgeInsets.only(left: 7),
            child: FlatButton(
              onPressed: () async {
                showLoader(context);
                await Firestore.instance
                    .collection('ammen')
                    .getDocuments()
                    .then((value) {
                  var doc = value.documents.first;
                  Firestore.instance
                      .collection('ammen')
                      .document(doc.documentID)
                      .updateData({
                    "amen": FieldValue.arrayUnion([name_.text])
                  });
                });
                name_.text = "";
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("Create"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 7),
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
                name_.text = "";
                address.text = "";
                number.text = "";
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
                      controller: name_,
                      decoration:
                          InputDecoration(hintText: "Type name of service"),
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

  showLoaderDialog1(BuildContext context) {
    AlertDialog alert = AlertDialog(
        actions: [
          Container(
            margin: EdgeInsets.only(left: 7),
            child: FlatButton(
              onPressed: () {
                if (number.text.toString().length == 10) {
                  showLoader(context);
                  Firestore.instance.collection("/sallons").add({
                    "key": name_.text.trim().substring(0, 1).toUpperCase(),
                    "name": (name_.text.trim().substring(0, 1).toUpperCase() +
                        name_.text.trim().substring(1)),
                    "address": address.text.trim(),
                    "phone_number": number.text.trim(),
                    "recom": false,
                    "timeslots": {},
                    'blocked': false,
                    "about": about.text.toString().trim(),
                    "facilities": []
                  }).then((value) {
                    name_.text = "";
                    address.text = "";
                    number.text = "";
                    about.text = "";
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => addsallon(value.documentID),
                        ));
                  }).catchError((e) {
                    print(e);
                  });
                } else {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Invalid Phone Number"),
                    // duration: Duration(seconds: 2),
                  ));
                  Future.delayed(Duration(seconds: 2), () {
                    _scaffoldKey.currentState.removeCurrentSnackBar();
                  });
                }
              },
              child: Text("Create"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 7),
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
                name_.text = "";
                address.text = "";
                number.text = "";
              },
              child: Text("Cancel"),
            ),
          )
        ],
        content: SingleChildScrollView(
          child: new Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: TextField(
                      controller: name_,
                      decoration:
                          InputDecoration(hintText: "Type name of Sallon"),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: TextField(
                      controller: address,
                      decoration: InputDecoration(hintText: "Type address"),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: TextField(
                      controller: number,
                      decoration:
                          InputDecoration(hintText: "Type phone number"),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: TextField(
                      controller: about,
                      decoration: InputDecoration(hintText: "Type Description"),
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

  showLoaderDialog5(BuildContext context) {
    AlertDialog alert = AlertDialog(
        actions: [
          Container(
            margin: EdgeInsets.only(left: 7),
            child: FlatButton(
              onPressed: () {
                if (number.text.toString().length == 10) {
                  showLoader(context);
                  Firestore.instance
                      .collection('sallons')
                      .where('phone_number', isEqualTo: number.text.trim())
                      .getDocuments()
                      .then((value) {
                    if (value.documents.length != 0) {
                      Firestore.instance.collection("/weddings").add({
                        "key": value.documents.first["key"],
                        "name": value.documents.first["name"],
                        "address": value.documents.first["address"],
                        "phone_number": value.documents.first["phone_number"],
                        "recom": false,
                        "timeslots": value.documents.first["timeslots"],
                        'blocked': false,
                        'photos': value.documents.first["photos"],
                        'photo_url': value.documents.first["photo_url"],
                        "about": value.documents.first["about"],
                        "facilities": value.documents.first["facilities"],
                        "latitude": value.documents.first["latitude"],
                        "longitude": value.documents.first["longitude"],
                      }).then((v) {
                        number.text = "";
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => addwedding(v.documentID),
                            ));
                      }).catchError((e) {
                        print(e);
                      });
                    } else {
                      Firestore.instance
                          .collection('parlours')
                          .where('phone_number', isEqualTo: number.text.trim())
                          .getDocuments()
                          .then((value) {
                        if (value.documents.length != 0) {
                          Firestore.instance.collection("/weddings").add({
                            "key": value.documents.first["key"],
                            "name": value.documents.first["name"],
                            "address": value.documents.first["address"],
                            "phone_number":
                                value.documents.first["phone_number"],
                            "recom": false,
                            "timeslots": value.documents.first["timeslots"],
                            'blocked': false,
                            'photos': value.documents.first["photos"],
                            'photo_url': value.documents.first["photo_url"],
                            "about": value.documents.first["about"],
                            "facilities": value.documents.first["facilities"],
                            "latitude": value.documents.first["latitude"],
                            "longitude": value.documents.first["longitude"],
                          }).then((v) {
                            number.text = "";
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      addwedding(v.documentID),
                                ));
                          }).catchError((e) {
                            print(e);
                          });
                        } else {
                          Firestore.instance
                              .collection('unisex')
                              .where('number', isEqualTo: number.text.trim())
                              .getDocuments()
                              .then((value) {
                            if (value.documents.length != 0) {
                              Firestore.instance.collection("/weddings").add({
                                "key": value.documents.first["key"],
                                "name": value.documents.first["name"],
                                "address": value.documents.first["address"],
                                "phone_number":
                                    value.documents.first["phone_number"],
                                "recom": false,
                                "timeslots": value.documents.first["timeslots"],
                                'blocked': false,
                                'photos': value.documents.first["photos"],
                                'photo_url': value.documents.first["photo_url"],
                                "about": value.documents.first["about"],
                                "facilities":
                                    value.documents.first["facilities"],
                                "latitude": value.documents.first["latitude"],
                                "longitude": value.documents.first["longitude"],
                              }).then((v) {
                                number.text = "";
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          addwedding(v.documentID),
                                    ));
                              }).catchError((e) {
                                print(e);
                              });
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("phone number not found"),
                                // duration: Duration(seconds: 2),
                              ));
                              Future.delayed(Duration(seconds: 2), () {
                                _scaffoldKey.currentState
                                    .removeCurrentSnackBar();
                              });
                            }
                          });
                        }
                      });
                    }
                  });
                } else {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Invalid Phone Number"),
                    // duration: Duration(seconds: 2),
                  ));
                  Future.delayed(Duration(seconds: 2), () {
                    _scaffoldKey.currentState.removeCurrentSnackBar();
                  });
                }
              },
              child: Text("Create"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 7),
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
                name_.text = "";
                address.text = "";
                number.text = "";
              },
              child: Text("Cancel"),
            ),
          )
        ],
        content: SingleChildScrollView(
          child: new Container(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: TextField(
                      controller: number,
                      decoration:
                          InputDecoration(hintText: "Type phone number"),
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

  showLoaderDialog2(BuildContext context) {
    AlertDialog alert = AlertDialog(
        actions: [
          Container(
            margin: EdgeInsets.only(left: 7),
            child: FlatButton(
              onPressed: () {
                // print(number.text);
                // print(number.text.toString().length);
                if (number.text.toString().trim().length == 10) {
                  showLoader(context);
                  Firestore.instance.collection("/unisex").add({
                    "key": name_.text.trim().substring(0, 1).toUpperCase(),
                    "name": (name_.text.trim().substring(0, 1).toUpperCase() +
                        name_.text.trim().substring(1)),
                    "address": address.text.trim(),
                    "phone_number": number.text.trim(),
                    "recom": false,
                    'blocked': false,
                    "facilities": [],
                    "timeslots": {},
                    "about": about.text.toString().trim(),
                  }).then((value) {
                    name_.text = "";
                    address.text = "";
                    number.text = "";
                    about.text = "";
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => addunisex(value.documentID),
                        ));
                  }).catchError((e) {
                    print(e);
                  });
                } else {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Invalid Phone Number"),
                  ));
                  Future.delayed(Duration(seconds: 2), () {
                    _scaffoldKey.currentState.removeCurrentSnackBar();
                  });
                }
              },
              child: Text("Create"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 7),
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
                name_.text = "";
                address.text = "";
                number.text = "";
                about.text = "";
              },
              child: Text("Cancel"),
            ),
          )
        ],
        content: SingleChildScrollView(
          child: new Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: TextField(
                      controller: name_,
                      decoration:
                          InputDecoration(hintText: "Type name of unisex"),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: TextField(
                      controller: address,
                      decoration: InputDecoration(hintText: "Type address"),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: TextField(
                      controller: number,
                      decoration:
                          InputDecoration(hintText: "Type phone number"),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: TextField(
                      controller: about,
                      decoration: InputDecoration(hintText: "Type Description"),
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

  showLoaderDialog3(BuildContext context) {
    AlertDialog alert = AlertDialog(
        actions: [
          Container(
            margin: EdgeInsets.only(left: 7),
            child: FlatButton(
              onPressed: () {
                if (number.text.toString().length == 10) {
                  showLoader(context);
                  Firestore.instance.collection("/parlours").add({
                    "key": name_.text.trim().substring(0, 1).toUpperCase(),
                    "name": (name_.text.trim().substring(0, 1).toUpperCase() +
                        name_.text.trim().substring(1)),
                    "address": address.text.trim(),
                    "phone_number": number.text.trim(),
                    "recom": false,
                    'blocked': false,
                    "timeslots": {},
                    "facilities": [],
                    "about": about.text.toString().trim(),
                  }).then((value) {
                    name_.text = "";
                    address.text = "";
                    number.text = "";
                    about.text = "";
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => addparlour(value.documentID),
                        ));
                  }).catchError((e) {
                    print(e);
                  });
                } else {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Invalid Phone Number"),
                  ));
                  Future.delayed(Duration(seconds: 2), () {
                    _scaffoldKey.currentState.removeCurrentSnackBar();
                  });
                }
              },
              child: Text("Create"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 7),
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
                name_.text = "";
                address.text = "";
                number.text = "";
                about.text = "";
              },
              child: Text("Cancel"),
            ),
          )
        ],
        content: SingleChildScrollView(
          child: new Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: TextField(
                      controller: name_,
                      decoration:
                          InputDecoration(hintText: "Type name of parlour"),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: TextField(
                      controller: address,
                      decoration: InputDecoration(hintText: "Type address"),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: TextField(
                      controller: number,
                      decoration:
                          InputDecoration(hintText: "Type phone number"),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: TextField(
                      controller: about,
                      decoration: InputDecoration(hintText: "Type Description"),
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
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(content: Text("Press again to quit")),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image(image: AssetImage("assets/images/ffer.png"))),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Noline",
                      style: new TextStyle(
                          color: Colors.green,
                          fontSize: 78.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 10.0),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                          color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Add sallon",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              )
                            ],
                          ),
                          onPressed: () {
                            showLoaderDialog1(context);
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 10.0),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                          color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Add Parlor",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              )
                            ],
                          ),
                          onPressed: () {
                            showLoaderDialog3(context);
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 10.0),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                          color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Add unisex",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              )
                            ],
                          ),
                          onPressed: () {
                            showLoaderDialog2(context);
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 10.0),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                          color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Add wedding",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              )
                            ],
                          ),
                          onPressed: () {
                            showLoaderDialog5(context);
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 10.0),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                          color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Search Sallon",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => searchsallon(),
                                ));
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 10.0),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                          color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Search Unisex",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => searchunisex(),
                                ));
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 10.0),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                          color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Search Parlour",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => searchparlour(),
                                ));
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 10.0),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                          color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Search Booking",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            print("mudit");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => searchbooking(),
                                ));
                          },
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FlatButton(
                          child: Text(
                            "Add service",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.grey,
                          onPressed: () {
                            showLoaderDialog4(context);
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.grey,
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyHomePage(),
                                ));
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
