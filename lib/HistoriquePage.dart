import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:node_auth/api_service.dart';
import 'package:node_auth/home.dart';
import './custom/my_flutter_app_icons.dart' as MyFlutterApp;

final Color backgroundColor = Color(0xFF4A4A58);
var darkGreenColor = Color(0xff279152);

class HistoriquePage extends StatefulWidget {
  final String token;
  HistoriquePage(this.token);
  @override
  _HistoriquePageState createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  String _token;
  ApiService _apiService;
  List<History> _histories = [];

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

//   int _selectedIndex=2;
// PageController _pageController;
  @override
  void initState() {
    super.initState();
//  _pageController = PageController();

    _token = widget.token;
    _apiService = new ApiService();

    getHistory();
  }

  Future<bool> _onBackPressed() {
    return Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (context) => new HomePage(_token),
        fullscreenDialog: true,
        maintainState: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: backgroundColor,
        body: Stack(
          children: <Widget>[
            topAppBar,
            dashboard(context),
          ],
        ),
      ),
    );
  }

  ListTile makeListTile(History history) => ListTile(
        contentPadding: EdgeInsets.only(top: 10.0, left: 10),
        title: Row(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsetsDirectional.only(end: 25.0),
              child: new Icon(MyFlutterApp.MyFlutterApp.barcode),
            ),
            Text(
              history.barcode.toString(),
              //textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontFamily: 'Athletic',
                  fontSize: 30,
                  letterSpacing: 2.5),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Text(
              history.date
                  .toString()
                  .substring(0, history.date.toString().length - 4),
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.orange)),
        ),
        onTap: () {},
      );

  Card makeCard(History history) => Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[50].withOpacity(1.0),
          ),
          child: makeListTile(history),
        ),
      );

  Widget dashboard(context) {
    // final makeBottom = BottomNavyBar(
    //   selectedIndex: _selectedIndex,       
    //   showElevation: true, // use this to remove appBar's elevation
    //   onItemSelected: (index) => setState(() {
    //         _selectedIndex = index;
    //        _pageController.animateToPage(index,
    //             duration: Duration(milliseconds: 300), curve: Curves.ease);
    //       }),
    //   items: [
    //     BottomNavyBarItem(
    //       icon: Icon(Icons.apps),
    //       title: Text('Historique'),
    //       activeColor: Color.fromRGBO(55, 230, 199, 1.0),
    //     ),
    //     //  BottomNavyBarItem(
    //     //      icon: Icon(Icons.people),
    //     //      title: Text('Users'),
    //     //      activeColor: Colors.purpleAccent
    //     //  ),
    //     BottomNavyBarItem(
    //         icon: Icon(Icons.home),
    //         title: Text('Home'),
    //         activeColor: Colors.pink),
    //     //  BottomNavyBarItem(
    //     //      icon: Icon(Icons.settings),
    //     //      title: Text('Settings'),
    //     //      activeColor: Colors.blue
    //     //  ),
    //   ],
    // );
    // final makeBottom = Container(
    //   height: 55.0,
    //   child: BottomAppBar(
    //     color: Color.fromRGBO(55, 230, 199, 1.0),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: <Widget>[
    //         IconButton(
    //           icon: Icon(Icons.home, color: Colors.black,size: 30,),
    //           onPressed: () {
    //             Navigator.of(context).pushReplacement(
    //               new MaterialPageRoute(
    //                 builder: (context) => new HomePage(_token),
    //                 fullscreenDialog: true,
    //                 maintainState: false,
    //               ),
    //             );
    //           },
    //         ),
    //         IconButton(
    //           icon: Icon(Icons.history, color: Colors.black,size: 30,),
    //           onPressed: () {},
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    final makeBody = Container(
      decoration: BoxDecoration(
        color: Colors.purple[50],
      ), ///////////////////////////

      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _histories.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(_histories[index]);
        },
      ),
    );

    return Material(
      elevation: 20,
      child: Scaffold(
        //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),

        backgroundColor: Colors.purple[50],

        appBar: topAppBar,
        body: makeBody,
        //bottomNavigationBar: makeBottom,

        //color: backgroundColor,
        //color:Colors.white,
      ),
    );
  }

  final topAppBar = AppBar(
    elevation: 0.1,
    backgroundColor: Color.fromRGBO(55, 230, 199, 1.0),
    title: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        /*InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 40.0, top: 4, bottom: 8,left: 10),
                                        child: Icon(
                                          Icons.arrow_back,
                                          size: 35,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),*/
        //SizedBox(width: 20.0),
        Text(
          'Mon Historique',
          style: new TextStyle(
            color: Colors.black,
            fontFamily: 'Pacifico',
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 5,
          ),
        ),
      ],
    ),
    actions: <Widget>[
      /*IconButton(
                                      icon: Icon(Icons.list),
                                      onPressed: () {},
                                    ),*/
    ],
  );

  getHistory() async {
    try {
      final history = await _apiService.workerHistory(_token);
      print("History");
      print(history);
      setState(() {
        _histories = history;
      });
    } on MyHttpException catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(e.message)),
      );
    } catch (e) {
      print("excepshit " + e.toString());
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text('Unknown error occurred hm'),
      ));
    }
  }


}
