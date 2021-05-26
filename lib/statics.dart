// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class statics extends StatefulWidget {
  String type;
  final user;
  statics(this.user, this.type);
  @override
  _staticsState createState() => _staticsState();
}

class _staticsState extends State<statics> {
  ValueNotifier<bool> val = ValueNotifier(true);
  String toshow = "MAR";
  bool _isChecked = false;
  bool _isChecked2 = false;
  bool _isChecked3 = true;
  bool _isChecked4 = false;
  Future<int> gettotal() async {
    var len = 0;
    await Firestore.instance
        .collection('active_bookings')
        .where('sallon_name', isEqualTo: widget.user['name'])
        .getDocuments()
        .then((value) {
      len += value.documents.length;
      print(len);
    });
    await Firestore.instance
        .collection('previous_bookings')
        .where('sallon_name', isEqualTo: widget.user["name"])
        .getDocuments()
        .then((value) {
      len += value.documents.length;
      print(len);
    });
    return len;
  }

  Future<int> totaldel() async {
    var len = 0;
    await Firestore.instance
        .collection('previous_bookings')
        .where('sallon_name', isEqualTo: widget.user["name"])
        .getDocuments()
        .then((value) {
      len += value.documents.length;
      print(len);
    });
    return len;
  }

  Future<double> gettotrev() async {
    double total = 0;
    await Firestore.instance
        .collection('previous_bookings')
        .where('sallon_name', isEqualTo: widget.user["name"])
        .getDocuments()
        .then((value) {
      for (var item in value.documents) {
        total += item["subtotal"];
      }
    });
    await Firestore.instance
        .collection('active_bookings')
        .where('sallon_name', isEqualTo: widget.user["name"])
        .getDocuments()
        .then((value) {
      for (var item in value.documents) {
        total += item["subtotal"];
      }
    });
    return total;
  }

  Future<int> gettotcan() async {
    var toreturn;
    await Firestore.instance
        .collection('cancelled_bookings')
        .where('sallon_name', isEqualTo: widget.user["name"])
        .getDocuments()
        .then((value) {
      toreturn = value.documents.length;
    });
    return toreturn;
  }

  Future<double> gettotdis() async {
    // print("Mudit");
    double total = 0;
    await Firestore.instance
        .collection('previous_bookings')
        .where('sallon_name', isEqualTo: widget.user["name"])
        .getDocuments()
        .then((value) {
      for (var item in value.documents) {
        // print("mudit");
        total += item["discount"];
        // print(item);
      }
    });
    await Firestore.instance
        .collection('active_bookings')
        .where('sallon_name', isEqualTo: widget.user["name"])
        .getDocuments()
        .then((value) {
      for (var item in value.documents) {
        print(item["discount"]);
        total = total + item["discount"];
        print("total is");
        print(total);
      }
    });
    return total;
  }

  Future<double> gettotcom() async {
    double total = 0;
    await Firestore.instance
        .collection('previous_bookings')
        .where('sallon_name', isEqualTo: widget.user["name"])
        .getDocuments()
        .then((value) {
      for (var item in value.documents) {
        total += item["commission"];
      }
    });
    await Firestore.instance
        .collection('active_bookings')
        .where('sallon_name', isEqualTo: widget.user["name"])
        .getDocuments()
        .then((value) {
      for (var item in value.documents) {
        total += item["commission"];
      }
    });
    return total;
  }

