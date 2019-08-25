import 'package:flutter/material.dart';
import 'package:node_auth/MenuDashboardPage.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:node_auth/MenuDashboardPage.dart' as prefix0;
import 'package:node_auth/scan.dart';
import 'package:flutter/services.dart';

import 'package:node_auth/MenuTrieursPage.dart';
import 'package:node_auth/main.dart';
import 'package:node_auth/api_service.dart';
import './custom/my_flutter_app_icons.dart' as MyFlutterApp;
import 'package:http/http.dart' as http;

final Color backgroundColor = Color(0xFF4A4A58);
var darkGreenColor = Color(0xff279152);

class MenuProfilePage extends StatefulWidget {
  final String token;
  MenuProfilePage(this.token);
  @override
  _MenuProfilePageState createState() => _MenuProfilePageState();
}

class _MenuProfilePageState extends State<MenuProfilePage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  String _token, barcode;
  String message;

  BorderRadius _borderRadius = BorderRadius.all(Radius.zero);
  var greenColor = Color(0xff32a05f);
  var darkGreenColor = Color(0xff279152);
  ApiService _apiService;
  User _user;

  int _trieursNumber, _filleulsNumber;
  static const String barcodeRegExpString = r'^[0-9]{13}$';
  static final RegExp barcodeRegExp =
      new RegExp(barcodeRegExpString, caseSensitive: false);

  final _formKey = new GlobalKey<FormState>();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
   get baseUrl => _apiService.baseUrl;

  @override
  void initState() {
    super.initState();
    _apiService = new ApiService();
    _token = widget.token;

    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);

    getUserInformation();
    getTrieursNumber();
    getFilleulsNumber();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

Future<bool> _onBackPressed() {
   return Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(
                    builder: (context) => new MenuDashboardPage(_token),
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
      onWillPop:_onBackPressed ,
          child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          menu(context),
          profile(context),
        ],
      ),
    ),);
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
                                builder: (context) => new LoginPage(),
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

  Widget profile(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.60 * screenWidth,
      right: isCollapsed ? 0 : -0.6 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          borderRadius: _borderRadius,
          elevation: 20,
          color: greenColor,

          //color:Colors.white,

          //backgroundColor: greenColor,
          //key: _scaffoldKey,
          //resizeToAvoidBottomInset: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(100.0)),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 30, 8, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //SizedBox(height: 8.0),
                        InkWell(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 300),
                            child:
                                Icon(Icons.menu, size: 35, color: Colors.red),
                          ),
                          onTap: () {
                            print('tapped menu');
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
                        //SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: new Card(
                            color: Colors.blue[50].withOpacity(1.0),
                            child: new Padding(
                              padding: const EdgeInsets.all(8),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      ClipOval(
                                        child: new GestureDetector(
                                          child: _user?.avatar != null
                                              ? Image.network(
                                                  (baseUrl +
                                                      _user?.avatar),
                                                  fit: BoxFit.contain,
                                                  width: 90.0,
                                                  height: 90.0,
                                                )
                                              : new Image.asset(
                                                  'assets/no-avatar.png',
                                                  width: 90.0,
                                                  height: 90.0,
                                                ),
                                          // onTap: _pickAndUploadImage,
                                        ),
                                      ),
                                      new Expanded(
                                        child: ListTile(
                                            title: _user != null
                                                ? Text(
                                                    "Hello " +
                                                        capitalize(
                                                            _user?.firstname),
                                                    style: new TextStyle(
                                                      fontFamily: 'Pacifico',
                                                      fontSize: 24.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )
                                                : Text(
                                                    "Hello " + "loading...",
                                                    style: new TextStyle(
                                                      fontFamily: 'Pacifico',
                                                      fontSize: 24.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                            subtitle: _user != null
                                                ? Text(
                                                    "${capitalize(_user?.email)}\n${capitalize(_user?.role)}",
                                                    style: new TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  )
                                                : Text(
                                                    "${"loading..."}\n${"loading..."}",
                                                    style: new TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                    Text('Confirmer les sacs que j\'ai trié moi même',
                    textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Pacifico',
                                  
                                  color: Colors.orange,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 20.0)),
                        //SizedBox(height: 12.0),
                        new Center(
                          // texts
                          child: new Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: new Column(
                              children: <Widget>[
                                new Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  // mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: FlatButton(
                                          onPressed: () {
                                            print('enter barcode');
                                            _asyncInputDialog(context);
                                          },
                                          child: Image.asset(
                                              'assets/input-barcode.png',
                                              width: 150,
                                              height: 125),
                                        ),
                                        // You can add a Icon instead of text also, like below.
                                        //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: FlatButton(
                                          onPressed: () {
                                            barcodeScanning();
                                          },
                                          child: Image.asset(
                                              'assets/scan-barcode.png',
                                              width: 150,
                                              height: 116),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                new Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  // mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Container(
                                      //width: 50.0,
                                      //height: 50.0,
                                      // padding: const EdgeInsets.only(left:0 ), //I used some padding without fixed width and height

                                      child: new Text('Saisir\ncode à barre',
                                          textAlign: TextAlign.center,
                                          style: new TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontFamily: 'Ubuntu',
                                            //fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      // You can add a Icon instead of text also, like below.
                                      //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                                    ),
                                    new Container(
                                      //width: 50.0,
                                      //height: 50.0,
                                      // padding: const EdgeInsets.only(right:0 ),
                                      //I used some padding without fixed width and height

                                      child: new Text('Scanner\ncode à barre',
                                          textAlign: TextAlign.center,
                                          style: new TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontFamily: 'Ubuntu',
                                            fontWeight: FontWeight.bold,
                                          )), // You can add a Icon instead of text also, like below.
                                      //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0)
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('**Mon réseau**',
                              style: TextStyle(
                                  fontFamily: 'Pacifico',
                                  letterSpacing: 2.2,
                                  color: Colors.white,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 30.0)),
                        ],
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 80.0,
                            width: MediaQuery.of(context).size.width / 2 - 50,
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
                                    _trieursNumber != null
                                        ? Text(
                                            '$_trieursNumber',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 42.0),
                                          )
                                        : Text(
                                            '',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 42.0),
                                          ),
                                  ],
                                ),
                                Text(
                                  'Trieurs',
                                  style: TextStyle(
                                      color: Colors.white54,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 80.0,
                            width: MediaQuery.of(context).size.width / 2 - 50,
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
                                    _filleulsNumber != null
                                        ? Text(
                                            '$_filleulsNumber',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 42.0),
                                          )
                                        : Text(
                                            '',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 42.0),
                                          ),
                                  ],
                                ),
                                Text(
                                  'Filleuls',
                                  style: TextStyle(
                                      color: Colors.white54,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    //String barcode = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Entrer le code à barre du sac que vous avez trié'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new Form(
                  key: _formKey,
                  //autovalidate: true,
                  child: new TextFormField(
                    autocorrect: true,
                    autovalidate: true,
                    autofocus: true,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: true),
                    decoration: new InputDecoration(
                      labelText: 'Barcode',
                      hintText: '13 digits barcode.',
                      prefixIcon: new Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8.0),
                        child: new Icon(MyFlutterApp.MyFlutterApp.barcode),
                      ),
                    ),
                    onSaved: (value) => barcode = value,
                    validator: (s) =>
                        //s.length != 12 ? "Barcode must be 12 digits" : null,
                        barcodeRegExp.hasMatch(s)
                            ? null
                            : 'Barcode must be 13 digits !',
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              color: Colors.lightGreen,
              child: new Text('Confirm', style: TextStyle(color: Colors.red)),
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  return;
                }
                _formKey.currentState.save();
                //_scaffoldKey.currentState.build(context);
                print('jalaaaaaaaaaaaal' + barcode);
                Navigator.of(context).pop(barcode);
                coachCollects();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _confirmationPopUp(BuildContext context) async {
    //String barcode = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Voulez vous confirmer le sac trié par vous même ?',
            textAlign: TextAlign.center,
          ),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: Text(
                  barcode,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontFamily: 'Athletic',
                    //fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              color: Colors.lightGreen,
              child: new Text('Confirm', style: TextStyle(color: Colors.red)),
              onPressed: () {
                print('jalaaaaaaaaaaaal' + barcode);
                Navigator.of(context).pop(barcode);
                coachCollects();
              },
            ),
          ],
        );
      },
    );
  }

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

