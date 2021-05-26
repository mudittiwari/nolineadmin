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

class addsallon extends StatefulWidget {
  final value;
  addsallon(this.value);
  @override
  _addsallonState createState() => _addsallonState();
}

class _addsallonState extends State<addsallon> {
  final AsyncMemoizer _memoizer = AsyncMemoizer<List>();
  TextEditingController amen_name = new TextEditingController();
  TextEditingController amen_price = new TextEditingController();
  TextEditingController time = new TextEditingController();
  TextEditingController latitude = new TextEditingController();
  TextEditingController longitude = new TextEditingController();
  String selected = "shave";
  int min = 999999;
  File sampleImage;
  Future getImage() async {
    var temp = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = File(temp.path);
    });
  }

  TextEditingController fac = new TextEditingController();
  showLoaderDialog4(BuildContext context) {
    AlertDialog alert = AlertDialog(
        actions: [
          Container(
            margin: EdgeInsets.only(left: 7),
            child: FlatButton(
              onPressed: () async {
                print("mudit");
                showLoader(context);
                await Firestore.instance
                    .collection('sallons')
                    .document(widget.value)
                    .updateData({
                  "facilities": FieldValue.arrayUnion([fac.text]),
                });
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
                fac.text = "";
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
                      controller: fac,
                      decoration: InputDecoration(hintText: "Type ammenities"),
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
              onPressed: () async {
                print("mudit");
                showLoader(context);
                await Firestore.instance
                    .collection('sallons')
                    .document(widget.value)
                    .updateData({
                  "latitude": double.parse(latitude.text.toString().trim()),
                  "longitude": double.parse(longitude.text.toString().trim())
                });
                latitude.text = "";
                longitude.text = "";
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
                latitude.text = "";
                longitude.text = "";
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
                      controller: latitude,
                      decoration: InputDecoration(hintText: "Type latitude"),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: TextField(
                      controller: longitude,
                      decoration: InputDecoration(hintText: "Type longitude"),
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
          snackBar: SnackBar(content: Text("Please create sallon")),
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
                                  .collection("/sallons")
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
                          padding: const EdgeInsets.only(top: 18.0),
                          child: FlatButton(
                            color: Colors.grey,
                            child: Text(
                              "Add Ammenities",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              showLoaderDialog4(context);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: FlatButton(
                            color: Colors.grey,
                            child: Text(
                              "Add location",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              showLoaderDialog5(context);
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: FlatButton(
                            color: Colors.grey,
                            child: Text(
                              "Add photos",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              getImage().then((value) async {
                                showLoader(context);
                                StorageReference firebaseStorageRef =
                                    FirebaseStorage.instance.ref().child(
                                        "${Path.basename(sampleImage.path)}");
                                print("mudit");
                                StorageUploadTask task =
                                    firebaseStorageRef.putFile(sampleImage);
                                StorageTaskSnapshot taskSnapshot =
                                    await task.onComplete;
                                taskSnapshot.ref.getDownloadURL().then(
                                  (value) {
                                    Firestore.instance
                                        .collection("/sallons")
                                        .document(widget.value)
                                        .updateData({
                                      "min": min,
                                      "photos": FieldValue.arrayUnion(
                                          [value.toString()]),
                                    }).catchError((e) {
                                      print(e);
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: FlatButton(
                            color: Colors.grey,
                            child: Text(
                              "Create Sallon",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              getImage().then((value) async {
                                showLoader(context);
                                StorageReference firebaseStorageRef =
                                    FirebaseStorage.instance.ref().child(
                                        "${Path.basename(sampleImage.path)}");
                                print("mudit");
                                StorageUploadTask task =
                                    firebaseStorageRef.putFile(sampleImage);
                                StorageTaskSnapshot taskSnapshot =
                                    await task.onComplete;
                                taskSnapshot.ref.getDownloadURL().then(
                                  (value) {
                                    Firestore.instance
                                        .collection("/sallons")
                                        .document(widget.value)
                                        .updateData({
                                      "photo_url": value.toString(),
                                      "min": min
                                    }).then((value) {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                admindashboard(),
                                          ));
                                    }).catchError((e) {
                                      print(e);
                                    });
                                    // Navigator.pop(context);
                                  },
                                );
                              });
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
