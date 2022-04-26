import 'package:firebase_demo/firebase_service/google_sign_in.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$name"),
            Text("$email"),
            Image.network(
              "$imageUrl",
              height: 200,
              width: 200,
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () async {
                SharedPreferences remove =
                    await SharedPreferences.getInstance();
                signOutGoogle().whenComplete(
                  () => remove.remove('Email').then(
                        (value) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScr(),
                          ),
                        ),
                      ),
                );
              },
              child: Text(
                'LogOut',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              color: Colors.indigo,
            )
          ],
        ),
      ),
    );
  }
}
