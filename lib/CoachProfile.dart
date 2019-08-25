import 'dart:async';
import 'dart:ui' as prefix0;
import './custom/my_flutter_app_icons.dart' as MyFlutterApp;
import 'package:flutter/material.dart';

import 'package:node_auth/api_service.dart';
import 'package:http/http.dart' as http;

class CoachProfile extends StatefulWidget {
  final String token;
  //final String email;

  CoachProfile(this.token);

  @override
  _CoachProfileState createState() => _CoachProfileState();
}

class _CoachProfileState extends State<CoachProfile> {
  String _token, barcode;
  int _atScanned, _todayScanned;
  User _user;

  var greenColor = Color(0xff32a05f);
  var darkGreenColor = Color(0xff279152);
  var productImage =
      'https://i.pinimg.com/originals/8f/bf/44/8fbf441fa92b29ebd0f324effbd4e616.png';

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
    //_email = widget.email;
    _apiService = new ApiService();

    //getUserInformation();
    //getWorkerStats();
  }

  @override
  Widget build(BuildContext context) {
    // var myUrl=baseUrl;
        return Scaffold(
            backgroundColor: greenColor,
            key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.menu),
                          ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
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
                                                    (baseUrl +
                                                    _user?.avatar),
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
                                        title: Text(
                                          "Hello " +
                                              (_user?.firstname ??
                                                  "loading..."),
                                          style: new TextStyle(
                                            fontFamily: 'Pacifico',
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${_user?.email ?? "loading..."}\n${_user?.role ?? "loading..."}",
                                          style: new TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      /*Text(
                        '10" Nursery Pot',
                        style: TextStyle(color: Colors.black45),
                      ),*/
                      SizedBox(height: 12.0),
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
                                          print('Scan barcode');
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
                                  Text(
                                    '25',
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
                                  Text(
                                    '25',
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
        ));
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    //String barcode = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter le code à barre'),
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
                //workerCollects();
              },
            ),
          ],
        );
      },
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

  void workerCollects() {
    print('barcooooooode==' + barcode);
    _apiService.workerCollects(_token, barcode).then((http.Response response) {
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
            textAlign: prefix0.TextAlign.center,
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
}

//---------------------------------------------------------------------------------------------

class DashboardButton extends StatelessWidget {
  const DashboardButton({
    Key key,
    @required this.icon,
    @required this.text,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FractionallySizedBox(
              widthFactor: 0.6,
              child: FittedBox(
                child: Icon(icon),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textScaleFactor: 0.8,
            ),
            SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(height: 1.0),
            ),
          ],
        ),
      ),
    );
  }
}
