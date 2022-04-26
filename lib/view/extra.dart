import 'dart:io';
import 'dart:math';
import 'package:firebase_demo/firebase_service/firebase_auth_service.dart';
import 'package:firebase_demo/view/constant.dart';
import 'package:firebase_demo/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EmailSignUp extends StatefulWidget {
  const EmailSignUp({Key? key}) : super(key: key);

  @override
  State<EmailSignUp> createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  bool showPass = true;
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final picker = ImagePicker();

  File? _image;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadFile(File file, String filename) async {
    print("File path:${file.path}");
    try {
      var response = await firebase_storage.FirebaseStorage.instance
          .ref("user_image/$filename")
          .putFile(file);
      return response.storage.ref("user_image/$filename").getDownloadURL();
    } on firebase_storage.FirebaseException catch (e) {
      print(e);
    }
  }

  Future addUserData() async {
    String? imageUrl = await uploadFile(_image!,
        "${Random().nextInt(1000)}${kFirebaseAuth.currentUser!.email}");

    userCollection.doc(kFirebaseAuth.currentUser!.uid).set({
      "email": _email.text,
      "password": _pass.text,
      "avatar": imageUrl
    }).catchError((e) {
      print("ERROR==>>>$e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                    height: 170,
                    width: 170,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey.shade300),
                    child: ClipOval(
                      child: _image == null
                          ? Image.network(
                              "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg",
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Email';
                    }
                  },
                  controller: _email,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Password';
                    }
                  },
                  controller: _pass,
                  obscureText: showPass,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        setState(() {
                          showPass = !showPass;
                        });
                      },
                      icon: showPass
                          ? const Icon(
                              Icons.visibility_outlined,
                              size: 20,
                            )
                          : const Icon(
                              Icons.visibility_off_outlined,
                              size: 20,
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      SharedPreferences email =
                          await SharedPreferences.getInstance();
                      bool? status = await FirebaseAuthServices.signUp(
                        email: _email.text,
                        password: _pass.text,
                      );
                      if (status == true) {
                        email.setString('email', _email.text);
                        await addUserData().then(
                          (value) => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Register'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
