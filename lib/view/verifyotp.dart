import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/view/constant.dart';

import 'package:firebase_demo/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import 'enter_mob.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({Key? key}) : super(key: key);

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  String? otp;

  Future verifyOtp() async {
    PhoneAuthCredential phoneAuthCredential =
        PhoneAuthProvider.credential(smsCode: otp!, verificationId: code!);
    if (phoneAuthCredential == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enter Valid OTP'),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScr(),
        ),
      );
    }
    kFirebaseAuth.signInWithCredential(phoneAuthCredential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 60.sp,
            ),
            Text(
              'Enter OTP',
              style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
            ),
            SizedBox(
              height: 40.sp,
            ),
            OTPTextField(
              length: 6,
              width: 100.w,
              fieldWidth: 50,
              style: TextStyle(fontSize: 17, color: Colors.white),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.underline,
              onCompleted: (pin) {
                setState(() {
                  otp = pin;
                });
              },
            ),
            SizedBox(
              height: 25.sp,
            ),
            GestureDetector(
              onTap: () async {
                await verifyOtp();
                print(otp);
              },
              child: Container(
                height: 45.sp,
                width: 90.w,
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.pink, Colors.purple]),
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Text(
                    'Verify OTP',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
