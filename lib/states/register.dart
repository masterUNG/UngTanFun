import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ungtanfun/models/user_model.dart';
import 'package:ungtanfun/utility/dialog.dart';
import 'package:ungtanfun/utility/my_style.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  File file;
  String name, email, password, uid, avatar;
  bool statusUpload = true; // true => Not Show Progress

  Container buildName() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: MyStyle().lightColor,
        borderRadius: BorderRadius.circular(20),
      ),
      width: 250,
      child: TextField(
        onChanged: (value) => name = value.trim(),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.fingerprint),
          hintText: 'Name :',
        ),
      ),
    );
  }

  Container buildEmail() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: MyStyle().lightColor,
        borderRadius: BorderRadius.circular(20),
      ),
      width: 250,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => email = value.trim(),
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
        onChanged: (value) => password = value.trim(),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.lock),
          hintText: 'Password :',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildIconButton()],
        backgroundColor: MyStyle().primaryColor,
        title: Text('Register'),
      ),
      body: Stack(
        children: [
          buildContent(),
          statusUpload ? SizedBox() : MyStyle().showProgress()
        ],
      ),
    );
  }

  Center buildContent() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildRowImage(),
            buildName(),
            buildEmail(),
            buildPassword(),
          ],
        ),
      ),
    );
  }

  IconButton buildIconButton() => IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        if (file == null) {
          normalDialog(context, 'No Avatar ? Please Choose Avatar ');
        } else if (name == null ||
            name.isEmpty ||
            email == null ||
            email.isEmpty ||
            password == null ||
            password.isEmpty) {
          normalDialog(context, 'Have Space ? Plese Fill Every Blank');
        } else {
          registerAuthen();
        }
      });

  Future<Null> registerAuthen() async {
    setState(() {
      statusUpload = false;
    });
    await Firebase.initializeApp().then((value) async {
      print('Initialize Success');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        uid = value.user.uid;
        print('Register Success uid = $uid');
        uploadImage();
      }).catchError((value) {
        normalDialog(context, value.message);
      });
    });
  }

  Future<Null> uploadImage() async {
    int i = Random().nextInt(1000000);
    String nameImage = '$uid$i.jpg';

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('avatar/$nameImage');
    UploadTask task = reference.putFile(file);
    await task.whenComplete(() async {
      await reference.getDownloadURL().then((value) {
        avatar = value;
        print('avatar = $avatar');
        insertData();
      });
    });
  }

  Future<Null> insertData() async {
    setState(() {
      statusUpload = true;
    });

    UserModel model =
        UserModel(avatar: avatar, email: email, name: name, password: password);
    Map<String, dynamic> data = model.toMap();

    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .set(data)
        .then((value) => Navigator.pop(context));
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker()
          .getImage(source: source, maxWidth: 800, maxHeight: 800);
      setState(() {
        file = File(result.path);
      });
    } catch (e) {}
  }

  Row buildRowImage() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseImage(ImageSource.camera),
          ),
          Container(
            width: 250,
            height: 250,
            child: file == null
                ? Image.asset('images/avatar.png')
                : Image.file(file),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseImage(ImageSource.gallery),
          ),
        ],
      );
}
