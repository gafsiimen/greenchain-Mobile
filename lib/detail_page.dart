import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:node_auth/MenuTrieursPage.dart';
import 'package:node_auth/api_service.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final User trieur;
  final String token;

  DetailPage(this.trieur, this.token);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String _token, barcode;
  String message;
  ApiService _apiService;
  User _user;
  TStats _stats;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

 get baseUrl => _apiService.baseUrl;
  @override
  void initState() {
    super.initState();
    _token = widget.token;
    _user = widget.trieur;
    _apiService = new ApiService();

    getTrieurStats();
  }


Future<bool> _onBackPressed() {
   return Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(
                    builder: (context) => new MenuTrieursPage(_token),
                    fullscreenDialog: true,
                    maintainState: false,
                  ),
   );
}

  @override
  Widget build(BuildContext context) {
    /*final levelIndicator = Container(
      child: Container(
        child: LinearProgressIndicator(
            backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
            value: user.indicatorValue,
            valueColor: AlwaysStoppedAnimation(Colors.green)),
      ),
    );*/

    final coursePrice = Container(
      height: 110,
      //width: 60,
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Color.fromRGBO(55, 230, 199, 1.0)),
          borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: new Text(
              "Trieur",
              style: TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                letterSpacing: 3,
                fontFamily: 'Ubuntu',
              ),
            ),
          ),
          SizedBox(height: 5.0),
          new Text(
            "Email : " +
                _user.email[0].toUpperCase() +
                _user.email.substring(1),
            style: TextStyle(color: Colors.white, letterSpacing: 0.5),
          ),
          SizedBox(height: 10.0),

          /* new Text(
      "\$" + user.price.toString(),
      style: TextStyle(color: Colors.white),
            ),*/

          new Text(
            "Adresse : " +
                _user.address[0].toUpperCase() +
                _user.address.substring(1) ,
                // +" " +
                // _user.zip.toString() +
                // " " +
                // _user.city[0].toUpperCase() +
                // _user.city.substring(1),
            style: TextStyle(color: Colors.white, letterSpacing: 0.5),
          ),
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.bottomRight,
            child: new Text(
              "Tel :" + _user.tel,
              style: TextStyle(color: Colors.white, letterSpacing: 2),
            ),
          ),
        ],
      ),
    );

    
        final topContentText = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10.0),
            /*Icon(
                Icons.directions_car,
                color: Colors.white,
                size: 40.0,
              ),*/
    
            Column(
              children: <Widget>[
                _user?.avatar != null
                    ? Image.network(
                      (baseUrl + _user?.avatar),
                    fit: BoxFit.contain,
                    width: 160.0,
                    height: 150.0,
                  )
                : new Image.asset(
                    'assets/no-avatar.png',
                    width: 160.0,
                    height: 150.0,
                  ),
          ],
        ),
        SizedBox(height: 10.0),
        Text(
          _user.firstname[0].toUpperCase() +
              _user.firstname.substring(1) +
              ' ' +
              _user.lastname[0].toUpperCase() +
              _user.lastname.substring(1),
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        //SizedBox(height: 10.0),
        Container(
          width: 120.0,
          child: new Divider(color: Colors.green),
        ),

        SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //Expanded(flex: 1, child: levelIndicator),
            /*Expanded(
                flex: 5,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      user.level,
                      style: TextStyle(color: Colors.white),
                    ))),*/
            Expanded(flex: 1, child: coursePrice)
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/bg.jpg"),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: EdgeInsets.only(left: 20.0, right: 20, top: 40),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 40.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        )
      ],
    );

    final bottomContentText = new Center(
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
                        print('Assign sac');
                        barcodeScanning('assign');
                      },
                      child: Image.asset('assets/scan-barcode.png',
                          width: 150, height: 125),
                    ),
                    // You can add a Icon instead of text also, like below.
                    //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: FlatButton(
                      onPressed: () {
                        print('collect sac');
                        barcodeScanning('collect');
                      },
                      child: Image.asset('assets/scan-barcode.png',
                          width: 150, height: 125),
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
                  padding: const EdgeInsets.only(
                      top:
                          11), //I used some padding without fixed width and height

                  child: new Text('Scanner pour\n assigner sac',
                      textAlign: TextAlign.start,
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
                  padding: const EdgeInsets.only(top: 11),
                  //I used some padding without fixed width and height

                  child: new Text('Scanner pour\nrécupérer sac',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      )), // You can add a Icon instead of text also, like below.
                  //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    final readButton = Container(
      //padding: EdgeInsets.symmetric(vertical: 16.0),
      padding: EdgeInsets.only(top: 16, bottom: 2),
      width: MediaQuery.of(context).size.width,
      child: Column(
        /*crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,*/
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 40.0,
                width: 150,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(55, 230, 199, 1.0),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(32.0),
                        bottomRight: Radius.circular(32.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 10.0),
                    Text(
                      'Distribués',
                      style: TextStyle(
                          fontFamily: 'pacifico',
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 10.0),
                  ],
                ),
              ),
              Container(
                height: 40.0,
                width: 150,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(55, 230, 199, 1.0),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.0),
                        bottomLeft: Radius.circular(32.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 10.0),
                    Text(
                      'Collectés',
                      style: TextStyle(
                          fontFamily: 'pacifico',
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500),
                    ),

                    //SizedBox(width: 10.0),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height: 180.0,
                width: MediaQuery.of(context).size.width / 2 - 35,
                decoration: BoxDecoration(
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage('assets/empty.png')),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 55,
                    ),
                    Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            border: Border.all(
                              width: 5,
                              color: Color.fromRGBO(55, 230, 199, 1.0),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: _stats != null
                              ? Text(_stats?.distributed.toString(),
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      color: Color.fromRGBO(132, 140, 255, 1),
                                      fontFamily: 'Athletic',
                                      fontSize: 30.0))
                              : Text('',
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      color: Color.fromRGBO(132, 140, 255, 1),
                                      fontFamily: 'Athletic',
                                      fontSize: 30.0)),
                        )),

                    /*Text(
                      'Trieurs',
                      style: TextStyle(
                          color: Colors.white54, fontWeight: FontWeight.bold),
                    )*/
                  ],
                ),
              ),
              SizedBox(width: 30.0),
              Container(
                height: 180.0,
                width: MediaQuery.of(context).size.width / 2 - 35,
                decoration: BoxDecoration(
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new AssetImage('assets/full.png'),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 55,
                    ),
                    Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            border: Border.all(
                              width: 5,
                              color: Color.fromRGBO(55, 230, 199, 1.0),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: _stats != null
                              ? Text(_stats?.collected.toString(),
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      color: Color.fromRGBO(132, 140, 255, 1),
                                      fontFamily: 'Athletic',
                                      fontSize: 30.0))
                              : Text('',
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      color: Color.fromRGBO(132, 140, 255, 1),
                                      fontFamily: 'Athletic',
                                      fontSize: 30.0)),
                        )),
                    /*Text(
                      'Trieurs',
                      style: TextStyle(
                          color: Colors.white54, fontWeight: FontWeight.bold),
                    )*/
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 10.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText, readButton],
        ),
      ),
    );

    return WillPopScope(
      onWillPop:_onBackPressed ,
          child: Scaffold(
      key: _scaffoldKey,
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[topContent, bottomContent],
        ),
      ),
      ),
    );
  }

  Future<String> _confirmationPopUp(BuildContext context, type) async {
    var firstname = this._user.firstname;
    var text;
    if (type == 'collect')
      text = 'Voulez vous collecter le sac de ce code à barre depuis ' +
          firstname +
          ' ?';
    else
      text = 'Voulez vous assigner le sac de ce code à barre à ' +
          firstname +
          ' ?';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            text,
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
                  if (type == 'collect') {
                    coachCollects();
                  } else
                    coachAssigns();
                }),
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
  Future barcodeScanning(type) async {
    try {
      String barcode = await BarcodeScanner.scan();
      if ((barcode.length == 13) && (_isNumeric(barcode))) {
        setState(() => this.barcode = barcode);
        _confirmationPopUp(context, type);
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
            message = 'Mais le sac déja affecté !';
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

  void coachAssigns() {
    print('barcooooooode==' + barcode);
    print(_user.id);
    _apiService
        .coachAssigns(_token, barcode, _user.id)
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
            message = 'Mais le sac est déja assigné';
          }
          break;

        case 409:
          {
            message = 'Veuillez remettre le sac au propre Coach';
          }
          break;

        case 412:
          {
            message = 'Sac non vide';
          }
          break;
        case 200:
          {
            message = 'Félicitation le sac à été bien assigné';
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

  getTrieurStats() async {
    try {
      final stats =
          await _apiService.trieurdistributedcollected(_token, _user.id);
      setState(() {
        _stats = stats;

        debugPrint("points= $stats");
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