  Future<double> gettotear() async {
    double total = 0;
    await Firestore.instance
        .collection('previous_bookings')
        .where('sallon_name', isEqualTo: widget.user["name"])
        .getDocuments()
        .then((value) {
      for (var item in value.documents) {
        total += item["total"];
      }
    });
    await Firestore.instance
        .collection('active_bookings')
        .where('sallon_name', isEqualTo: widget.user["name"])
        .getDocuments()
        .then((value) {
      for (var item in value.documents) {
        total += item["total"];
      }
    });
    return total;
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

  showfilterDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(content: StatefulBuilder(
      builder: (context, setState) {
        return Container(
          height: 272,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: CheckboxListTile(
                  title: Text(
                    'December',
                    style: TextStyle(
                        color: Colors.blue[700], fontWeight: FontWeight.w500),
                  ),
                  // subtitle: const Text('160 Rs'),
                  value: _isChecked4,
                  checkColor: Colors.blue,
                  activeColor: Colors.white,
                  onChanged: (bool value) {
                    setState(() {
                      _isChecked4 = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: CheckboxListTile(
                  title: Text(
                    'January',
                    style: TextStyle(
                        color: Colors.blue[700], fontWeight: FontWeight.w500),
                  ),
                  // subtitle: const Text('160 Rs'),
                  value: _isChecked,
                  checkColor: Colors.blue,
                  activeColor: Colors.white,
                  onChanged: (bool value) {
                    setState(() {
                      _isChecked = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: CheckboxListTile(
                  title: Text(
                    'February',
                    style: TextStyle(
                        color: Colors.blue[700], fontWeight: FontWeight.w500),
                  ),
                  // subtitle: const Text('160 Rs'),
                  value: _isChecked2,
                  checkColor: Colors.blue,
                  activeColor: Colors.white,
                  onChanged: (bool value) {
                    setState(() {
                      _isChecked2 = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: CheckboxListTile(
                  title: Text(
                    'March',
                    style: TextStyle(
                        color: Colors.blue[700], fontWeight: FontWeight.w500),
                  ),
                  // subtitle: const Text('160 Rs'),
                  value: _isChecked3,
                  checkColor: Colors.blue,
                  activeColor: Colors.white,
                  onChanged: (bool value) {
                    setState(() {
                      _isChecked3 = value;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (val.value == true)
                        val.value = false;
                      else
                        val.value = true;
                    },
                    child: Text("Ok"),
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
        );
      },
    ));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String month = "March";
  Widget Bodywidget() {
    return ValueListenableBuilder(
      valueListenable: val,
      builder: (context, value, child) {
        if (_isChecked3) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _isChecked4 == true
                                ? Text("-December-",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))
                                : Text(" "),
                            _isChecked == true
                                ? Text("-January-",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))
                                : Text(" "),
                            _isChecked2 == true
                                ? Text("-February-",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))
                                : Text(" "),
                            _isChecked3 == true
                                ? Text("-March-",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))
                                : Text(" "),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Divider(
                            thickness: 2.0,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Services Booked:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            FutureBuilder(
                              future: gettotal(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  return Text("waiting",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Colors.grey));
                                else if (snapshot.hasError)
                                  return Text("ERROR",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: Colors.grey));
                                else {
                                  return Text(snapshot.data.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: Colors.grey));
                                }
                              },
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Services Delivered:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              FutureBuilder(
                                future: totaldel(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting)
                                    return Text("waiting",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: Colors.grey));
                                  else if (snapshot.hasError)
                                    return Text("ERROR",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: Colors.grey));
                                  else {
                                    return Text(snapshot.data.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: Colors.grey));
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Services Cancelled:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              FutureBuilder(
                                future: gettotcan(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting)
                                    return Text("waiting",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: Colors.grey));
                                  else if (snapshot.hasError)
                                    return Text("ERROR",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: Colors.grey));
                                  else {
                                    return Text(snapshot.data.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: Colors.grey));
                                  }
                                },
                              )
                              // Text("0",
                              //     style: TextStyle(
                              //         fontWeight: FontWeight.w500,
                              //         fontSize: 20,
                              //         color: Colors.grey))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Divider(
                            thickness: 2,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Revenue:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            FutureBuilder(
                              future: gettotrev(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  return Text("waiting",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          color: Colors.grey));
                                else if (snapshot.hasError)
                                  return Text("ERROR",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Colors.grey));
                                else {
                                  return Text(snapshot.data.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Colors.grey));
                                }
                              },
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Less Discount:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.grey),
                              ),
                              FutureBuilder(
                                future: gettotdis(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting)
                                    return Text("waiting",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            color: Colors.grey));
                                  else if (snapshot.hasError)
                                    return Text("ERROR",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Colors.grey));
                                  else {
                                    return Text(snapshot.data.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Colors.grey));
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Less Commission:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.grey),
                              ),
                              FutureBuilder(
                                future: gettotcom(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting)
                                    return Text("waiting",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            color: Colors.grey));
                                  else if (snapshot.hasError)
                                    return Text("ERROR",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Colors.grey));
                                  else {
                                    return Text(snapshot.data.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Colors.grey));
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Earning:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              FutureBuilder(
                                future: gettotear(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting)
                                    return Text("waiting",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            color: Colors.grey));
                                  else if (snapshot.hasError)
                                    return Text("ERROR",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Colors.grey));
                                  else {
                                    return Text(snapshot.data.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Colors.grey));
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Divider(
                            thickness: 2,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Commission:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            FutureBuilder(
                              future: gettotcom(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  return Text("waiting",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          color: Colors.grey));
                                else if (snapshot.hasError)
                                  return Text("ERROR",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: Colors.grey));
                                else {
                                  return Text(snapshot.data.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: Colors.grey));
                                }
                              },
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Divider(
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  _isChecked4 == true
                      ? Text("-December-",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))
                      : Text(" "),
                  _isChecked == true
                      ? Text("-January-",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))
                      : Text(" "),
                  _isChecked2 == true
                      ? Text("-February-",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))
                      : Text(" "),
                  _isChecked3 == true
                      ? Text("-March-",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))
                      : Text(" "),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "NO DATA",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Statics"),
      ),
      body: Bodywidget(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.,
      floatingActionButton: Builder(
        builder: (context) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                showfilterDialog(context);
              },
              child: Container(
                height: 40,
                width: 100,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sort,
                        size: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Filter",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
