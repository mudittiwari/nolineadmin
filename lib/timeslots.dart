import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class timeslots extends StatefulWidget {
  String type;
  final user;
  timeslots(this.type, this.user);
  @override
  _timeslotsState createState() => _timeslotsState();
}

class _timeslotsState extends State<timeslots> {
  CalendarController _controller;
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

  Widget cont(bool active, String slot) {
    if (!active) {
      return InkWell(
        onTap: () {},
        child: Container(
            width: 100,
            height: 30,
            decoration: BoxDecoration(
                color: Color(0xffFFF0E1),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
                child:
                    Text(slot, style: TextStyle(fontWeight: FontWeight.bold)))),
      );
    } else {
      return InkWell(
        onTap: () {},
        child: Container(
            width: 100,
            height: 30,
            decoration: BoxDecoration(
                color: Color(0xffDCE03B),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: Text(slot,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)))),
      );
    }
  }

  Future<QuerySnapshot> checkdate() {
    return Firestore.instance
        .collection(widget.type.toString())
        .where('name', isEqualTo: widget.user["name"])
        .getDocuments();
  }

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            backgroundColor: Color(0xffFF7D7D),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                child: Center(
                  child: TableCalendar(
                    headerStyle: HeaderStyle(
                        leftChevronVisible: false,
                        rightChevronVisible: false,
                        centerHeaderTitle: true,
                        headerPadding: EdgeInsets.symmetric(vertical: 30),
                        titleTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        formatButtonTextStyle: TextStyle(color: Colors.white)),
                    calendarStyle: CalendarStyle(
                        selectedColor: Colors.white,
                        todayStyle: TextStyle(color: Colors.white),
                        selectedStyle: TextStyle(color: Colors.black),
                        weekdayStyle: TextStyle(color: Colors.white),
                        weekendStyle: TextStyle(color: Colors.white),
                        todayColor: Colors.green,
                        markersColor: Colors.white),
                    daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: Colors.white),
                        weekendStyle: TextStyle(color: Colors.white)),
                    initialCalendarFormat: CalendarFormat.week,
                    availableCalendarFormats: {CalendarFormat.week: "Week"},
                    calendarController: _controller,
                    onDaySelected: (day, events, holidays) {
                      setState(() {});
                    },
                    // availableCalendarFormats: {CalendarFormat.week: 'week'},
                  ),
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            FutureBuilder(
              future: checkdate(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  );
                else if (snapshot.hasError)
                  return Center(child: Icon(Icons.error));
                else {
                  if (snapshot.data.documents.first["timeslots"].keys
                      .toList()
                      .contains(_controller.selectedDay
                          .toString()
                          .substring(0, 10))) {
                    // print();
                    List lis = snapshot.data.documents.first["timeslots"]
                        [_controller.selectedDay.toString().substring(0, 10)];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Text(
                            "Morning",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              lis.contains("07:00 AM") == true
                                  ? cont(true, "07:00 AM")
                                  : cont(false, "07:00 AM"),
                              lis.contains("07:30 AM") == true
                                  ? cont(true, "07:30 AM")
                                  : cont(false, "07:30 AM"),
                              lis.contains("08:00 AM") == true
                                  ? cont(true, "08:00 AM")
                                  : cont(false, "08:00 AM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              lis.contains("08:30 AM") == true
                                  ? cont(true, "08:30 AM")
                                  : cont(false, "08:30 AM"),
                              lis.contains("09:00 AM") == true
                                  ? cont(true, "09:00 AM")
                                  : cont(false, "09:00 AM"),
                              lis.contains("09:30 AM") == true
                                  ? cont(true, "09:30 AM")
                                  : cont(false, "09:30 AM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              lis.contains("10:00 AM") == true
                                  ? cont(true, "10:00 AM")
                                  : cont(false, "10:00 AM"),
                              lis.contains("10:30 AM") == true
                                  ? cont(true, "10:30 AM")
                                  : cont(false, "10:30 AM"),
                              lis.contains("11:00 AM") == true
                                  ? cont(true, "11:00 AM")
                                  : cont(false, "11:00 AM"),

                              // cont(false, "11:00 AM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              lis.contains("11:30 AM") == true
                                  ? cont(true, "11:30 AM")
                                  : cont(false, "11:30 AM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Text(
                            "Afternoon",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              lis.contains("12:00 PM") == true
                                  ? cont(true, "12:00 PM")
                                  : cont(false, "12:00 PM"),
                              lis.contains("12:30 PM") == true
                                  ? cont(true, "12:30 PM")
                                  : cont(false, "12:30 PM"),
                              lis.contains("01:00 PM") == true
                                  ? cont(true, "01:00 PM")
                                  : cont(false, "01:00 PM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              lis.contains("01:30 PM") == true
                                  ? cont(true, "01:30 PM")
                                  : cont(false, "01:30 PM"),
                              lis.contains("02:00 PM") == true
                                  ? cont(true, "02:00 PM")
                                  : cont(false, "02:00 PM"),
                              lis.contains("02:30 PM") == true
                                  ? cont(true, "02:30 PM")
                                  : cont(false, "02:30 PM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              lis.contains("03:00 PM") == true
                                  ? cont(true, "03:00 PM")
                                  : cont(false, "03:00 PM"),
                              lis.contains("03:30 PM") == true
                                  ? cont(true, "03:30 PM")
                                  : cont(false, "03:30 PM"),
                              lis.contains("04:00 PM") == true
                                  ? cont(true, "04:00 PM")
                                  : cont(false, "04:00 PM"),

                              // cont(false, "11:00 AM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Text(
                            "Evening",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              lis.contains("04:30 PM") == true
                                  ? cont(true, "04:30 PM")
                                  : cont(false, "04:30 PM"),
                              lis.contains("05:00 PM") == true
                                  ? cont(true, "05:00 PM")
                                  : cont(false, "05:00 PM"),
                              lis.contains("05:30 PM") == true
                                  ? cont(true, "05:30 AM")
                                  : cont(false, "05:30 PM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              lis.contains("06:00 PM") == true
                                  ? cont(true, "06:00 PM")
                                  : cont(false, "06:00 PM"),
                              lis.contains("06:30 PM") == true
                                  ? cont(true, "06:30 PM")
                                  : cont(false, "06:30 PM"),
                              lis.contains("07:00 PM") == true
                                  ? cont(true, "07:00 PM")
                                  : cont(false, "07:00 PM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              lis.contains("07:30 PM") == true
                                  ? cont(true, "07:30 PM")
                                  : cont(false, "07:30 PM"),
                              lis.contains("08:00 PM") == true
                                  ? cont(true, "08:00 PM")
                                  : cont(false, "08:00 PM"),
                              lis.contains("08:30 PM") == true
                                  ? cont(true, "08:30 PM")
                                  : cont(false, "08:30 PM"),

                              // cont(false, "11:00 AM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              lis.contains("09:00 PM") == true
                                  ? cont(true, "09:00 PM")
                                  : cont(false, "09:00 PM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Text(
                            "Note:",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Container(
                                        // color: Colors.grey,
                                        decoration: BoxDecoration(
                                          color: Color(0xffFFF0E1),
                                          borderRadius:
                                              BorderRadius.circular(7.5),
                                        ),
                                        width: 15,
                                        height: 15,
                                      ),
                                    ),
                                    Text(
                                      "Unavailable",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        // color: Colors.grey,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7.5),
                                            color: Color(0xffDCE03B)),
                                        width: 15,
                                        height: 15,
                                      ),
                                    ),
                                    Text(
                                      "Avaialable",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    print("Mudit");
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Text(
                            "Morning",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              cont(false, "07:00 AM"),
                              cont(false, "07:30 AM"),
                              cont(false, "08:00 AM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              cont(false, "08:30 AM"),
                              cont(false, "09:00 AM"),
                              cont(false, "09:30 AM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              cont(false, "10:00 AM"),
                              cont(false, "10:30 AM"),
                              cont(false, "11:00 AM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              cont(false, "11:30 AM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Text(
                            "Evening",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              cont(false, "12:00 PM"),
                              cont(false, "12:30 PM"),
                              cont(false, "01:00 PM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              cont(false, "01:30 PM"),
                              cont(false, "02:00 PM"),
                              cont(false, "02:30 PM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              cont(false, "03:00 PM"),
                              cont(false, "03:30 PM"),
                              cont(false, "04:00 PM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Text(
                            "Afternoon",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              cont(false, "04:30 PM"),
                              cont(false, "05:00 PM"),
                              cont(false, "05:30 PM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              cont(false, "06:00 PM"),
                              cont(false, "06:30 PM"),
                              cont(false, "07:00 PM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              cont(false, "07:30 PM"),
                              cont(false, "08:00 PM"),
                              cont(false, "08:30 PM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              cont(false, "09:00 PM"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Text(
                            "Note:",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Container(
                                        // color: Colors.grey,
                                        decoration: BoxDecoration(
                                          color: Color(0xffFFF0E1),
                                          borderRadius:
                                              BorderRadius.circular(7.5),
                                        ),
                                        width: 15,
                                        height: 15,
                                      ),
                                    ),
                                    Text(
                                      "Unavailable",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        // color: Colors.grey,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7.5),
                                            color: Color(0xffDCE03B)),
                                        width: 15,
                                        height: 15,
                                      ),
                                    ),
                                    Text(
                                      "Available",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }
              },
            )
          ])),
        ],
      ),
    );
  }
}
