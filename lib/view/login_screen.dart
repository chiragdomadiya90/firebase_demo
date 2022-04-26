import 'package:firebase_demo/firebase_service/google_sign_in.dart';
import 'package:firebase_demo/view/constant.dart';
import 'package:firebase_demo/view/enter_mob.dart';
import 'package:firebase_demo/view/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../firebase_service/firebase_auth_service.dart';
import 'home_screen.dart';
import 'notes.dart';

class LoginScr extends StatefulWidget {
  const LoginScr({Key? key}) : super(key: key);

  @override
  _LoginScrState createState() => _LoginScrState();
}

class _LoginScrState extends State<LoginScr> {
  bool click = false;
  final _email = TextEditingController();
  final _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Login ',
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  ),
                  SizedBox(
                    height: 50.sp,
                  ),
                  Text(
                    'Create an account',
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
                              image: AssetImage('assets/photo/facebook.png'),
                              scale: 3,
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
                          borderSide: BorderSide(color: Colors.pink, width: 3),
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
                        border: InputBorder.none,
                        hintText: 'Enter Your Password',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink, width: 3),
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
                      bool status = await FirebaseAuthServices.logIn(
                          email: _email.text, password: _password.text);
                      SharedPreferences setData =
                          await SharedPreferences.getInstance();
                      if (status == true) {
                        setData.setString('Email', _email.text).then(
                              (value) => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Notes(),
                                ),
                              ),
                            );

                        userCollection.doc(kFirebaseAuth.currentUser!.uid).set({
                          "email": _email.text,
                          "password": _password.text,
                        });
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
                          'Register',
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
                        'Already have an account ?',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Register_Screen(),
                              ));
                        },
                        child: Text(
                          '  Sign Up',
                          style:
                              TextStyle(fontSize: 17, color: Colors.redAccent),
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
    );
  }
}
