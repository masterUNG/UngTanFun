import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungtanfun/models/user_model.dart';
import 'package:ungtanfun/states/authen.dart';
import 'package:ungtanfun/states/home.dart';
import 'package:ungtanfun/states/information.dart';
import 'package:ungtanfun/utility/my_style.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  UserModel userModel;
  Widget currentWidget = Home();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        print('uid = $uid');
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .snapshots()
            .listen((event) {
          setState(() {
            userModel = UserModel.fromMap(event.data());
          });
          print('name = ${userModel.name}');
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().primaryColor,
        title: Text(
            userModel == null ? 'Service => ' : 'Service => ${userModel.name}'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                buildListTileHome(),
                buildListTileInformation(),
              ],
            ),
            buildSignOut(context),
          ],
        ),
      ),
      body: currentWidget,
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/wall.jpg'), fit: BoxFit.cover),
        ),
        currentAccountPicture: userModel == null
            ? Image.asset('images/avatar.png')
            : CircleAvatar(
                backgroundImage: NetworkImage(userModel.avatar),
              ),
        accountName: MyStyle()
            .showTitleH1White(userModel == null ? 'Name' : userModel.name),
        accountEmail: Text(userModel == null ? 'Email' : userModel.email));
  }

  ListTile buildListTileHome() {
    return ListTile(
      onTap: () {
        setState(() {
          currentWidget = Home();
        });
        Navigator.pop(context);
      },
      leading: Icon(
        Icons.home,
      ),
      title: Text('List Product'),
    );
  }

  ListTile buildListTileInformation() {
    return ListTile(
      onTap: () {
        setState(() {
          currentWidget = Informaion();
        });
        Navigator.pop(context);
      },
      leading: Icon(
        Icons.info,
      ),
      title: Text('Information'),
    );
  }

  Widget buildSignOut(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            await Firebase.initializeApp().then((value) async {
              await FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Authen(),
                      ),
                      (route) => false));
            });
          },
          tileColor: MyStyle().lightColor,
          leading: Icon(
            Icons.exit_to_app,
            size: 36,
            color: Colors.white,
          ),
          title: MyStyle().showTitleH1White('Sign Out'),
        ),
      ],
    );
  }
}
