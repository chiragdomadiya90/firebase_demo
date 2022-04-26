import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  AnimationController? animation;
  var info;
  @override
  void initState() {
    animation =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    animation!.repeat();
    super.initState();
    getData().whenComplete(
      () => Timer(
        const Duration(seconds: 3),
        () {
          Navigator.pushReplacement(
            (context),
            MaterialPageRoute(
              builder: (context) => info == null ? LoginScr() : HomeScreen(),
            ),
          );
        },
      ),
    );
  }

  Future getData() async {
    SharedPreferences get = await SharedPreferences.getInstance();
    var set = get.getString('Email');
    setState(() {
      info = set;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: animation!.view,
              builder: (context, child) {
                return Transform.rotate(
                  angle: animation!.value * 2 * pi,
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/2.svg',
                        height: 150.sp,
                        width: 150.sp,
                      ),
                      const Positioned(
                          top: 80,
                          left: 70,
                          child: Text(
                            'D',
                            style: TextStyle(
                                fontSize: 70,
                                color: Colors.blue,
                                fontWeight: FontWeight.w900),
                          )),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
