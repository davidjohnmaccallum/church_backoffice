import 'package:church_backoffice/screens/login.dart';
import 'package:church_backoffice/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'components/layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
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
  String _registrationErrorMessage;
  String _loginErrorMessage;

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
        ),
      ),
    );
  }

  submitRegistrationForm(RegistrationData data) async {
    try {
      setState(() {
        _registrationErrorMessage = null;
      });
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );
    } catch (e) {
      setState(() {
        _registrationErrorMessage = e.message;
      });
    }
  }

  login(String email, String password) async {
    try {
      setState(() {
        _loginErrorMessage = null;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      setState(() {
        _loginErrorMessage = e.message;
      });
    }
  }

  logout() async {
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
        onLoginPressed: login,
        onRegisterPressed: openRegisterScreen,
        errorMessage: _loginErrorMessage,
      );
      // return RegistrationForm(
      //   onRegisterPressed: submitRegistrationForm,
      //   errorMessage: _registrationErrorMessage,
      // );
    }

    return Layout(
      onLogoutPressed: logout,
    );
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
