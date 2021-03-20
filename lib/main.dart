import 'package:church_backoffice/screens/login.dart';
import 'package:church_backoffice/screens/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'components/layout.dart';
import 'components/section.dart';
import 'components/side_nav.dart';

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
      var userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );
      await userCred.user.sendEmailVerification();
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
    }

    return Layout(
      onLogoutPressed: logout,
      sideNavItems: [
        NavItem("Sermons", Icon(Icons.plus_one), () => {}),
      ],
      content: getSermonsScreen(),
    );
  }

  void onSermonTap(id, context) {}

  Widget getSermonsScreen() {
    CollectionReference sermons = FirebaseFirestore.instance.collection('sermons');

    return StreamBuilder<QuerySnapshot>(
      stream: sermons.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ' + snapshot.error.toString()),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Loading'));
        }

        return Section(
          title: "Sermons",
          actions: [
            IconButton(icon: Icon(Icons.create), onPressed: () => {}),
            IconButton(icon: Icon(Icons.update), onPressed: () => {}),
            IconButton(icon: Icon(Icons.delete), onPressed: () => {}),
          ],
          content: ListView(
              children: snapshot.data.docs
                  .map(
                    (it) => ListTile(
                      leading: FadeInImage(
                        placeholder: AssetImage("assets/images/thumbnail_placeholder.png"),
                        image: NetworkImage(it.data()['thumbnailUrl']),
                      ),
                      title: Text(it.data()['title']),
                      subtitle: Text(it.data()['author']),
                      trailing: Icon(Icons.play_arrow),
                      onTap: () => onSermonTap(it.id, context),
                    ),
                  )
                  .toList()),
        );
      },
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
