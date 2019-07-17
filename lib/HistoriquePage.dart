import 'package:flutter/material.dart';
import 'package:node_auth/api_service.dart';

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
  BorderRadius _borderRadius = BorderRadius.all(Radius.zero);
  ApiService _apiService;
  User _user;
  List<History> _history = [];

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _token = widget.token;
    _apiService = new ApiService();

    getHistory();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          topAppBar,
          dashboard(context),
        ],
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
                  ("http://192.168.1.101:8000/" + trieur?.avatar),
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
        itemCount: _history.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(_history[index]);
        },
      ),
    );
   
    return  Material(
          borderRadius: _borderRadius,
          elevation: 20,
          child: Scaffold(
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
            //borderRadius: _borderRadius,
            appBar: topAppBar,
            body: makeBody,
            bottomNavigationBar: makeBottom,
            
            //color: backgroundColor,
            //color:Colors.white,
          ),
          );
  }
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

        final makeBottom = Container(
      height: 55.0,
      child: BottomAppBar(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
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
            )
          ],
        ),
      ),
    );



  getHistory() async {
    try {
      final history = await _apiService.workerHistory(_token);
      setState(() {
        _history = history;

        debugPrint('addresseeeeeeeeeeeeee ////////');
        debugPrint(_history[0].address);
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
