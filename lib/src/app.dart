import 'dart:async';
import 'dart:convert';
import 'package:covid19nepal/src/NewsList.dart';
import "package:http/http.dart" show get;
import 'package:covid19nepal/src/CenterHorizontal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'NewsModel.dart';

class App extends StatefulWidget {
  createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  int deaths = 0;
  int recovered = 0;
  int active = 0;
  int nepDeath = 0;
  int nepRecovered = 0;
  int nepActive = 0;
  int total;
  int nepTotal=0;
  int nepTested;
  List<NewsModel> news = [];
  Timer timer;
  bool _isLoading = true;

  void updateData() async {
    print("Reloded");
    var response = await get('https://nepalcorona.info/api/v1/data/world');

    if (response.body != null) {
      var jsonData = json.decode(response.body);
      for (Map data in jsonData) {
        if (data["country"] == "") {
          setState(() {
            deaths = data['totalDeaths'];
            active = data['activeCases'];
            recovered = data['totalRecovered'];
            total = data['totalCases'];
          });
        } else if (data["country"] == "Nepal") {
          setState(() {
            nepDeath = data['totalDeaths'];
            nepActive = data['activeCases'];
            nepRecovered = data['totalRecovered'];
            nepTotal = data['totalCases'];
          });
        }
      }
      setState(() {
        _isLoading = false;
      });
      var responseData =
          await get("https://nepalcorona.info/api/v1/data/nepal");
      if (responseData.body != null) {
        jsonData = json.decode(responseData.body);
        setState(() {
          nepTested = jsonData['tested_total'];
        });
      }
      var newsData = await get("https://nepalcorona.info/api/v1/news");
      if (responseData.body != null) {
        jsonData = json.decode(newsData.body);
        int count = 0;
        List<NewsModel> mynews = [];
        while (count < 10) {
          Map data = jsonData["data"][count];
          mynews.add(new NewsModel(data));
          count++;
        }
        setState(() {
          news = mynews;
        });
      }
    }
    await delay(20000);
    updateData();
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => updateData());
  }

  Widget build(context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: HexColor("#f5f5f5"),
            body: ProgressHUD(
                inAsyncCall: _isLoading,
                opacity: 1.0,
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top:20.0,bottom: 5.0,left: 5.0,right: 5.0),
                          padding: EdgeInsets.all(5.0),
                          color: HexColor("#e8e8e8"),
                          child:Column(
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        color: Colors.black54,
                                        margin: EdgeInsets.only(
                                            left: 5.0, top: 5.0, bottom: 5.0),
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("COVID 19 - World Data",
                                            style: GoogleFonts.lato(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)))
                                  ]),
                              Container(
                                  color: Colors.deepPurple,
                                  margin: EdgeInsets.all(5.0),
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Total Cases",
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                        Text("$total",
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.white))
                                      ])),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                      child: Container(
                                          color: Colors.blue,
                                          margin: EdgeInsets.all(5.0),
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text("Active",
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white)),
                                                Text("$active",
                                                    style: GoogleFonts.lato(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.white))
                                              ]))),
                                  Expanded(
                                      child: Container(
                                          color: Colors.green,
                                          margin: EdgeInsets.all(5.0),
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text("Recovered",
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white)),
                                                Text("$recovered",
                                                    style: GoogleFonts.lato(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.white))
                                              ]))),
                                ],
                              ),
                              Container(
                                  color: Colors.red,
                                  margin: EdgeInsets.all(5.0),
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Total Deaths",
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                        Text("$deaths",
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.white))
                                      ])),

                            ],
                          )

                        ),
                        Container(
                            margin: EdgeInsets.only(top:5.0,bottom: 5.0,left: 5.0,right: 5.0),
                            padding: EdgeInsets.all(5.0),
                            color: HexColor("#e8e8e8"),
                          child:
                            Column(
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          color: Colors.black54,
                                          margin: EdgeInsets.only(
                                              left: 5.0, top: 5.0, bottom: 5.0),
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("COVID 19 - Nepal Data",
                                              style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)))
                                    ]),
                                Container(
                                    color: Colors.deepPurple,
                                    margin: EdgeInsets.all(5.0),
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Total Cases",
                                              style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          Text("$nepTotal out of $nepTested tests",
                                              style: GoogleFonts.lato(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.white))
                                        ])),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                        child: Container(
                                            color: Colors.blue,
                                            margin: EdgeInsets.all(5.0),
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text("Active",
                                                      style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white)),
                                                  Text("$nepActive",
                                                      style: GoogleFonts.lato(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.white))
                                                ]))),
                                    Expanded(
                                        child: Container(
                                            color: Colors.green,
                                            margin: EdgeInsets.all(5.0),
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text("Recovered",
                                                      style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white)),
                                                  Text("$nepRecovered",
                                                      style: GoogleFonts.lato(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.white))
                                                ]))),
                                  ],
                                ),
                                Container(
                                    color: Colors.red,
                                    margin: EdgeInsets.all(5.0),
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Total Deaths",
                                              style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          Text("$nepDeath",
                                              style: GoogleFonts.lato(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.white))
                                        ])),

                              ],
                            )
                        ),


                        Container(
                          color: HexColor("#e8e8e8"),
                          padding: EdgeInsets.all(5.0),
                          child:Column(
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        color: Colors.black54,
                                        margin: EdgeInsets.only(
                                            left: 5.0, top: 5.0,bottom: 5.0),
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("Latest News",
                                            style: GoogleFonts.lato(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)))
                                  ]),

                            ],
                          ) ,
                        ),
                        Expanded(child: NewsList(news)),


                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    launch("https://github.com/ramanic");
                                  },
                                  child: Container(
                                      color: HexColor("#e8e8e8"),
                                      margin: EdgeInsets.only(top: 8),
                                      child: Text("Github : @ramanic ",
                                          style: GoogleFonts.amaranth(
                                              fontSize: 12,
                                              color: Colors.black45))))
                            ]),
                      ],
                    )))));
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class ProgressHUD extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Animation<Color> valueColor;

  ProgressHUD({
    Key key,
    @required this.child,
    @required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = new List<Widget>();
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = new Stack(
        children: [
          new Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          new Center(
            child: new CircularProgressIndicator(
              valueColor: valueColor,
            ),
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}

Future<Null> delay(int milliseconds) {
  return new Future.delayed(new Duration(milliseconds: milliseconds));
}
