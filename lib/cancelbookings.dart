import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class cancelbookings extends StatefulWidget {
  final name;
  const cancelbookings(this.name);
  @override
  _cancelbookingsState createState() => _cancelbookingsState();
}

class _cancelbookingsState extends State<cancelbookings> {
  Future<QuerySnapshot> getcan() {
    return Firestore.instance
        .collection('cancelled_bookings')
        .where('sallon_name', isEqualTo: widget.name)
        .getDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text("Cancelled Bookings", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        // elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: getcan(),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Container(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, i) {
                                            print(snapshot.data.documents
                                                .elementAt(index)["services"]
                                                .keys
                                                .toList());
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${i + 1}.  ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
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
                                                          fontWeight:
                                                              FontWeight.w800,
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
                                                      fontWeight:
                                                          FontWeight.w800,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                                    .elementAt(
                                                        index)["discount"]
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                            snapshot.data.documents.elementAt(
                                                index)["total_amount"],
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
            )
          ],
        ),
      ),
    );
  }
}
