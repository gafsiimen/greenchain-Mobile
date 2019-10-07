import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:node_auth/MenuProfilePage.dart';
import 'package:node_auth/MenuTrieursPage.dart';
import 'package:node_auth/custom/custom_text.dart';
import 'package:node_auth/custom/trapezoid_container.dart';
import 'package:node_auth/main.dart';
import 'package:node_auth/api_service.dart';

import 'GorgeousLogin.dart';

final Color backgroundColor = Color(0xFF4A4A58);
var darkGreenColor = Color(0xff279152);

class MenuDashboardPage extends StatefulWidget {
  final String token;
  MenuDashboardPage(this.token);
  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  String _token;
  BorderRadius _borderRadius = BorderRadius.all(Radius.zero);

  ApiService _apiService;
  User _user;
  Sac _sacs;
  Point _points;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _token = widget.token;
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);

    _apiService = new ApiService();

    getUserInformation();
    getCoachSacs();
    getCoachPoints();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    return Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (context) => new GorgeousLogin(),
        fullscreenDialog: true,
        maintainState: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: backgroundColor,
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            menu(context),
            dashboard(context),
          ],
        ),
      ),
    );
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start, // needed
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 150.0),
                    child: Container(
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: darkGreenColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(32.0),
                              bottomRight: Radius.circular(32.0))),
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 10.0),
                          Icon(Icons.person_outline,
                              color: Colors.white, size: 30.0),
                          SizedBox(width: 10.0),
                          _user != null
                              ? Text(
                                  capitalize(_user?.firstname),
                                  style: TextStyle(
                                      fontFamily: 'pacifico',
                                      color: Colors.white,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w500),
                                )
                              : Text(
                                  "",
                                  style: TextStyle(
                                      fontFamily: 'pacifico',
                                      color: Colors.white,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w500),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 100),
                        InkWell(
                          onTap: () {
                            print('tapped dashboard');
                            Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                builder: (context) =>
                                    new MenuDashboardPage(_token),
                                fullscreenDialog: true,
                                maintainState: false,
                              ),
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.home, color: Colors.white, size: 24.0),
                              SizedBox(width: 10.0),
                              Text(
                                "Dashboard",
                                style: TextStyle(shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.green[300],
                                    offset: Offset(5.0, 5.0),
                                  ),
                                ], color: Colors.white, fontSize: 22),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          onTap: () {
                            print('tapped profile');
                            Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                builder: (context) =>
                                    new MenuProfilePage(_token),
                                fullscreenDialog: true,
                                maintainState: false,
                              ),
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.face, color: Colors.white, size: 24.0),
                              SizedBox(width: 10.0),
                              Text(
                                "Mon Profil",
                                style: TextStyle(shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.green[300],
                                    offset: Offset(5.0, 5.0),
                                  ),
                                ], color: Colors.white, fontSize: 22),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          onTap: () {
                            print('tapped trieurs');
                            Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                builder: (context) =>
                                    new MenuTrieursPage(_token),
                                fullscreenDialog: true,
                                maintainState: false,
                              ),
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.people,
                                  color: Colors.white, size: 24.0),
                              SizedBox(width: 10.0),
                              Text(
                                "Mes trieurs",
                                style: TextStyle(shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.green[300],
                                    offset: Offset(5.0, 5.0),
                                  ),
                                ], color: Colors.white, fontSize: 22),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          onTap: () {
                            print('tapped logout');
                            Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                builder: (context) => new GorgeousLogin(),
                                fullscreenDialog: true,
                                maintainState: false,
                              ),
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.exit_to_app,
                                  color: Colors.white, size: 24.0),
                              SizedBox(width: 10.0),
                              Text(
                                "Se déconnecter",
                                style: TextStyle(shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.green[300],
                                    offset: Offset(5.0, 5.0),
                                  ),
                                ], color: Colors.white, fontSize: 22),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dashboard(context) {
    var width = MediaQuery.of(context).size.width;
    //var remHeight = MediaQuery.of(context).size.height - 180;
    var height = MediaQuery.of(context).size.height;
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          borderRadius: _borderRadius,
          elevation: 20,
          //color: backgroundColor,
          //color:Colors.white,
          child: Container(
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
                  height: height * 1 / 12,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.menu,
                              size: 35,
                              color: Colors.red,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              if (isCollapsed) {
                                _borderRadius =
                                    BorderRadius.all(Radius.circular(40));
                                _controller.forward();
                              } else {
                                _borderRadius = BorderRadius.all(Radius.zero);
                                _controller.reverse();
                              }

                              isCollapsed = !isCollapsed;
                            });
                          },
                        ),
                        InkWell(
                          child: Text(
                            "My Green Points",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 28,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              if (!isCollapsed) {
                                _borderRadius = BorderRadius.all(Radius.zero);
                                _controller.reverse();
                                isCollapsed = !isCollapsed;
                              }
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 1.0),
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
                // SizedBox(
                //   height: 7,
                // ),
                Container(
                    height: height * 2 / 12,
                    // margin: EdgeInsets.only(top: 10, bottom: 10),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              color: Colors.blue,
                            ),
                            child: _points != null
                                ? new Text(_points.total_available.toString(),
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                        color: Colors.greenAccent,
                                        fontFamily: 'Athletic',
                                        fontSize: 40.0))
                                : new Text('',
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                        color: Colors.greenAccent,
                                        fontFamily: 'Athletic',
                                        fontSize: 40.0)),
                          ),
                          title:
                              CustomText.text(text: "GP disponibles", size: 22),
                          subtitle: _points != null
                              ? CustomText.text(
                                  text: _points.total_pending.toString() +
                                      " GP en attente",
                                  size: 16)
                              : CustomText.text(
                                  text: "   GP en attente", size: 16)),
                    )),
                Container(
                    height: height * 1 / 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Mes Sacs",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    )),
                // SizedBox(
                //   height: 10,
                // ),
                Container(
                  height: height * 8 / 12 - 30,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        top: 0,
                        width: width * 0.45,
                        child: TrapezoidContainer(
                          // height: remHeight / 2 + 30,
                          height: height * 1 / 3,
                          width: width * 0.45,
                          color: Color.fromRGBO(87, 194, 67, 1),
                          children: <Widget>[
                            // SizedBox(
                            //   height: 20,
                            // ),
                            Text(
                              "Sacs vides",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            // SizedBox(
                            //   height: 40,
                            // ),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                border: Border.all(
                                  color: Color.fromRGBO(132, 140, 255, 1),
                                  width: 5,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: _sacs != null
                                    ? Text(_sacs?.empty.toString(),
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                            color: Color.fromRGBO(
                                                132, 140, 255, 1),
                                            fontFamily: 'Athletic',
                                            fontSize: 30.0))
                                    : Text('',
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                            color: Color.fromRGBO(
                                                132, 140, 255, 1),
                                            fontFamily: 'Athletic',
                                            fontSize: 30.0)),
                              ),
                            ),
                            SizedBox(
                              height: height * 1 / 50,
                            ),
                          ],
                          points: [
                            Offset(0, 0),
                            Offset(width * 0.45, 0),
                            Offset(width * 0.45, height * 1 / 3), //-10
                            Offset(0, height * 1 / 3) //+30
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        width: width * .45,
                        child: TrapezoidContainer(
                          // height: remHeight / 2 - 30,
                          height: height * 1 / 3,
                          width: width * 0.45,
                          color: Color.fromRGBO(253, 187, 59, 1),
                          children: <Widget>[
                            // SizedBox(
                            //   height: 20,
                            // ),
                            CustomText.text18(
                              text: "Triés et collectés",
                            ),
                            // SizedBox(
                            //   height: 20,
                            // ),
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
                                child: _sacs != null
                                    ? Text(
                                        (_sacs.collected + _sacs.selfScanned)
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                            color: Color.fromRGBO(
                                                239, 123, 175, 1),
                                            fontFamily: 'Athletic',
                                            fontSize: 30.0))
                                    : Text('',
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                            color: Color.fromRGBO(
                                                239, 123, 175, 1),
                                            fontFamily: 'Athletic',
                                            fontSize: 30.0)),
                              ),
                            ),
                            SizedBox(
                              height: height * 1 / 50,
                            ),
                          ],
                          points: [
                            Offset(0, 0),
                            Offset(width * 0.45, 0),
                            Offset(width * 0.45, (height * 1 / 3)), // -30
                            Offset(0, (height * 1 / 3)) // -70
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: height * 1 / 50,
                        left: 0,
                        width: width * .45,
                        child: TrapezoidContainer(
                          // height: remHeight / 2 + 10 - 20,
                          height: height * 1 / 3,
                          width: width * 0.45,
                          color: Color.fromRGBO(239, 123, 175, 1),
                          children: <Widget>[
                            SizedBox(
                              height: height * 1 / 50,
                            ),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                border: Border.all(
                                  color: Color.fromRGBO(253, 187, 59, 1),
                                  width: 5,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: _sacs != null
                                    ? Text(_sacs?.delivered.toString(),
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                            color:
                                                Color.fromRGBO(253, 187, 59, 1),
                                            fontFamily: 'Athletic',
                                            fontSize: 30.0))
                                    : Text('',
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                            color:
                                                Color.fromRGBO(253, 187, 59, 1),
                                            fontFamily: 'Athletic',
                                            fontSize: 30.0)),
                              ),
                            ),
                            CustomText.text18(
                              text: "Sacs livrés",
                            )
                          ],
                          points: [
                            Offset(0, height*1/15),
                            Offset(width * 0.45, 0),
                            Offset(width * 0.45, (height * 1 / 3)),
                            Offset(0, (height * 1 / 3))
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: height * 1 / 50,
                        right: 0,
                        width: width * .45,
                        child: TrapezoidContainer(
                          // height: remHeight / 2 - 18,
                          height: height * 1 / 3,

                          width: width * 0.45,
                          color: Color.fromRGBO(132, 140, 255, 1),
                          children: <Widget>[
                            SizedBox(
                              height: height * 1 / 50,
                            ),

                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                border: Border.all(
                                  color: Colors.green[700],
                                  width: 5,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: _sacs != null
                                    ? Text(
                                        _sacs?.confirmedNotDelivered.toString(),
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                            color: Colors.green[700],
                                            fontFamily: 'Athletic',
                                            fontSize: 30.0))
                                    : Text('',
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                            color: Colors.green[700],
                                            fontFamily: 'Athletic',
                                            fontSize: 30.0)),
                              ),
                            ),
                            // SizedBox(
                            //   height: 25,
                            // ),
                            CustomText.text18(
                              text: "dans l\'espace\n de stockage",
                            ),
                            // SizedBox(
                            //   height: 20,
                            // ),
                          ],
                          points: [
                            Offset(0, 0),
                            Offset(width * 0.45, height*1/15),
                            Offset(width * 0.45, (height * 1 / 3)),
                            Offset(0, height * 1 / 3)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getUserInformation() async {
    try {
      final user = await _apiService.getUserProfile(_token);
      setState(() {
        _user = user;
        //_createdAt = user.createdAt.toString();
        debugPrint("getUserInformation $_user");
      });
    } on MyHttpException catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(e.message)),
      );
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text('Unknown error occurred'),
      ));
    }
  }

  getCoachSacs() async {
    try {
      final sacs = await _apiService.coachSacs(_token);
      setState(() {
        _sacs = sacs;

        debugPrint("sacs= $sacs");
      });
    } on MyHttpException catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(e.message)),
      );
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text('Unknown error occurred'),
      ));
    }
  }

  getCoachPoints() async {
    try {
      final points = await _apiService.coachPoints(_token);
      setState(() {
        _points = points;

        debugPrint("points= $points");
      });
    } on MyHttpException catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(e.message)),
      );
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text('Unknown error occurred'),
      ));
    }
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
