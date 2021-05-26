import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:noline_admin/widgets.dart';

class searchbooking extends StatefulWidget {
  @override
  _searchbookingState createState() => _searchbookingState();
}

class _searchbookingState extends State<searchbooking> {
  bool len = false;
  TextEditingController search = new TextEditingController(text: "");
  Future<QuerySnapshot> getorder() async {
    return Firestore.instance
        .collection('active_bookings')
        .where('ID', isEqualTo: int.parse(search.text.trim().toString()))
        .getDocuments();
  }

  Future<QuerySnapshot> getprevorder() {
    return Firestore.instance
        .collection('previous_bookings')
        .where('ID', isEqualTo: int.parse(search.text.trim().toString()))
        .getDocuments();
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
              controller: search,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                if (value.length > 0) {
                  len = true;
                } else {
                  len = false;
                }
                setState(() {});
              },
              decoration: InputDecoration(
                  hintText: "Search",
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none),
            ),
          ),
        ),
        body: len == false
            ? Text("")
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder(
                    future: getorder(),
                    builder: (context, snapshot) {
                      // print(search.text.length);
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      else if (snapshot.hasError)
                        return Center(
                          child: Icon(Icons.error),
                        );
                      else {
                        if (snapshot.data.documents.length == 0)
                          return FutureBuilder(
                            future: getprevorder(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              else if (snapshot.hasError)
                                return Center(
                                  child: Icon(Icons.error),
                                );
                              else {
                                if (snapshot.data.documents.length == 0) {
                                  print("mudit");
                                  return Center(
                                    child: Text("No Booking"),
                                  );
                                } else {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              snapshot.data.documents
                                                  .first["user_name"]
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
                                              snapshot.data.documents
                                                  .first["sallon_name"]
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
                                                      .first["services"].keys
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
                                                                    FontWeight
                                                                        .w800,
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 17),
                                                          ),
                                                          Text(
                                                            snapshot
                                                                .data
                                                                .documents
                                                                .first[
                                                                    "services"]
                                                                .keys
                                                                .toList()[i]
                                                                .toString()
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 17),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        snapshot
                                                                .data
                                                                .documents
                                                                .first[
                                                                    "services"]
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
                                                itemCount: snapshot
                                                    .data.documents
                                                    .elementAt(0)["services"]
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.grey,
                                                        fontSize: 17),
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data.documents
                                                          .elementAt(
                                                              0)["discount"]
                                                          .toString() +
                                                      " Rs",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.grey,
                                                        fontSize: 17),
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data.documents
                                                      .elementAt(
                                                          0)["total_amount"],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.grey,
                                                      fontSize: 17),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        return Container(
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
                                    snapshot.data.documents.first["user_name"]
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
                                    snapshot.data.documents.first["sallon_name"]
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
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, i) {
                                        print(snapshot.data.documents
                                            .first["services"].keys
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
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.grey,
                                                      fontSize: 17),
                                                ),
                                                Text(
                                                  snapshot.data.documents
                                                      .first["services"].keys
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
                                                      .first["services"].values
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
                                          .elementAt(0)["services"]
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
                                                .elementAt(0)["discount"]
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
                                            .elementAt(0)["total_amount"],
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
                        );
                      }
                    },
                  ),
                ),
              ));
  }
}
