import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungtanfun/states/my_service.dart';
import 'package:ungtanfun/states/register.dart';
import 'package:ungtanfun/utility/dialog.dart';
import 'package:ungtanfun/utility/my_style.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool statusRedEye = true;
  bool statusLogin = true; // true => Check Process
  String email, password;
  TextEditingController emailController, passwordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProcess();

    emailController = TextEditingController();
    emailController.addListener(() {
      email = emailController.text;
    });

    passwordController = TextEditingController();
    passwordController.addListener(() {
      password = passwordController.text;
    });
  }

  Future<Null> checkProcess() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event != null) {
          routeToService();
        } else {
          setState(() {
            statusLogin = false;
          });
        }
      });
    });
  }

  void routeToService() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MyService(),
        ),
        (route) => false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: statusLogin ? MyStyle().showProgress() : buildContent(),
    );
  }

  Container buildContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 1.0,
          center: Alignment(0, -0.3),
          colors: [Colors.white, MyStyle().primaryColor],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              child: MyStyle().showLogo(),
            ),
            MyStyle().showTitleH1('Ung Tan Fun'),
            buildUser(),
            buildPassword(),
            buildLogin(),
            buildTextButton(),
          ],
        ),
      ),
    );
  }

  TextButton buildTextButton() => TextButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Register(),
            )),
        child: Text('New Register'),
      );

  Container buildLogin() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: RaisedButton(
        color: MyStyle().darkColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onPressed: () {
          print('email = $email, password = $password');
          if (email == null ||
              email.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'Have Space ? Please Fill Every Blank');
          } else {
            checkAuthen();
          }
        },
        child: Text(
          'Login',
          style: MyStyle().whiteText(),
        ),
      ),
    );
  }

  Container buildUser() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: MyStyle().lightColor,
        borderRadius: BorderRadius.circular(20),
      ),
      width: 250,
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.email),
          hintText: 'Email :',
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: MyStyle().lightColor,
        borderRadius: BorderRadius.circular(20),
      ),
      width: 250,
      child: TextField(
        controller: passwordController,
        obscureText: statusRedEye,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye),
            onPressed: () {
              setState(() {
                statusRedEye = !statusRedEye;
              });
            },
          ),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.lock),
          hintText: 'Password :',
        ),
      ),
    );
  }

  Future<Null> checkAuthen() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => routeToService())
          .catchError((value) {
        normalDialog(context, value.message);
      });
    });
  }
}
