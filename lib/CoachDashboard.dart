import 'dart:async';
import 'dart:ui' as prefix0;
import './custom/my_flutter_app_icons.dart' as MyFlutterApp;
import 'package:flutter/material.dart';

import 'package:node_auth/api_service.dart';
import 'package:http/http.dart' as http;

class CoachDashboard extends StatefulWidget {
  final String token;
  //final String email;

  CoachDashboard(this.token);

  @override
  _CoachDashboardState createState() => _CoachDashboardState();
}

class _CoachDashboardState extends State<CoachDashboard> {
  String _token, barcode;
  int _atScanned, _todayScanned;
  User _user;

  ApiService _apiService;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Online-Campus | mobil'),
        actions: <Widget>[
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<int>>[
                PopupMenuItem(
                  value: 0,
                  child: Text('Login'),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text('Einstellungen'),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text('Download-Container'),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text('Soziale Netzwerke'),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Text('FAQ'),
                ),
              ];
            },
          ),
        ],
      ),
      body: IconTheme.merge(
        data: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.create, size: 72.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('14.11.2015'),
                          Text(
                            'E - Enconomics',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Virtuell, 00 virtuell, VR'),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text('08:30 - 12:30 Uhr'),
                        Text('lol'),
                        Text(':p'),
                      ],
                    ),
                  ],
                ),
                Divider(height: 1.0),
               // Expanded(),
              ],
            ),
          ),
        ]),
      ),
    );
  }

//---------------------------------------------------------------------------------------------
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
