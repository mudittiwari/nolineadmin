import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:async/async.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
// import 'package:whatsapp_clone/admindashboard.dart';
import 'admindashboard.dart';

class addwedding extends StatefulWidget {
  final value;
  addwedding(this.value);
  @override
  _addweddingState createState() => _addweddingState();
}

class _addweddingState extends State<addwedding> {
  final AsyncMemoizer _memoizer = AsyncMemoizer<List>();
  TextEditingController amen_name = new TextEditingController();
  TextEditingController amen_price = new TextEditingController();
  TextEditingController time = new TextEditingController();
  String selected = "shave";
  int min = 999999;

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

  Future<List> getamen() {
    return _memoizer.runOnce(() async {
      List<String> f = [];
      await Firestore.instance.collection('ammen').getDocuments().then((value) {
        var l = value.documents.first["amen"];
        for (var item in l) {
          f.add(item.toString());
        }
      });
      if (f[0] is String) print("mudit");
      return f;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Add Services",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: DoubleBackToCloseApp(
          snackBar: SnackBar(content: Text("Please create wedding")),
          child: FutureBuilder(
            future: getamen(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else if (snapshot.hasError)
                return Center(
                  child: Icon(Icons.error),
                );
              else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // TextField(
                        //   controller: amen_name,
                        //   textAlign: TextAlign.center,
                        //   decoration: InputDecoration(
                        //     hintText: "name of service",
                        //   ),
                        // ),
                        DropdownButton<String>(
                          value: selected,
                          items:
                              snapshot.data.map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem<String>(
                              value: e.toString(),
                              child: Text(e),
                            );
                          }).toList(),
                          onChanged: (v) {
                            setState(() {
                              selected = v;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: amen_price,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "Price of serivce",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: time,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "Time in min",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: FlatButton(
                            color: Colors.grey,
                            child: Text(
                              "Add",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              if (int.parse(amen_price.text.trim().toString()) <
                                  min)
                                min = int.parse(
                                    amen_price.text.trim().toString());
                              showLoader(context);
                              Firestore.instance
                                  .collection("/weddings")
                                  .document(widget.value)
                                  .updateData({
                                selected: amen_price.text.toString(),
                                "time_list": FieldValue.arrayUnion([
                                  {selected: time.text.toString()}
                                ])
                              }).then((value) {
                                amen_name.text = "";
                                amen_price.text = "";
                                time.text = "";
                                Navigator.pop(context);
                              }).catchError((e) {
                                print(e);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: FlatButton(
                            color: Colors.grey,
                            child: Text(
                              "Create wedding",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => admindashboard(),
                                  ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          )),
    );
  }
}
