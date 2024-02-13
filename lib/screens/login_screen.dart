
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_nic/screens/register_screen.dart';
import 'package:firebase_nic/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dashboard_screen.dart';
import 'email_verification_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  final _formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final mobileC = TextEditingController();
  final emailC  = TextEditingController();
  final passwordC = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    nameC.dispose();
    mobileC.dispose();
    emailC.dispose();
    passwordC.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.1;
    final width  = MediaQuery.sizeOf(context).width  *0.1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginScreen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailC,
                decoration: InputDecoration(
                  hintText: '@gmail.com',
                  labelText: 'Email',
                  hintStyle: TextStyle(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                validator: (value){
                  if (value!.isEmpty){
                    return 'enter email';
                  }else{
                    return null;
                  }
                },
              ),
                SizedBox(
                  height: height *.3,
                ),
              TextFormField(
                controller: passwordC,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintStyle: TextStyle(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                validator: (value){
                  if (value!.isEmpty){
                    return 'enter password';
                  }else{
                    return null;
                  }
                },
              ),

              SizedBox(
                height: height *.3,
              ),


              ElevatedButton(onPressed: ()async{


                try{
                  FirebaseAuth auth = FirebaseAuth.instance;

                  UserCredential userC = await auth.signInWithEmailAndPassword(
                      email: emailC.text.trim(), password: passwordC.text.trim());

                  if( userC.user!.emailVerified){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){

                      return const DashboardScreen();
                    }));
                  }else {

                    Navigator.of(context).push(MaterialPageRoute(builder: (context){

                      return const EmailVerificationScreen();
                    }));
                  }




                }
                on FirebaseAuthException catch (e ){

                  // you can display custom messages
                  if( e.code == 'user-not-found'){

                  }

                  Fluttertoast.showToast(msg: e.message!);
                }




              }, child: Text('Login')),

              SizedBox(
                height: height *.3,
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 const  Text("Don't have account?",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                  TextButton(onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return const RegisterScreen();
                    }));
                  } , child: const Text('Register')),

                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
