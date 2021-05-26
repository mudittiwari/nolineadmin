import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noline_admin/barbarhome.dart';

class showbookings extends StatefulWidget {
  final user;
  final String type;
  const showbookings(this.user, this.type);
  @override
  _showbookingsState createState() => _showbookingsState();
}

class _showbookingsState extends State<showbookings> {
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

  String active = "current";
  Future<QuerySnapshot> getactive() {
    print(widget.user["name"]);
    return Firestore.instance
        .collection("active_bookings")
        .where("sallon_name", isEqualTo: widget.user["name"].toString())
        .where('type', isEqualTo: true)
        .getDocuments();
  }

  Future<QuerySnapshot> getprev() {
    return Firestore.instance
        .collection("previous_bookings")
        .where("sallon_name", isEqualTo: widget.user["name"].toString())
        .where('type', isEqualTo: true)
        // .where('type', isEqualTo: 'parlour')
        .getDocuments();
  }

  Widget resultwidget() {
    if (active == "current") {
      return FutureBuilder(
        future: getactive(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(child: CircularProgressIndicator()),
            );
          else if (snapshot.hasError)
            return Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Center(
                child: Icon(Icons.error),
              ),
            );
          else {
            print(snapshot.data.documents.length);
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.data.documents
                                      .elementAt(index)["user_name"]
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "12 January 2021,Tuesday",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "11:30 AM - 01:00 PM",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Divider(
                                  thickness: 2.0,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, i) {
                                      print(snapshot.data.documents
                                          .elementAt(index)["services"]
                                          .keys
                                          .toList());
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "${i + 1}.  ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.grey,
                                                    fontSize: 17),
                                              ),
                                              Text(
                                                snapshot.data.documents
                                                    .elementAt(
                                                        index)["services"]
                                                    .keys
                                                    .toList()[i]
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.grey,
                                                    fontSize: 17),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            snapshot.data.documents
                                                    .elementAt(
                                                        index)["services"]
                                                    .values
                                                    .toList()[i]
                                                    .toString()
                                                    .toUpperCase() +
                                                " Rs",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.grey,
                                                fontSize: 17),
                                          ),
                                        ],
                                      );
                                    },
                                    itemCount: snapshot.data.documents
                                        .elementAt(index)["services"]
                                        .length,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Divider(
                                  thickness: 2.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "DISCOUNT: ",
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.grey,
                                            fontSize: 17),
                                      ),
                                    ),
                                    Text(
                                      snapshot.data.documents
                                              .elementAt(index)["discount"]
                                              .toString() +
                                          " Rs",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.grey,
                                          fontSize: 17),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "TOTAL FARE: ",
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.grey,
                                            fontSize: 17),
                                      ),
                                    ),
                                    Text(
                                      snapshot.data.documents
                                          .elementAt(index)["total_amount"]
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.grey,
                                          fontSize: 17),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data.documents.length,
                ),
              ),
            );
          }
        },
      );
    } else {
      return FutureBuilder(
        future: getprev(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(child: CircularProgressIndicator()),
            );
          else if (snapshot.hasError)
            return Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Center(
                child: Icon(Icons.error),
              ),
            );
          else {
            print(snapshot.data.documents.length);
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.data.documents
                                      .elementAt(index)["user_name"]
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "12 January 2021,Tuesday",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "11:30 AM - 01:00 PM",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Divider(
                                  thickness: 2.0,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, i) {
                                      print(snapshot.data.documents
                                          .elementAt(index)["services"]
                                          .keys
                                          .toList());
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "${i + 1}.  ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.grey,
                                                    fontSize: 17),
                                              ),
                                              Text(
                                                snapshot.data.documents
                                                    .elementAt(
                                                        index)["services"]
                                                    .keys
                                                    .toList()[i]
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.grey,
                                                    fontSize: 17),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            snapshot.data.documents
                                                    .elementAt(
                                                        index)["services"]
                                                    .values
                                                    .toList()[i]
                                                    .toString()
                                                    .toUpperCase() +
                                                " Rs",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.grey,
                                                fontSize: 17),
                                          ),
                                        ],
                                      );
                                    },
                                    itemCount: snapshot.data.documents
                                        .elementAt(index)["services"]
                                        .length,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Divider(
                                  thickness: 2.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "DISCOUNT: ",
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.grey,
                                            fontSize: 17),
                                      ),
                                    ),
                                    Text(
                                      snapshot.data.documents
                                              .elementAt(index)["discount"]
                                              .toString() +
                                          " Rs",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.grey,
                                          fontSize: 17),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "TOTAL FARE: ",
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.grey,
                                            fontSize: 17),
                                      ),
                                    ),
                                    Text(
                                      snapshot.data.documents
                                          .elementAt(index)["total_amount"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.grey,
                                          fontSize: 17),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data.documents.length,
                ),
              ),
            );
          }
        },
      );
    }
  }

  Color ucolor = Colors.green;
  Color ccolor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity > 0) {
          if (active != "current") {
            active = "current";
            ucolor = Colors.green;
            ccolor = Colors.black;
            setState(() {});
          }
        } else if (details.primaryVelocity < 0) {
          if (active != "passed") {
            active = "passed";
            ucolor = Colors.black;
            ccolor = Colors.green;
            setState(() {});
          }
        }
      },
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              active = "current";
                              ucolor = Colors.green;
                              ccolor = Colors.black;
                              setState(() {});
                            },
                            child: Text(
                              "UPCOMING",
                              style: TextStyle(
                                  color: ucolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: VerticalDivider(
                          color: Colors.black,
                          thickness: 1.2,
                        ),
                      ),
                      Expanded(
                          child: Center(
                        child: InkWell(
                          onTap: () {
                            active = "passed";
                            ucolor = Colors.black;
                            ccolor = Colors.green;
                            setState(() {});
                          },
                          child: Text(
                            "COMPLETED",
                            style: TextStyle(
                                color: ccolor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      )),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black)),
                  width: MediaQuery.of(context).size.width * .8,
                  height: 50,
                  // color: Colors.green,
                ),
              ),
              resultwidget(),
            ],
          ),
        ),
      )),
    );
  }
}
