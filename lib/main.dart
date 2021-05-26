import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:noline_admin/admindashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noline Admin',
      theme: ThemeData(
        // primarySwatch: Color(0xffFFBA9D),
        primarySwatch: Colors.green,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Wrong Credentials")),
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
        resizeToAvoidBottomPadding: false,
        body: DoubleBackToCloseApp(
          snackBar: SnackBar(content: Text("Press again to quit")),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image(image: AssetImage("assets/images/ffer.png"))),
              Center(
                child: Column(
                  children: [
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: Text(
                        "Admin Login",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 0.0,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 60.0, left: 60.0, top: 15.0),
                      child: TextField(
                        controller: username,
                        decoration: InputDecoration(
                          hintText: "User Name",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 60.0, left: 60.0, top: 5.0, bottom: 35.0),
                      child: TextField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "password",
                        ),
                      ),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      padding: EdgeInsets.symmetric(
                          horizontal: 60.0, vertical: 10.0),
                      color: Color(0xffFF7D7D),
                      onPressed: () {
                        if (username.text.trim().toString() == "mudit" &&
                            password.text.trim().toString() == "mudit") {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => admindashboard(),
                              ));
                        } else {
                          showLoaderDialog(context);
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 17.0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image(image: AssetImage("assets/images/btm.png"))),
            ],
          ),
        ));
  }
}
