// import 'package:flutter/material.dart';
// import './pages/home.dart';
// import './pages/categories.dart';
// import './pages/search.dart';
// void main() => runApp(new MyApp());
// class MyApp extends StatefulWidget {
//     @override
//     State<StatefulWidget> createState() {
//         return MyAppState();
//     }
// }
// class MyAppState extends State<MyApp> {
//     int _selectedTab = 0;
//     final _pageOptions = [
//         HomePage(),
//         CatPage(),
//         SearchPage(),
//     ];
//     @override
//     Widget build(BuildContext context) {
//         return MaterialApp(
//             theme: ThemeData(
//             primarySwatch: Colors.grey,
//             primaryTextTheme: TextTheme(
//                 title: TextStyle(color: Colors.white),
//             )),
//         home: Scaffold(
//         appBar: AppBar(
//             title: Text('Loopt In'),
//         ),
//         body: _pageOptions[_selectedTab],
//         bottomNavigationBar: BottomNavigationBar(
//             currentIndex: _selectedTab,
//             onTap: (int index) {
//                 setState(() {
//                     _selectedTab = index;
//                 });
//             },
//             items: [
//                 BottomNavigationBarItem(
//                     icon: Icon(Icons.home),
//                     title: Text('Home'),
//                 ),
//                 BottomNavigationBarItem(
//                     icon: Icon(Icons.category),
//                     title: Text('Categories'),
//                 ),
//                 BottomNavigationBarItem(
//                     icon: Icon(Icons.search),
//                     title: Text('Search'),
//                 ),
//             ],
//         ),
//     ),
//     );
// }}

// *********************************************

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'HistoriquePage.dart';
import 'home.dart';
import 'main.dart';

//void main() => runApp(MaterialApp(home: BottomNavBar()));

class BottomNavBar extends StatefulWidget {
  final String token;
  BottomNavBar(this.token);
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  static String _token;
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  void initState() {
    super.initState();

     _token = widget.token; 
     print("_token in BottomNavBar");
     print(_token);
       
  }
  final pageOptions = [
         
                           
         new HomePage(_token),
         
         new HistoriquePage(_token),   
  
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.home, size: 30),
            Icon(Icons.history, size: 30),
            //Icon(Icons.compare_arrows, size: 30),
            // Icon(Icons.call_split, size: 30),
            // Icon(Icons.perm_identity, size: 30),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Color.fromRGBO(55, 230, 199, 1.0),
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 1000),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
         body: pageOptions[_page],
        //Container(
        //   color: Colors.blueAccent,
        //   child: Center(
        //     child: Column(
        //       children: <Widget>[
        //         Text(_page.toString(), textScaleFactor: 10.0),
        //         RaisedButton(
        //           child: Text('Go To Page of index 1'),
        //           onPressed: () {
        //             final CurvedNavigationBarState navBarState =
        //                 _bottomNavigationKey.currentState;
        //             navBarState.setPage(1);
        //           },
        //         )
        //       ],
        //     ),
        //   ),
        // ));
    );
  }
}