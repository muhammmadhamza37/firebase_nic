import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_nic/screens/login_screen.dart';
import 'package:firebase_nic/screens/register_screen.dart';
import 'package:firebase_nic/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameC, mobileC, emailC, passwordC;
  String? selectedGender;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    nameC = TextEditingController();
    mobileC = TextEditingController();
    emailC = TextEditingController();
    passwordC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameC.dispose();
    mobileC.dispose();
    emailC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.1;
    final width = MediaQuery.sizeOf(context).width * 0.1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameC,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                    hintStyle: TextStyle(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter name';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: height * .3,
                ),
                TextFormField(
                  controller: mobileC,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Mobile',
                    prefixIcon: Icon(Icons.phone),
                    hintStyle: TextStyle(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter mobile no';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: height * .3,
                ),
                TextFormField(
                  controller: emailC,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_rounded),
                    hintStyle: TextStyle(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter email';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: height * .3,
                ),
                TextFormField(
                  controller: passwordC,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.admin_panel_settings_sharp),
                    hintStyle: TextStyle(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter password';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: height * .3,
                ),
                CupertinoSegmentedControl<String>(
                    groupValue: selectedGender,
                    children: const {
                      'Male': Text('Male'),
                      'Female': Text('Female'),
                    },
                    onValueChanged: (newValue) {
                      setState(() {
                        selectedGender = newValue;
                      });
                    }),
                SizedBox(height: height *.3),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        UserCredential? userCredentials =
                            await auth.createUserWithEmailAndPassword(
                          email: emailC.text.trim(),
                          password: passwordC.text.trim(),
                        );

                        if (userCredentials.user != null) {
                          // save other info in firestore

                          FirebaseFirestore firebaseFirestore =
                              FirebaseFirestore.instance;

                          await firebaseFirestore
                              .collection('users')
                              .doc(userCredentials.user!.uid)
                              .set({
                            'name': nameC.text.trim(),
                            'mobile': mobileC.text.trim(),
                            'gender': selectedGender,
                            'email': emailC.text.trim(),
                            'uid': userCredentials.user!.uid,
                            'createdOn': DateTime.now().millisecondsSinceEpoch,
                            'photo': null,
                          });
                        }

                        Utils().toastMessage('Success');
                      } on FirebaseAuthException catch (e) {
                        print(e.code);
                        print(e.message!);

                        Fluttertoast.showToast(msg: e.message!, fontSize: 15);
                      }
                    },
                    child: Text('Register')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have account?'),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Login')),
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
