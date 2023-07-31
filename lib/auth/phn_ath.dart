import 'dart:ffi';

import 'package:chat_app/Widgets/Widgets.dart';
import 'package:chat_app/Widgets/round_button.dart';
import 'package:chat_app/auth/otp_dart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class loginWithPhnNumber extends StatefulWidget {
  const loginWithPhnNumber({super.key});

  @override
  State<loginWithPhnNumber> createState() => _loginWithPhnNumberState();
}

class _loginWithPhnNumberState extends State<loginWithPhnNumber> {
  bool loading=false;
  final auth=FirebaseAuth.instance;
  final phnNumber= TextEditingController();
  String verificationCode="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
        body: Center(
          child: Container(

            color: Colors.orangeAccent,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const Text("Please enter your registered phone number!",
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                               Container(
                    width:300,
                    height: 300,
                    child: Image.asset('Assets/images/img1.png',)),

                Text('Phone Verification!!!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: phnNumber,
                    decoration: InputDecoration(
                      labelText: 'Enter your phone number',
                      hintText: '+91',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.green
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                          borderSide: BorderSide(
                            color: Colors.brown,
                          )
                      ),


                    ),
                  ),
                ),

                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: RoundButton(
                        title: "Send Code", onTap: () {
                      auth.verifyPhoneNumber(
                          phoneNumber: phnNumber.text,
                          verificationCompleted: (
                              PhoneAuthCredential credential) async
                          {
                            await auth.signInWithCredential(credential);
                          },
                          verificationFailed: (e) async {

                            showSnackBar(context, Colors.red, e.message);

                          },
                          codeSent: (String verificationId, int? token) async {
                            this.verificationCode = verificationId;
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    otpScreen(verificationId: verificationCode))
                            );
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {
                            setState(() {
                              verificationCode = verificationId;
                            });
                          }

                      );
                    }
                    )
                )
              ],
            ),
          ),
        )
    );
  }
}