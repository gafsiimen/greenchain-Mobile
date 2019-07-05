/*import 'package:animation/Components/custom_route.dart';



import 'package:animation/Screens/pick_carpet_area.dart';*/
import 'package:flutter/material.dart';
import 'package:image/image.dart' as prefix0;
import 'package:node_auth/custom/custom_text.dart';
import 'package:node_auth/custom/trapezoid_container.dart';
import 'package:node_auth/custom/round_container.dart';

class CoachDashboard3 extends StatefulWidget {
  final String token;
  //final String email;

  CoachDashboard3(this.token);

  @override
  _CoachDashboard3State createState() => _CoachDashboard3State();
}

class _CoachDashboard3State extends State<CoachDashboard3> {
  String _token, barcode;
  int _atScanned, _todayScanned;
  //User _user;

  //ApiService _apiService;
//List lessons;
  // final _scaffoldKey = new GlobalKey<ScaffoldState>();
  var darkGreenColor = Color(0xff279152);
  @override
  void initState() {
    super.initState();
    //lessons = getLessons();
    _token = widget.token;
    //_email = widget.email;
    // _apiService = new ApiService();

    //getUserInformation();
    //getWorkerStats();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var remHeight = MediaQuery.of(context).size.height - 180;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            Container(
              height: 38,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.menu, size: 30 ,color: Colors.red, ),

                      ),
                    Text(
                      "My Green Points",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 32,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.green,
                        size: 32,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 7,
            ),
            InkWell(
              onTap: () {
                /*Navigator.push(context,MyCustomRoute(
        builder: (context) => PickCarpet()
          ));*/
              },
              child: Container(
                  height: 120,
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: ListTile(
                        leading: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            color: Colors.blue,
                          ),
                          child: new Text('250',
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  color: Colors.greenAccent,
                                  fontFamily: 'Athletic',
                                  fontSize: 40.0)),
                        ),
                        title:
                            CustomText.text(text: "GP disponibles", size: 22),
                        subtitle: CustomText.text(
                            text: "18 GP en attente", size: 16)),
                  )),
            ),
            Text(
              "Mes Sacs",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 32,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0,
                    top: 0,
                    width: width * 0.45,
                    child: TrapezoidContainer(
                      height: remHeight / 2 + 30,
                      width: width * 0.45,
                      color: Color.fromRGBO(87, 194, 67, 1),
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Sacs vides",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            border: Border.all(
                              color: Color.fromRGBO(132, 140, 255, 1),
                              width: 5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: new Text('250',
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    color: Color.fromRGBO(132, 140, 255, 1),
                                    fontFamily: 'Athletic',
                                    fontSize: 30.0)),
                          ),
                        )
                      ],
                      points: [
                        Offset(0, 0),
                        Offset(width * 0.45, 0),
                        Offset(
                            width * 0.45, (remHeight / 2) - 40 + 10 + 20), //-10
                        Offset(0, (remHeight / 2) + 10 + 20) //+30
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    width: width * .45,
                    child: TrapezoidContainer(
                      height: remHeight / 2 - 30,
                      width: width * 0.45,
                      color: Color.fromRGBO(253, 187, 59, 1),
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        CustomText.text18(
                          text: "Triés et collectés",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              border: Border.all(
                                width: 5,
                                color: Color.fromRGBO(239, 123, 175, 1),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: new Text('250',
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    color: Color.fromRGBO(239, 123, 175, 1),
                                    fontFamily: 'Athletic',
                                    fontSize: 30.0)),
                          ),
                        )
                      ],
                      points: [
                        Offset(0, 0),
                        Offset(width * 0.45, 0),
                        Offset(width * 0.45, (remHeight / 2 - 30)), // -30
                        Offset(0, (remHeight / 2 - 30) - 40) // -70
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    width: width * .45,
                    child: TrapezoidContainer(
                      height: remHeight / 2 + 10 - 20,
                      width: width * 0.45,
                      color: Color.fromRGBO(239, 123, 175, 1),
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            border: Border.all(
                              color: Color.fromRGBO(253, 187, 59, 1),
                              width: 5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: new Text('25',
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    color: Color.fromRGBO(253, 187, 59, 1),
                                    fontFamily: 'Athletic',
                                    fontSize: 30.0)),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        CustomText.text18(
                          text: "Sacs livrés",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                      points: [
                        Offset(0, 40),
                        Offset(width * 0.45, 0),
                        Offset(width * 0.45, (remHeight / 2) - 20),
                        Offset(0, (remHeight / 2) - 20)
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 0,
                    width: width * .45,
                    child: TrapezoidContainer(
                      height: remHeight / 2 - 18,
                      width: width * 0.45,
                      color: Color.fromRGBO(132, 140, 255, 1),
                      children: <Widget>[
                        SizedBox(
                          height: 35,
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            border: Border.all(
                              color: Colors.green[700],
                              width: 5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: new Text('25',
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    //color: Color.fromRGBO(87, 194, 67, 1),
                                    color: Colors.green[800],
                                    fontFamily: 'Athletic',
                                    fontSize: 30.0)),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        CustomText.text18(
                          text: "dans l\'espace\n de stockage",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                      points: [
                        Offset(0, 0),
                        Offset(width * 0.45, 40),
                        Offset(width * 0.45, (remHeight / 2 + 40)),
                        Offset(0, (remHeight / 2 + 30 + 10))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            /*Text(
              "Mes Sacs",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 32,
              ),
            ),*/

            /*SizedBox(
        height: 10,
            ),*/
            //Spacer(),
            /* Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
        //height: 100.0,
        //width: MediaQuery.of(context).size.width / 2 - 50,
        decoration: BoxDecoration(
            color: darkGreenColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '250',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 42.0),
                ),
                SizedBox(width: 8.0),
                Text(
                  'ml',
                  style: TextStyle(color: Colors.white54),
                )
              ],
            ),
            Text(
              'water',
              style: TextStyle(color: Colors.white54),
            )
          ],
        ),
          ),
          Container(
        //height: 100.0,
           // width: MediaQuery.of(context).size.width / 2 - 50,
        decoration: BoxDecoration(
            color: darkGreenColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '18',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 42.0),
                ),
                SizedBox(width: 8.0),
                Text(
                  'c',
                  style: TextStyle(color: Colors.white54),
                )
              ],
            ),
            Text(
              'Sunshine',
              style: TextStyle(color: Colors.white54),
            )
          ],
        ),
          ),
        ],
            ),*/
          ],
        ),
      ),
    );
  }
}
