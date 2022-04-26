import 'dart:io';
import 'dart:math';

import 'package:firebase_demo/firebase_service/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../firebase_service/firebase_auth_service.dart';
import 'constant.dart';
import 'enter_mob.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'notes.dart';
import 'package:image_picker/image_picker.dart';

class Register_Screen extends StatefulWidget {
  const Register_Screen({Key? key}) : super(key: key);

  @override
  _Register_ScreenState createState() => _Register_ScreenState();
}

class _Register_ScreenState extends State<Register_Screen> {
  bool click = false;
  bool show = true;
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final picker = ImagePicker();

  File? _image;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  } //phone memory mathi photo select karva(1st step)

  Future<String?> uploadFile({File? file, String? filename}) async {
    print("file path===>>$file");
    try {
      var response = await storage.ref("filename==>>$filename").putFile(file!);

      return response.storage.ref("filename==>>$filename").getDownloadURL();
    } on firebase_storage.FirebaseException catch (e) {
      print(e);
    }
  } //upload file mate(2nd step)

  Future addUser() async {
    String? imageUrl = await uploadFile(
        file: _image!,
        filename:
            "${Random().nextInt(1000)}${kFirebaseAuth.currentUser!.email}");

    userCollection.doc(kFirebaseAuth.currentUser!.uid).set({
      "email": _email.text,
      "password": _password.text,
      "avatar": imageUrl
    }).catchError((e) {
      print("ERROR==>>>$e");
    });
  } // userdata add karavva

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        getImage();
                      },
                      child: Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300),
                        child: ClipOval(
                          child: _image == null
                              ? Image.network(
                                  "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg",
                                  fit: BoxFit.fill,
                                )
                              : Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.sp,
                    ),
                    Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    ),
                    SizedBox(
                      height: 25.sp,
                    ),
                    Text(
                      'Login with one of following options',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 20.sp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            signInWithGoogle().then((value) =>
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen())));
                          },
                          child: Container(
                            height: 9.h,
                            width: 30.w,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              border: Border.all(color: Colors.grey.shade700),
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage('assets/photo/google.png'),
                                scale: 1,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 9.h,
                            width: 30.w,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              border: Border.all(color: Colors.grey.shade700),
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage('assets/photo/facebook.png'),
                                scale: 3,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EnterMob()));
                          },
                          child: Container(
                            height: 9.h,
                            width: 30.w,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              border: Border.all(color: Colors.grey.shade700),
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage('assets/photo/ph.png'),
                                scale: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25.sp,
                    ),
                    Container(
                      height: 8.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(40)),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: _email,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email Address',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.pink, width: 3),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.sp,
                    ),
                    Container(
                      height: 8.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(40)),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: _password,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            splashRadius: 20,
                            onPressed: () {
                              setState(() {
                                show = !show;
                              });
                            },
                            icon: Icon(
                              Icons.visibility,
                              color: Colors.grey,
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: 'Enter Your Password',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.pink, width: 3),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.sp,
                    ),
                    GestureDetector(
                      onTap: () async {
                        bool status = await FirebaseAuthServices.signUp(
                            email: _email.text, password: _password.text);
                        if (status == true) {
                          SharedPreferences setData =
                              await SharedPreferences.getInstance();
                          setData.setString('Email', _email.text).then(
                                (value) => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Notes(),
                                  ),
                                ),
                              );
                          addUser();
                        }
                      },
                      child: Container(
                        height: 45.sp,
                        width: 90.w,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.pink, Colors.purple]),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t Have An Account ?',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScr(),
                                ));
                          },
                          child: Text(
                            '  Login',
                            style: TextStyle(
                                fontSize: 17, color: Colors.redAccent),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
