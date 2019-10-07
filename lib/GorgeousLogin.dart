import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:node_auth/style/theme.dart' as Theme;
import 'package:node_auth/api_service.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:node_auth/MenuDashboardPage.dart';
import 'package:node_auth/testbottombar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:node_auth/utils/bubble_indication_painter.dart';

class GorgeousLogin extends StatefulWidget {
  GorgeousLogin({Key key}) : super(key: key);

  @override
  _GorgeousLoginState createState() => new _GorgeousLoginState();
}

class _GorgeousLoginState extends State<GorgeousLogin>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  // final FocusNode myFocusNodePassword = FocusNode();
  // final FocusNode myFocusNodeEmail = FocusNode();
  // final FocusNode myFocusNodeName = FocusNode();

  String _email, _password;
  static const String emailRegExpString =
      r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9][a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
  static final RegExp emailRegExp =
      new RegExp(emailRegExpString, caseSensitive: false);

  final _formKey = new GlobalKey<FormState>();
  ApiService apiService;

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  // bool _obscureTextSignup = true;
  // bool _obscureTextSignupConfirm = true;

  // TextEditingController signupEmailController = new TextEditingController();
  // TextEditingController signupNameController = new TextEditingController();
  // TextEditingController signupPasswordController = new TextEditingController();
  // TextEditingController signupConfirmPasswordController =
  //     new TextEditingController();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  get apiUrl => apiService.apiUrl;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= 775.0
                ? MediaQuery.of(context).size.height
                : 775.0,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Theme.Colors.loginGradientStart,
                    Theme.Colors.loginGradientEnd
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 75.0),
                  child: new Image(
                      // width: 250.0,
                      // height: 191.0,
                      width: width * 0.72,
                      height: height * 0.4,
                      fit: BoxFit.fill,
                      // image: new AssetImage('assets/login_logo.png')),
                      image: new AssetImage('assets/logo.png')),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 20.0),
                //   child: _buildMenuBar(context),
                // ),
                Expanded(
                  flex: 2,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) {
                      if (i == 0) {
                        setState(() {
                          right = Colors.white;
                          left = Colors.black;
                        });
                      } else if (i == 1) {
                        setState(() {
                          right = Colors.black;
                          left = Colors.white;
                        });
                      }
                    },
                    children: <Widget>[
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: _buildSignIn(context),
                      ),
                      // new ConstrainedBox(
                      //   constraints: const BoxConstraints.expand(),
                      //   child: _buildSignUp(context),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // myFocusNodePassword.dispose();
    // myFocusNodeEmail.dispose();
    // myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    apiService = new ApiService();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

  // Widget _buildMenuBar(BuildContext context) {
  //   return Container(
  //     width: 300.0,
  //     height: 50.0,
  //     decoration: BoxDecoration(
  //       color: Color(0x552B2B2B),
  //       borderRadius: BorderRadius.all(Radius.circular(25.0)),
  //     ),
  //     child: CustomPaint(
  //       painter: TabIndicationPainter(pageController: _pageController),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: <Widget>[
  //           Expanded(
  //             child: FlatButton(
  //               splashColor: Colors.transparent,
  //               highlightColor: Colors.transparent,
  //               onPressed: _onSignInButtonPress,
  //               child: Text(
  //                 "Existing",
  //                 style: TextStyle(
  //                     color: left,
  //                     fontSize: 16.0,
  //                     fontFamily: "WorkSansSemiBold"),
  //               ),
  //             ),
  //           ),
  //           //Container(height: 33.0, width: 1.0, color: Colors.white),
  //           Expanded(
  //             child: FlatButton(
  //               splashColor: Colors.transparent,
  //               highlightColor: Colors.transparent,
  //               onPressed: _onSignUpButtonPress,
  //               child: Text(
  //                 "New",
  //                 style: TextStyle(
  //                     color: right,
  //                     fontSize: 16.0,
  //                     fontFamily: "WorkSansSemiBold"),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: SingleChildScrollView(
                    child: new Form(
                      key: _formKey,
                      autovalidate: false,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                                left: 25.0,
                                right: 25.0),
                            child: TextFormField(
                              // initialValue: 'worker@example.com',
                              // autovalidate: false,
                              autocorrect: true,
                              focusNode: myFocusNodeEmailLogin,
                              controller: loginEmailController,
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              onSaved: (s) => _email = s,
                              validator: (s) =>
                                  emailRegExp.hasMatch(s) ? null : 
                              'Entrer un Email valide',
                              style: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(
                                  FontAwesomeIcons.envelope,
                                  color: Colors.black,
                                  size: 22.0,
                                ),
                                hintText: "Email Address",
                                hintStyle: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 17.0),
                              ),
                            ),
                          ),
                          Container(
                            width: 250.0,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                                left: 25.0,
                                right: 25.0),
                            child: TextFormField(
                              // initialValue: '123456',
                              autocorrect: true,
                              maxLines: 1,
                              onSaved: (s) => _password = s,
                              validator: (s) => s.length < 6
                                  ? ""//"Minimum length of password is 6"
                                  : null,
                              focusNode: myFocusNodePasswordLogin,
                              controller: loginPasswordController,
                              obscureText: _obscureTextLogin,
                              style: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(
                                  FontAwesomeIcons.lock,
                                  size: 22.0,
                                  color: Colors.black,
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 17.0),
                                suffixIcon: GestureDetector(
                                  onTap: _toggleLogin,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      _obscureTextLogin
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 20.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 170.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.Colors.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Theme.Colors.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: new LinearGradient(
                      colors: [
                        Theme.Colors.loginGradientEnd,
                        Theme.Colors.loginGradientStart
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Theme.Colors.loginGradientEnd,
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: "WorkSansBold"),
                    ),
                  ),
                  onPressed: _login,
                  // showInSnackBar("Login button pressed")
                ),
              ),
            ],
          ),

          // Padding(
          //   padding: EdgeInsets.only(top: 10.0),
          //   child: FlatButton(
          //       onPressed: () {},
          //       child: Text(
          //         "Forgot Password?",
          //         style: TextStyle(
          //             decoration: TextDecoration.underline,
          //             color: Colors.white,
          //             fontSize: 16.0,
          //             fontFamily: "WorkSansMedium"),
          //       )),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(top: 10.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Container(
          //         decoration: BoxDecoration(
          //           gradient: new LinearGradient(
          //               colors: [
          //                 Colors.white10,
          //                 Colors.white,
          //               ],
          //               begin: const FractionalOffset(0.0, 0.0),
          //               end: const FractionalOffset(1.0, 1.0),
          //               stops: [0.0, 1.0],
          //               tileMode: TileMode.clamp),
          //         ),
          //         width: 100.0,
          //         height: 1.0,
          //       ),
          //       Padding(
          //         padding: EdgeInsets.only(left: 15.0, right: 15.0),
          //         child: Text(
          //           "Or",
          //           style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 16.0,
          //               fontFamily: "WorkSansMedium"),
          //         ),
          //       ),
          //       Container(
          //         decoration: BoxDecoration(
          //           gradient: new LinearGradient(
          //               colors: [
          //                 Colors.white,
          //                 Colors.white10,
          //               ],
          //               begin: const FractionalOffset(0.0, 0.0),
          //               end: const FractionalOffset(1.0, 1.0),
          //               stops: [0.0, 1.0],
          //               tileMode: TileMode.clamp),
          //         ),
          //         width: 100.0,
          //         height: 1.0,
          //       ),
          //     ],
          //   ),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Padding(
          //       padding: EdgeInsets.only(top: 10.0, right: 40.0),
          //       child: GestureDetector(
          //         onTap: () => showInSnackBar("Facebook button pressed"),
          //         child: Container(
          //           padding: const EdgeInsets.all(15.0),
          //           decoration: new BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: Colors.white,
          //           ),
          //           child: new Icon(
          //             FontAwesomeIcons.facebookF,
          //             color: Color(0xFF0084ff),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.only(top: 10.0),
          //       child: GestureDetector(
          //         onTap: () => showInSnackBar("Google button pressed"),
          //         child: Container(
          //           padding: const EdgeInsets.all(15.0),
          //           decoration: new BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: Colors.white,
          //           ),
          //           child: new Icon(
          //             FontAwesomeIcons.google,
          //             color: Color(0xFF0084ff),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Future _login() async {
    if (!_formKey.currentState.validate()) {
      // _scaffoldKey.currentState.showSnackBar(
      //   new SnackBar(content: new Text('Invalid information')),
      // );
      showInSnackBar("Format de données invalide");
      return;
    }

    _formKey.currentState.save();
    // _loginButtonController.reset();
    // _loginButtonController.forward();

    String url = Uri.encodeFull(apiUrl + 'auth/Mlogin');
    var body = {'email': _email, 'password': _password};
    try {
      dio.Response response = (await dio.Dio().post(url,
          data: body,
          options: new dio.Options(
              contentType:
                  ContentType.parse("application/x-www-form-urlencoded"))));
      Login login = Login.fromJson(json.decode(response.toString()));
      print('shit works');
      // _loginButtonController.reset();
      print(response);

      if (response.statusCode == 200) {
        if (login.role == 'worker') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', login.access_token);

          Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
              builder: (context) => new BottomNavBar(login.access_token),
              //new WorkerPages(login.access_token),
              //new HomePage(login.access_token),
              fullscreenDialog: true,
              maintainState: false,
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
              builder: (context) => new MenuDashboardPage(login.access_token),
              fullscreenDialog: true,
              maintainState: false,
            ),
          );
        }
      }
    } on dio.DioError catch (e) {
      print('Exception !!!!!!!');
      if (e.response != null) {
        if (e.response.statusCode == 404) {
          // _loginButtonController.reset();
          showInSnackBar("Email/Password incorrect");
          // final message = 'Email/Password incorrect';

          // _scaffoldKey.currentState.showSnackBar(
          //   new SnackBar(content: new Text(message)),
          // );
        } else if (e.response.statusCode == 403) {
          // _loginButtonController.reset();
          showInSnackBar("Vous n'êtes pas autorisé");
          // final message = "Vous n'êtes pas autorisé";

          // _scaffoldKey.currentState.showSnackBar(
          //   new SnackBar(content: new Text(message)),
          // );
        } else if (e.response.statusCode == 401) {
          // _loginButtonController.reset();
          showInSnackBar("Merci d'attendre la confirmation");
          // final message = 'Merci d"attendre la confirmation';

          // _scaffoldKey.currentState.showSnackBar(
          //   new SnackBar(content: new Text(message)),
          // );
        }
      } else {
        showInSnackBar("Vérifier votre connexion internet !");
        // _scaffoldKey.currentState.showSnackBar(
        //   new SnackBar(
        //       content: new Text('Vérifier votre connexion internet !')),
        // );
        // _loginButtonController.reset();
      }
    }
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  // Widget _buildSignUp(BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.only(top: 23.0),
  //     child: Column(
  //       children: <Widget>[
  //         Stack(
  //           alignment: Alignment.topCenter,
  //           overflow: Overflow.visible,
  //           children: <Widget>[
  //             Card(
  //               elevation: 2.0,
  //               color: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8.0),
  //               ),
  //               child: Container(
  //                 width: 300.0,
  //                 height: 360.0,
  //                 child: Column(
  //                   children: <Widget>[
  //                     Padding(
  //                       padding: EdgeInsets.only(
  //                           top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
  //                       child: TextField(
  //                         focusNode: myFocusNodeName,
  //                         controller: signupNameController,
  //                         keyboardType: TextInputType.text,
  //                         textCapitalization: TextCapitalization.words,
  //                         style: TextStyle(
  //                             fontFamily: "WorkSansSemiBold",
  //                             fontSize: 16.0,
  //                             color: Colors.black),
  //                         decoration: InputDecoration(
  //                           border: InputBorder.none,
  //                           icon: Icon(
  //                             FontAwesomeIcons.user,
  //                             color: Colors.black,
  //                           ),
  //                           hintText: "Name",
  //                           hintStyle: TextStyle(
  //                               fontFamily: "WorkSansSemiBold", fontSize: 16.0),
  //                         ),
  //                       ),
  //                     ),
  //                     Container(
  //                       width: 250.0,
  //                       height: 1.0,
  //                       color: Colors.grey[400],
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.only(
  //                           top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
  //                       child: TextField(
  //                         focusNode: myFocusNodeEmail,
  //                         controller: signupEmailController,
  //                         keyboardType: TextInputType.emailAddress,
  //                         style: TextStyle(
  //                             fontFamily: "WorkSansSemiBold",
  //                             fontSize: 16.0,
  //                             color: Colors.black),
  //                         decoration: InputDecoration(
  //                           border: InputBorder.none,
  //                           icon: Icon(
  //                             FontAwesomeIcons.envelope,
  //                             color: Colors.black,
  //                           ),
  //                           hintText: "Email Address",
  //                           hintStyle: TextStyle(
  //                               fontFamily: "WorkSansSemiBold", fontSize: 16.0),
  //                         ),
  //                       ),
  //                     ),
  //                     Container(
  //                       width: 250.0,
  //                       height: 1.0,
  //                       color: Colors.grey[400],
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.only(
  //                           top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
  //                       child: TextField(
  //                         focusNode: myFocusNodePassword,
  //                         controller: signupPasswordController,
  //                         obscureText: _obscureTextSignup,
  //                         style: TextStyle(
  //                             fontFamily: "WorkSansSemiBold",
  //                             fontSize: 16.0,
  //                             color: Colors.black),
  //                         decoration: InputDecoration(
  //                           border: InputBorder.none,
  //                           icon: Icon(
  //                             FontAwesomeIcons.lock,
  //                             color: Colors.black,
  //                           ),
  //                           hintText: "Password",
  //                           hintStyle: TextStyle(
  //                               fontFamily: "WorkSansSemiBold", fontSize: 16.0),
  //                           suffixIcon: GestureDetector(
  //                             onTap: _toggleSignup,
  //                             child: Icon(
  //                               _obscureTextSignup
  //                                   ? FontAwesomeIcons.eye
  //                                   : FontAwesomeIcons.eyeSlash,
  //                               size: 15.0,
  //                               color: Colors.black,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Container(
  //                       width: 250.0,
  //                       height: 1.0,
  //                       color: Colors.grey[400],
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.only(
  //                           top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
  //                       child: TextField(
  //                         controller: signupConfirmPasswordController,
  //                         obscureText: _obscureTextSignupConfirm,
  //                         style: TextStyle(
  //                             fontFamily: "WorkSansSemiBold",
  //                             fontSize: 16.0,
  //                             color: Colors.black),
  //                         decoration: InputDecoration(
  //                           border: InputBorder.none,
  //                           icon: Icon(
  //                             FontAwesomeIcons.lock,
  //                             color: Colors.black,
  //                           ),
  //                           hintText: "Confirmation",
  //                           hintStyle: TextStyle(
  //                               fontFamily: "WorkSansSemiBold", fontSize: 16.0),
  //                           suffixIcon: GestureDetector(
  //                             onTap: _toggleSignupConfirm,
  //                             child: Icon(
  //                               _obscureTextSignupConfirm
  //                                   ? FontAwesomeIcons.eye
  //                                   : FontAwesomeIcons.eyeSlash,
  //                               size: 15.0,
  //                               color: Colors.black,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               margin: EdgeInsets.only(top: 340.0),
  //               decoration: new BoxDecoration(
  //                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //                 boxShadow: <BoxShadow>[
  //                   BoxShadow(
  //                     color: Theme.Colors.loginGradientStart,
  //                     offset: Offset(1.0, 6.0),
  //                     blurRadius: 20.0,
  //                   ),
  //                   BoxShadow(
  //                     color: Theme.Colors.loginGradientEnd,
  //                     offset: Offset(1.0, 6.0),
  //                     blurRadius: 20.0,
  //                   ),
  //                 ],
  //                 gradient: new LinearGradient(
  //                     colors: [
  //                       Theme.Colors.loginGradientEnd,
  //                       Theme.Colors.loginGradientStart
  //                     ],
  //                     begin: const FractionalOffset(0.2, 0.2),
  //                     end: const FractionalOffset(1.0, 1.0),
  //                     stops: [0.0, 1.0],
  //                     tileMode: TileMode.clamp),
  //               ),
  //               child: MaterialButton(
  //                   highlightColor: Colors.transparent,
  //                   splashColor: Theme.Colors.loginGradientEnd,
  //                   //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(
  //                         vertical: 10.0, horizontal: 42.0),
  //                     child: Text(
  //                       "SIGN UP",
  //                       style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 25.0,
  //                           fontFamily: "WorkSansBold"),
  //                     ),
  //                   ),
  //                   onPressed: () =>
  //                       showInSnackBar("SignUp button pressed")),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _onSignInButtonPress() {
  //   _pageController.animateToPage(0,
  //       duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  // }

  // void _onSignUpButtonPress() {
  //   _pageController?.animateToPage(1,
  //       duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  // }

  // void _toggleSignup() {
  //   setState(() {
  //     _obscureTextSignup = !_obscureTextSignup;
  //   });
  // }

  // void _toggleSignupConfirm() {
  //   setState(() {
  //     _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
  //   });
  // }
}
