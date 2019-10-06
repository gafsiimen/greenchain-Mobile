import 'dart:async';
import 'dart:ui';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:node_auth/HistoriquePage.dart';

import './custom/my_flutter_app_icons.dart' as MyFlutterApp;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:node_auth/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:node_auth/main.dart';

//import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  final String token;
  HomePage(this.token);


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _token, barcode;
  int _atScanned, _todayScanned;
  User _user;
  String message;

  ApiService _apiService;
  static const String barcodeRegExpString = r'^[0-9]{13}$';
  static final RegExp barcodeRegExp =
      new RegExp(barcodeRegExpString, caseSensitive: false);

  final _formKey = new GlobalKey<FormState>();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  get baseUrl => _apiService.baseUrl;

  @override
  void initState() {
    super.initState();

    _token = widget.token;
     print("_token in HOOOOOOOOOOOOOME");
     print(_token);
    _apiService = new ApiService();

    getUserInformation();
    getWorkerStats();
  }

  Future<bool> _onBackPressed() {
    return Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (context) => new LoginPage(),
        fullscreenDialog: true,
        maintainState: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      /*appBar: new AppBar(
             title: new Text('Mon profil'),
           ),*/
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: Container(
          decoration: new BoxDecoration(
              /* image: new DecorationImage(
                     image: new AssetImage('assets/bg.jpg'),
                     fit: BoxFit.cover,
                     colorFilter: new ColorFilter.mode(
                         Colors.blueAccent.withAlpha(0xBF), BlendMode.darken))*/
              ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
              child: Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
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
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 8.0, right: 24, bottom: 8),
                           child: Icon(
                             (MyFlutterApp.MyFlutterApp.logout),
                             size: 40,
                             color: Colors.red,
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                child: new Card(
                  color: Colors.blue[50].withOpacity(1.0),
                  child: new Padding(
                    padding: const EdgeInsets.all(8),
                    child: new Column(
                      children: <Widget>[
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ClipOval(
                              child: new GestureDetector(
                                child: _user?.avatar != null
                                    ? Image.network(
                                        (baseUrl + _user?.avatar),
                                        /*Uri.https(
                                                ApiService.baseUrl, _user?.avatar)
                                            .toString(),*/
                                        fit: BoxFit.cover,
                                        width: 90.0,
                                        height: 90.0,
                                      )
                                    : new Image.asset(
                                        'assets/user.png',
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
                                              capitalize(_user?.firstname),
                                          style: new TextStyle(
                                            fontFamily: 'Pacifico',
                                            fontSize: 21.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      : Text(
                                          "Hello " + "loading...",
                                          style: new TextStyle(
                                            fontFamily: 'Pacifico',
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                  subtitle: _user != null
                                      ? Text(
                                          "${capitalize(_user?.email)}\n${capitalize(_user?.role)}",
                                          style: new TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.italic),
                                        )
                                      : Text(
                                          "${"loading..."}\n${"loading..."}",
                                          style: new TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.italic),
                                        )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              new Center(
                // circles
                child: new Column(
                  children: <Widget>[
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      // mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Container(
                          //width: 50.0,
                          //height: 50.0,
                          padding: const EdgeInsets.all(
                              50), //I used some padding without fixed width and height
                          decoration: new BoxDecoration(
                            shape: BoxShape
                                .circle, // You can use like this way or like the below line
                            //borderRadius: new BorderRadius.circular(30.0),
                            border: new Border.all(
                              width: 3.0,
                              color: Colors.blue[300].withOpacity(1.0),
                            ),
                            color: Colors.lightGreen,
                          ),
                          child: new Text(
                              "${_todayScanned != null ? _todayScanned : ""}",
                              // "${_user?.email ?? "loading..."}\n${_user?.role ?? "loading..."}",
                              style: new TextStyle(
                                  color: Colors.yellow,
                                  fontFamily: 'Athletic',
                                  fontSize:
                                      50.0)), // You can add a Icon instead of text also, like below.
                          //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                        ),
                        new Container(
                          //width: 50.0,
                          //height: 50.0,
                          padding: const EdgeInsets.all(
                              50), //I used some padding without fixed width and height
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: new Border.all(
                              width: 3.0,
                              color: Colors.orange,
                            ),
                            // You can use like this way or like the below line
                            //borderRadius: new BorderRadius.circular(30.0),
                            color: Color(0xff32a05f),
                          ),
                          child: new Text(
                              "${_atScanned != null ? _atScanned : ""}",
                              style: new TextStyle(
                                  fontFamily: 'Athletic',
                                  color: Colors.blue[100],
                                  fontSize:
                                      50.0)), // You can add a Icon instead of text also, like below.
                          //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              new Center(
                // texts
                child: new Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: new Column(
                    children: <Widget>[
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Container(
                            //width: 50.0,
                            //height: 50.0,
                            padding: const EdgeInsets.only(
                                right:
                                    30), //I used some padding without fixed width and height

                            child: new Text('Scannés\naujourd\'hui',
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
                            padding: const EdgeInsets.only(
                                right:
                                    18), //I used some padding without fixed width and height

                            child: new Text('Totale\nscannés',
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
              new Center(
                // texts
                child: new Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: new Column(
                    children: <Widget>[
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                child: Image.asset('assets/input-barcode.png',
                                    width: 150, height: 125),
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
                                child: Image.asset('assets/scan-barcode.png',
                                    width: 150, height: 116),
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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

              // Padding(
              //   padding: const EdgeInsets.only(top: 16.0),
              //   child: Container(
              //     color: Color.fromRGBO(55, 230, 199, 1.0),
              //     height: 50,
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: <Widget>[
              //         Icon(Icons.home, color: Colors.black, size: 30),
              //         IconButton(
              //           icon:
              //               Icon(Icons.history, color: Colors.black, size: 30),
              //           onPressed: () {
              //             print('tapped Scanner');
              //             Navigator.of(context).pushReplacement(
              //               new MaterialPageRoute(
              //                 builder: (context) => new HistoriquePage(_token),
              //                 fullscreenDialog: true,
              //                 maintainState: false,
              //               ),
              //             );
              //           },
              //         ),
              /*IconButton(
                                 icon: Icon(Icons.blur_on, color: Colors.white),
                                 onPressed: () {},
                               ),
                               IconButton(
                                 icon: Icon(Icons.hotel, color: Colors.white),
                                 onPressed: () {},
                               ),
                               IconButton(
                                 icon: Icon(Icons.account_box, color: Colors.white),
                                 onPressed: () {},
                               )*/
            ],
          ),
        ),
      ),
      //      bottomNavigationBar:BottomNavyBar(
      // selectedIndex: _selectedIndex,
      // showElevation: true, // use this to remove appBar's elevation
      // onItemSelected: (index) => setState(() {
      //       _selectedIndex = index;

      //      _pageController.animateToPage(index,
      //                      duration: Duration(milliseconds: 300), curve: Curves.ease);
      //                }),

      //            items: [
      //              BottomNavyBarItem(
      //                  icon: Icon(Icons.home),
      //                  title: Text('Dashboard'),
      //                  activeColor: Colors.pink),
      //              BottomNavyBarItem(
      //                icon: Icon(Icons.apps),
      //                title: Text('Historique'),
      //                activeColor: Color.fromRGBO(55, 230, 199, 1.0),
      //              ),
      //              //  BottomNavyBarItem(
      //              //      icon: Icon(Icons.people),
      //              //      title: Text('Users'),
      //              //      activeColor: Colors.purpleAccent
      //              //  ),

      //              //  BottomNavyBarItem(
      //              //      icon: Icon(Icons.settings),
      //              //      title: Text('Settings'),
      //              //      activeColor: Colors.blue
      //              //  ),
      //            ],
      //          ),
    );
  }
  /*_displayDialog(BuildContext context) async {
               return showDialog(
                   context: context,
                   builder: (context) {
                     return AlertDialog(
                       title: Text('Saisir code à barre'),
                       content: TextField(
                         //controller: _textFieldController,
                         decoration: InputDecoration(hintText: "12 digits barcode"),
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
                         Navigator.of(context).pop();
                       },
                     ),
                       ],
                     );
                   });
           } */

  Future<String> _asyncInputDialog(BuildContext context) async {
    //String barcode = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Entrer le code à barre'),
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
                print('jalaaaaaaaaaaaal' + barcode);
                Navigator.of(context).pop(barcode);
                workerCollects();
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
            'Voulez vous confirmer le sac de ce code à barre ?',
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
                workerCollects();
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

  void workerCollects() {
    print('barcooooooode==' + barcode);
    _apiService.workerCollects(_token, barcode).then((http.Response response) {
      print('I guess shit works');
      print('statuuuuuuuuuuus==' + response.statusCode.toString());
      barcode = '';
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
            message = 'Le sac n\'est pas encore plein';
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
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          content: new Text(
            message,
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontFamily: 'Ubuntu',
              //fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }

  getWorkerStats() async {
    try {
      final stat = await _apiService.workerNumbers(_token);
      setState(() {
        _atScanned = stat.aT_collected;
        _todayScanned = stat.today_collected;

        debugPrint("Stats $stat");
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

/*_showChangePassword() {
    _scaffoldKey.currentState.showBottomSheet((context) {
      return new ChangePasswordBottomSheet(
        email: _email,
        token: _token,
      );
    });
  }*/

/* _pickAndUploadImage() async {
    try {
      final imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 720.0,
        maxHeight: 720.0,
      );
      final user = await _apiService.uploadImage(imageFile, _email);
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          content: new Text('Changed avatar successfully!'),
        ),
      );
      setState(() {
        _user = user;
        debugPrint('After change avatar $user');
      });
    } on MyHttpException catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          content: new Text(e.message),
        ),
      );
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text('An unknown error occurred!')),
      );
    }
  }*/

/*class ChangePasswordBottomSheet extends StatefulWidget {
  final String email;
  final String token;

  const ChangePasswordBottomSheet({Key key, this.email, this.token})
      : super(key: key);

  @override
  _ChangePasswordBottomSheetState createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  final _formKey = new GlobalKey<FormState>();
  ApiService _apiService;
  bool _obscurePassword;
  bool _obscureNewPassword;
  String _password, _newPassword;
  bool _isLoading;
  String _msg;

  String _token, _email;

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    _token = widget.token;
    _apiService = new ApiService();
    _isLoading = false;
    _obscurePassword = true;
    _obscureNewPassword = true;
  }

  @override
  Widget build(BuildContext context) {
    final passwordTextField = new TextFormField(
      autocorrect: true,
      autovalidate: true,
      obscureText: _obscurePassword,
      decoration: new InputDecoration(
        suffixIcon: new IconButton(
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          icon: new Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility),
          iconSize: 18.0,
        ),
        labelText: 'Old password',
        prefixIcon: new Padding(
          padding: const EdgeInsetsDirectional.only(end: 8.0),
          child: new Icon(Icons.lock),
        ),
      ),
      keyboardType: TextInputType.text,
      maxLines: 1,
      style: new TextStyle(fontSize: 16.0),
      onSaved: (s) => _password = s,
      validator: (s) => s.length < 6 ? "Minimum length of password is 6" : null,
    );

    final newPasswordTextField = new TextFormField(
      autocorrect: true,
      autovalidate: true,
      obscureText: _obscureNewPassword,
      decoration: new InputDecoration(
        suffixIcon: new IconButton(
          onPressed: () =>
              setState(() => _obscureNewPassword = !_obscureNewPassword),
          icon: new Icon(
              _obscureNewPassword ? Icons.visibility_off : Icons.visibility),
          iconSize: 18.0,
        ),
        labelText: 'New password',
        prefixIcon: new Padding(
          padding: const EdgeInsetsDirectional.only(end: 8.0),
          child: new Icon(Icons.lock),
        ),
      ),
      keyboardType: TextInputType.text,
      maxLines: 1,
      style: new TextStyle(fontSize: 16.0),
      onSaved: (s) => _newPassword = s,
      validator: (s) => s.length < 6 ? "Minimum length of password is 6" : null,
    );

    final changePasswordButton = _isLoading
        ? new CircularProgressIndicator()
        : _msg != null
            ? new Text(
                _msg,
                style: new TextStyle(
                  fontSize: 14.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.amber,
                ),
              )
            : new RaisedButton(
                color: Colors.teal.shade400,
                onPressed: _changePassword,
                child: new Text(
                  "Change password",
                  style: TextStyle(fontSize: 16.0),
                ),
              );

    return new Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.only(
          topLeft: new Radius.circular(8.0),
          topRight: new Radius.circular(8.0),
        ),
      ),
      child: new Form(
        key: _formKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: passwordTextField,
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: newPasswordTextField,
            ),
            new Padding(
              padding: const EdgeInsets.all(32.0),
              child: changePasswordButton,
            )
          ],
        ),
      ),
    );
  }

  _changePassword() async {
    setState(() => _isLoading = true);

    if (!_formKey.currentState.validate()) {
      setState(() {
        _isLoading = false;
        _msg = 'Invalid information';
      });
      await new Future.delayed(Duration(seconds: 1));
      setState(() {
        _msg = null;
      });
      return;
    }

    _formKey.currentState.save();
    debugPrint("$_password|$_newPassword");

    try {
      final response = await _apiService.changePassword(
          _email, _password, _newPassword, _token);

      setState(() {
        _isLoading = false;
        _msg = response.message;
      });
      await new Future.delayed(Duration(seconds: 1));
      setState(() {
        _msg = null;
      });
    } on MyHttpException catch (e) {
      setState(() {
        _isLoading = false;
        _msg = e.message;
      });
      await new Future.delayed(Duration(seconds: 1));
      setState(() {
        _msg = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _msg = 'Unknown error occurred';
      });
      await new Future.delayed(Duration(seconds: 1));
      setState(() {
        _msg = null;
      });
      throw e;
    }
  }
}
*/