// Method for scanning barcode....
  Future barcodeScanning() async {
    try {
      String barcode = await BarcodeScanner.scan();
      if ((barcode.length == 13) && (_isNumeric(barcode))) {
        setState(() => this.barcode = barcode);
        _confirmationPopUp(context);
      } else {
        setState(() => this.message = 'Invalid barcode content');
        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(
              content: new Text(message,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: Colors.red,
                    fontSize: 20.0,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                  ))),
        );
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() => this.message = 'No camera permission!');
        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(
              content: new Text(message,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: Colors.red,
                    fontSize: 20.0,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                  ))),
        );
      } else {
        setState(() => this.message = 'Unknown error: $e');
        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(
              content: new Text(message,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: Colors.red,
                    fontSize: 20.0,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                  ))),
        );
      }
    } on FormatException {
      setState(() => this.message = 'Nothing captured.');
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
            content: new Text(message,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.red,
                  fontSize: 20.0,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                ))),
      );
    } catch (e) {
      setState(() => this.message = 'Unknown error: $e');
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
            content: new Text(message,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.red,
                  fontSize: 20.0,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                ))),
      );
    }
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

  void coachCollects() {
    print('barcooooooode==' + barcode);
    print(_user.id);
    _apiService
        .coachCollects(_token, barcode, _user.id)
        .then((http.Response response) {
      print('I guess shit works');
      print('statuuuuuuuuuuus==' + response.statusCode.toString());
      String message = '';
      switch (response.statusCode) {
        case 404:
          {
            message = 'code à barre invalide';
          }
          break;

        case 401:
          {
            message = 'Vous n\'etes pas autorisé';
          }
          break;
        case 403:
          {
            message = 'Mais le ac déja affecté !';
          }
          break;

        case 409:
          {
            message = 'Veuillez remettre le sac au propre Coach';
          }
          break;

        case 412:
          {
            message = 'Sac déja confirmé';
          }
          break;
        case 200:
          {
            message = 'Félicitation le sac à été bien confirmé';
          }
          break;
        default:
          {
            message = 'Erreur inconnue';
          }
          break;
      }
      if (response.statusCode == 200) {
        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(
            content: new Text(
              message,
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Colors.green,
                fontSize: 20.0,
                fontFamily: 'Ubuntu',
                //fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else {
        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(
            content: new Text(
              message,
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Colors.red,
                fontSize: 20.0,
                fontFamily: 'Ubuntu',
                //fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    });
  }

  getTrieursNumber() async {
    try {
      final number = await _apiService.coachTrieursNumber(_token);
      setState(() {
        _trieursNumber = int.parse(number);
        if (number == null)
          _trieursNumber = 0;
        else
          _trieursNumber = int.parse(number);
        debugPrint("trieurs number = $number");
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

  getFilleulsNumber() async {
    try {
      final number = await _apiService.referralsNumber(_token);
      setState(() {
        if (number == null)
          _filleulsNumber = 0;
        else
          _filleulsNumber = int.parse(number);

        debugPrint("filleuls number = $number");
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
