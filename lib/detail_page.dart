import 'package:flutter/cupertino.dart';
import 'package:node_auth/lesson.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Lesson lesson;
  DetailPage({Key key, this.lesson}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final levelIndicator = Container(
      child: Container(
        child: LinearProgressIndicator(
            backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
            value: lesson.indicatorValue,
            valueColor: AlwaysStoppedAnimation(Colors.green)),
      ),
    );

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
            "Email : mohamedsedkipro@gmail.com",
            style: TextStyle(color: Colors.white, letterSpacing: 0.5),
          ),
          SizedBox(height: 10.0),

          /* new Text(
      "\$" + lesson.price.toString(),
      style: TextStyle(color: Colors.white),
            ),*/

          new Text(
            "Adresse :" + " Avenue 1er mars 5180 abidjan",
            style: TextStyle(color: Colors.white, letterSpacing: 0.5),
          ),
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.bottomRight,
            child: new Text(
              "Tel :" + " 52116170",
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
            Image.asset(
              'assets/no-avatar.png',
              height: 150,
              width: 160,
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Text(
          lesson.title,
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
                      lesson.level,
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
                        print('enter barcode');
                        //_asyncInputDialog(context);
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
                        print('Scan barcode');
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
                        child: new Text('250',
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                color: Color.fromRGBO(55, 230, 199, 1.0),
                                fontFamily: 'Athletic',
                                fontSize: 30.0)),
                      ),
                    )
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
                    SizedBox(height: 55,),
                    Container(
                              width: 80,
                              height: 80,
                              
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                  border: Border.all(
                                    width: 5,
                                    color: Color.fromRGBO(55, 230, 199, 1.0),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: new Text('250',
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                        color: Color.fromRGBO(55, 230, 199, 1.0),
                                        fontFamily: 'Athletic',
                                        fontSize: 30.0)),
                              ),
                            )
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

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[topContent, bottomContent],
        ),
      ),
    );
  }
}
