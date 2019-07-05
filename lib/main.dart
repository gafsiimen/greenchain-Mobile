import 'dart:async';

import 'package:flutter/material.dart';
import 'package:node_auth/CoachProfile.dart';
import 'package:node_auth/api_service.dart';
import 'package:node_auth/home.dart';
import 'package:node_auth/CoachDashboard3.dart';
import 'package:node_auth/register.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
//import 'package:http/http.dart' as http;

void main() {
  Stetho.initialize();

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData.light(),
      home: new LoginPage(),
      routes: {
        '/register_page': (context) => new RegisterPage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => new _MyLoginPageState();
}

class _MyLoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  String _email, _password;
  static const String emailRegExpString =
      r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9][a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
  static final RegExp emailRegExp =
      new RegExp(emailRegExpString, caseSensitive: false);
  bool _obscurePassword = true;
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  AnimationController _loginButtonController;
  Animation<double> _buttonSqueezeAnimation;

  ApiService apiService;

  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    _buttonSqueezeAnimation = new Tween(
      begin: 320.0,
      end: 70.0,
    ).animate(new CurvedAnimation(
        parent: _loginButtonController, curve: new Interval(0.0, 0.250)))
      ..addListener(() {
        debugPrint(_buttonSqueezeAnimation.value.toString());
        setState(() {});
      });
    apiService = new ApiService();
  }

  @override
  void dispose() {
    super.dispose();
    _loginButtonController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jalal = new Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
            child: Text('Hello',
                style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(11.0, 75.0, 0.0, 0.0),
            child: Text('There',
                style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold)),
          ),
          Stack(
            alignment: const Alignment(0.95, 0.6),
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
                height: 120,
                width: 120,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(220.0, 75.0, 0.0, 0.0),
            child: Text('.',
                style: TextStyle(
                    fontSize: 80.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
          )
        ],
      ),
    );

    final emailTextField = new TextFormField(
      autocorrect: true,
      autovalidate: false,
      decoration: new InputDecoration(
        prefixIcon: new Padding(
          padding: const EdgeInsetsDirectional.only(end: 8.0),
          child: new Icon(Icons.email),
        ),
        labelText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
      maxLines: 1,
      style: new TextStyle(fontSize: 16.0),
      onSaved: (s) => _email = s,
      validator: (s) =>
          emailRegExp.hasMatch(s) ? null : 'Invalid email address!',
    );

    final passwordTextField = new TextFormField(
      autocorrect: true,
      autovalidate: false,
      obscureText: _obscurePassword,
      decoration: new InputDecoration(
        suffixIcon: new IconButton(
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          icon: new Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility),
          iconSize: 18.0,
        ),
        labelText: 'Password',
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

    final loginButton = new Container(
      width: _buttonSqueezeAnimation.value,
      height: 60.0,
      child: new Material(
        elevation: 5.0,
        shadowColor: Theme.of(context).accentColor,
        borderRadius: new BorderRadius.circular(24.0),
        child: _buttonSqueezeAnimation.value > 75.0
            ? new MaterialButton(
                onPressed: _login,
                color: Theme.of(context).backgroundColor,
                child: new Text(
                  'LOGIN',
                  style: new TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                splashColor: new Color(0xFF00e676),
              )
            : new Container(
                padding:
                    new EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: new CircularProgressIndicator(
                  strokeWidth: 4.0,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
      ),
    );

    /*final needAnAccount = new FlatButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/register_page');
      },
      child: new Text(
        "Don't have an account? Sign up",
        style: new TextStyle(
          color: Colors.white70,
          fontStyle: FontStyle.italic,
          fontSize: 14.0,
        ),
      ),
    );*/

    return new Scaffold(
      //resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: new Form(
            key: _formKey,
            autovalidate: true,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom:8),
                                  child: new Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: jalal,
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: emailTextField,
                ),
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: passwordTextField,
                ),
                // new SizedBox(height: 32.0),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: loginButton,
                  ),
                ),
                /*new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: needAnAccount,
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: forgotPassword,
                  ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    if (!_formKey.currentState.validate()) {
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text('Invalid information')),
      );
      return;
    }

    _formKey.currentState.save();
    _loginButtonController.reset();
    _loginButtonController.forward();

    apiService.signIn(_email, _password).then((Login login) {
      print('shit works');
      _loginButtonController.reset();
      //print(response);
      /*_loginButtonController.reverse();*/

      if (login.code == 200) {
        if (login.role == 'worker') {
          Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
              builder: (context) => new HomePage(login.access_token),
              fullscreenDialog: true,
              maintainState: false,
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
          builder: (context) => new CoachDashboard3(login.access_token),
          fullscreenDialog: true,
          maintainState: false,
        ),
      );
        }
      } else if (login.code == 404) {
        _loginButtonController.reset();

        final message = 'Email/Password incorrects';

        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text(message)),
        );
      } else if (login.code == 403) {
        _loginButtonController.reset();

        final message = 'Vous n"etes pas autorisé';

        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text(message)),
        );
      } else if (login.code == 401) {
        _loginButtonController.reset();

        final message = 'Merci d"attendre la confirmation';

        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text(message)),
        );
      } else {
        _loginButtonController.reset();

        final message = 'Unknown error occurred';

        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text(message)),
        );
      }
      _loginButtonController.reset();
    });
  }

  _resetPassword() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return new ResetPasswordDialog();
      },
    );
  }
}

