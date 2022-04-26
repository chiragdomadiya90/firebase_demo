import 'package:firebase_demo/view/verifyotp.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'constant.dart';

String? code;

class EnterMob extends StatefulWidget {
  const EnterMob({Key? key}) : super(key: key);

  @override
  State<EnterMob> createState() => _EnterMobState();
}

class _EnterMobState extends State<EnterMob> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future sentOtp() async {
    await kFirebaseAuth.verifyPhoneNumber(
      phoneNumber: "+91" + _phoneController.text,
      verificationCompleted: (phoneAuthCredential) {
        print("Verification Completed");
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        setState(() {
          code = verificationId;
        });
      },
      verificationFailed: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$error"),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 60.sp,
                ),
                Text(
                  'Enter Mobile Number',
                  style: TextStyle(
                      fontSize: 25.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: 40.sp,
                ),
                Container(
                  height: 8.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(40)),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "required";
                      } else if (value.length < 10) {
                        return "enter 10 digit number";
                      }
                    },
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    controller: _phoneController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Mobile No.',
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
                  height: 40.sp,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await sentOtp().then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerifyOtp(),
                            ),
                          ));
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
                        'Sent OTP',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already Have An Account ?',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        '  Sign Up',
                        style: TextStyle(fontSize: 17, color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
