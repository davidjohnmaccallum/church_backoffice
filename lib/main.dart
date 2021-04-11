import 'package:church_backoffice/screens/forgot_password.dart';
import 'package:church_backoffice/screens/forgot_password_email_sent.dart';
import 'package:church_backoffice/screens/login.dart';
import 'package:church_backoffice/screens/register.dart';
import 'package:church_backoffice/screens/series.dart';
import 'package:church_backoffice/screens/sermon_detail.dart';
import 'package:church_backoffice/screens/sermon_form.dart';
import 'package:church_backoffice/screens/sermons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'components/layout.dart';
import 'components/side_nav.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class NavState {
  final String sideNavKey;
  final String page;
  final String id;
  NavState(this.page, this.sideNavKey, {this.id});
}

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;
  User _user;
  String _loginErrorMessage;
  String _registrationErrorMessage;
  String _passwordResetErrorMessage;
  // NavState navState = NavState("SermonList", "Sermons");
  // NavState navState = NavState("SermonForm", "Sermons", id: "0SRgusYUdOiUADScBFnH");
  NavState navState = NavState("SermonDetail", "Sermons", id: "0SRgusYUdOiUADScBFnH");

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();

      setState(() {
        _initialized = true;
      });

      FirebaseAuth.instance.authStateChanges().listen((User user) {
        setState(() {
          _user = user;
        });
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print("User is signed in! $user");
        }
      });
    } catch (e) {
      print(e);
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  openRegisterScreen(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegistrationForm(
          onRegisterPressed: submitRegistrationForm,
          errorMessage: _registrationErrorMessage,
        ),
      ),
    );
  }

  submitRegistrationForm(RegistrationData data, BuildContext context) async {
    try {
      setState(() {
        _registrationErrorMessage = null;
      });
      var userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );
      await userCred.user.sendEmailVerification();
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _registrationErrorMessage = e.message;
      });
    }
  }

  onLoginPressed(String email, String password) async {
    try {
      setState(() {
        _loginErrorMessage = null;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // if successful will trigger listener above
    } catch (e) {
      setState(() {
        _loginErrorMessage = e.message;
      });
    }
  }

  onForgotEmailSentScreenClosePressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  onSendPasswordResetEmailPressed(String email, BuildContext context) async {
    try {
      setState(() {
        _passwordResetErrorMessage = null;
      });
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ForgotEmailSentScreen(
            onClosePressed: onForgotEmailSentScreenClosePressed,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _loginErrorMessage = e.message;
      });
    }
  }

  onForgotPressed(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ForgotPasswordForm(
          onSendEmailPressed: onSendPasswordResetEmailPressed,
          errorMessage: _registrationErrorMessage,
        ),
      ),
    );
  }

  onLogoutPressed() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }

  Widget getHome() {
    // Show error message if initialization failed
    if (_error) {
      return Scaffold(
        body: Center(
          child: Text("Something went wrong. Please try again."),
        ),
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Scaffold(
        body: Center(
          child: Text("Loading..."),
        ),
      );
    }

    if (_user == null) {
      return LoginScreen(
        onLoginPressed: onLoginPressed,
        onForgotPressed: onForgotPressed,
        onRegisterPressed: openRegisterScreen,
        errorMessage: _loginErrorMessage,
      );
    }

    return Layout(
      onLogoutPressed: onLogoutPressed,
      selectedSideNavItem: navState,
      sideNavItems: [
        NavItem("Sermons", Icon(Icons.plus_one), () {
          setState(() {
            navState = NavState("SermonList", "Sermons");
          });
        }),
        NavItem("Series", Icon(Icons.plus_one), () {
          setState(() {
            navState = NavState("SeriesList", "Series");
          });
        }),
      ],
      content: getContent(),
    );
  }

  Widget getContent() {
    print("${navState.page}/${navState.id}");
    switch (navState.page) {
      case "SeriesList":
        // return navState.id != null ? SeriesDetail(navState.id) : SeriesScreen();
        return SeriesScreen();
      // case "SeriesDetail":
      //   return SeriesDetail(navState.id);
      case "SermonList":
        return SermonsScreen(
          onAdd: () {
            setState(() {
              navState = NavState("SermonForm", "Sermons");
            });
          },
          onRowTap: (String id) {
            setState(() {
              navState = NavState("SermonDetail", "Sermons", id: id);
            });
          },
        );
      case "SermonDetail":
        return SermonDetail(
          id: navState.id,
          onEdit: (String id) {
            setState(() {
              navState = NavState("SermonForm", "Sermons", id: id);
            });
          },
          onClose: () {
            setState(() {
              navState = NavState("SermonList", "Sermons");
            });
          },
        );
      case "SermonForm":
        return SermonForm(
          id: navState.id,
          onClose: (String id) {
            setState(() {
              navState = id != null ? NavState("SermonDetail", "Sermons", id: id) : NavState("SermonList", "Sermons");
            });
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Church Backoffice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: getHome(),
    );
  }
}
