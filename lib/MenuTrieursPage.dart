import 'package:flutter/material.dart';
import 'package:node_auth/MenuDashboardPage.dart';
import 'package:node_auth/MenuProfilePage.dart';
import 'package:node_auth/main.dart';
//import 'package:node_auth/trieur.dart';
import 'package:node_auth/detail_page.dart';
import 'package:node_auth/api_service.dart';

import 'GorgeousLogin.dart';

final Color backgroundColor = Color(0xFF4A4A58);
var darkGreenColor = Color(0xff279152);

class MenuTrieursPage extends StatefulWidget {
  final String token;
  MenuTrieursPage(this.token);
  @override
  _MenuTrieursPageState createState() => _MenuTrieursPageState();
}

class _MenuTrieursPageState extends State<MenuTrieursPage>
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
  List<User> _trieurs = [];
   get baseUrl => _apiService.baseUrl;

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
    gettrieurs();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


Future<bool> _onBackPressed() {
   return Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(
                    builder: (context) => new MenuProfilePage(_token),
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
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          menu(context),
          //topAppBar,
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
                          _user!=null ?
                          Text(
                            capitalize(_user?.firstname),
                            style: TextStyle(
                                fontFamily: 'pacifico',
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w500),
                          ): Text(
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

  ListTile makeListTile(User trieur) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
        leading: Container(
          //padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(
                      width: 2.0, color: Color.fromRGBO(55, 230, 199, 1.0)))),
          child: trieur?.avatar != null
              ? Image.network(
                  (baseUrl + trieur?.avatar),
                  fit: BoxFit.contain,
                  width: 90.0,
                  height: 90.0,
                )
              : new Image.asset(
                  'assets/no-avatar.png',
                  width: 90.0,
                  height: 90.0,
                ),
        ),
        title: Text(
          trieur.firstname[0].toUpperCase()+trieur.firstname.substring(1) + 
          ' ' + trieur.lastname[0].toUpperCase()+trieur.lastname.substring(1),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Padding(
                      padding: EdgeInsets.only( top: 5),
                      child: Text(trieur.email[0].toUpperCase()+trieur.email.substring(1), //Trieur
                          style: TextStyle(color: Colors.white))),
                ),],),
                
        
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top:5.0,left: 100,right: 20),
                        child: Container(
                          // tag: 'hero',
                          child: LinearProgressIndicator(
                              backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                              value: trieur.percentage*0.01, //100%
                              valueColor: AlwaysStoppedAnimation(Colors.green)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),         
        
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.blue, size: 40.0),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailPage(trieur,_token)));
        },
      );

  Card makeCard(User trieur) => Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: makeListTile(trieur),
        ),
      );

  Widget dashboard(context) {
    final makeBody = Container(
      //borderRadius: _borderRadius,
      decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _trieurs.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(_trieurs[index]);
        },
      ),
    );
    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                if (isCollapsed) {
                  _borderRadius = BorderRadius.all(Radius.circular(40));
                  _controller.forward();
                } else {
                  _borderRadius = BorderRadius.all(Radius.zero);
                  _controller.reverse();
                }

                isCollapsed = !isCollapsed;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 50.0, top: 4, bottom: 8),
              child: Icon(
                Icons.list,
                size: 35,
                color: Colors.red,
              ),
            ),
          ),
          //SizedBox(width: 20.0),
          Text(
            'Mes Trieurs',
            style: new TextStyle(
              color: Color.fromRGBO(55, 230, 199, 1.0),
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
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.59 * screenWidth,
      right: isCollapsed ? 0 : -0.3 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          borderRadius: _borderRadius,
          elevation: 20,
          child: Scaffold(
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
            //borderRadius: _borderRadius,
            appBar: topAppBar,
            body: makeBody,
            //color: backgroundColor,
            //color:Colors.white,
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
        //debugPrint("getUserInformation $_user");
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

  gettrieurs() async {
    try {
      final trieurs = await _apiService.coachTrieurs(_token);
      setState(() {
        _trieurs = trieurs;

        debugPrint('addresseeeeeeeeeeeeee ////////');
        debugPrint(_trieurs[0].address);
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