class ResetPasswordDialog extends StatefulWidget {
  @override
  _ResetPasswordDialogState createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  String _email, _token, _newPassword, role;

  final _formKey = new GlobalKey<FormState>();
  final ApiService _apiService = new ApiService();

  bool _isInit;
  bool _obscurePassword;
  bool _isLoading;
  String _message;

  @override
  void initState() {
    super.initState();
    _isInit = true;
    _obscurePassword = true;
    _isLoading = false;
    _message = null;
  }

  @override
  Widget build(BuildContext context) {
    final emailTextField = new TextFormField(
      autocorrect: true,
      autovalidate: false,
      decoration: new InputDecoration(
        prefixIcon: new Padding(
          padding: const EdgeInsetsDirectional.only(end: 8.0),
          child: new Icon(Icons.email),
        ),
        labelText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
      maxLines: 1,
      style: new TextStyle(fontSize: 16.0),
      onSaved: (s) => _email = s,
      validator: (s) => _MyLoginPageState.emailRegExp.hasMatch(s)
          ? null
          : 'Invalid email address!',
    );

    final tokenTextField = new TextFormField(
      autocorrect: true,
      autovalidate: false,
      decoration: new InputDecoration(
        prefixIcon: new Padding(
          padding: const EdgeInsetsDirectional.only(end: 8.0),
          child: new Icon(Icons.email),
        ),
        labelText: 'Token',
      ),
      keyboardType: TextInputType.emailAddress,
      maxLines: 1,
      style: new TextStyle(fontSize: 16.0),
      onSaved: (s) => _token = s,
    );

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
        labelText: 'Password',
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

    return new AlertDialog(
      title: new Text('Reset password'),
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Form(
              autovalidate: true,
              key: _formKey,
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: emailTextField,
                  ),
                  _isInit
                      ? new Container()
                      : new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: tokenTextField,
                        ),
                  _isInit
                      ? new Container()
                      : new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: passwordTextField,
                        ),
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _isLoading
                        ? new CircularProgressIndicator()
                        : _message != null
                            ? new Text(
                                _message,
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.amber,
                                ),
                              )
                            : new Container(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text('OK'),
          onPressed: _onPressed,
        ),
      ],
    );
  }

  _onPressed() {
    if (!_formKey.currentState.validate()) {
      setState(() => _message = 'Invalid information');
      new Future.delayed(Duration(seconds: 1))
          .then((_) => setState(() => _message = null));
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_isInit) {
      _sendResetEmail();
    } else {
      _resetPassword();
    }
  }

  _sendResetEmail() {
    print("send reset email...");

    _apiService.resetPassword(_email).then((response) {
      setState(() {
        _isInit = _isLoading = false;
        _message = response.message;
      });
      new Future.delayed(Duration(seconds: 1))
          .then((_) => setState(() => _message = null));
    }).catchError((e) {
      final message =
          e is MyHttpException ? e.message : "An unknown error occurred";
      setState(() {
        _isLoading = false;
        _message = message;
      });
      new Future.delayed(Duration(seconds: 1))
          .then((_) => setState(() => _message = null));
    });
  }

  _resetPassword() {
    print("reset password...");

    _apiService
        .resetPassword(_email, newPassword: _newPassword, token: _token)
        .then((response) {
      setState(() {
        _isLoading = false;
        _isInit = true;
        _message = response.message;
      });
      new Future.delayed(Duration(seconds: 1))
          .then((_) => Navigator.of(context).pop());
    }).catchError((e) {
      final message =
          e is MyHttpException ? e.message : "An unknown error occurred";
      setState(() {
        _isLoading = false;
        _message = message;
      });
      new Future.delayed(Duration(seconds: 1))
          .then((_) => setState(() => _message = null));
    });
  }
}
