import 'package:chat_app/Services/auth_service.dart';
import 'package:chat_app/Services/data_service.dart';
import 'package:chat_app/Widgets/Widgets.dart';
import 'package:chat_app/auth/home_page.dart';
import 'package:chat_app/auth/phn_ath.dart';
import 'package:chat_app/auth/register_page.dart';
import 'package:chat_app/helper/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import'package:flutter/material.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading=false;
  AuthServices authService=AuthServices();

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.orangeAccent,
          child: _isLoading ? Center(child: CircularProgressIndicator(color: Colors.greenAccent,),):SingleChildScrollView(
              child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                  child: Form(
                      key: formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "Groupie",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text("Login now to see what they are talking!",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400)),
                            Image.asset("Assets/images/login.png"),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Email",
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.blueAccent,
                                  )),
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },

                              // check tha validation
                              validator: (val) {
                                return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                    ? null
                                    : "Please enter a valid email";
                              },
                            ),

                            const SizedBox(height: 15),

                            TextFormField(
                              obscureText: true,
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Password",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.blueAccent
                                  )),
                              validator: (val) {
                                if (val!.length < 6) {
                                  return "Password must be at least 6 characters";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                            ),
                            SizedBox(height: 30,),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(60))),
                                child: const Text(
                                  "Sign In",
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                onPressed: () {
                                  login();
                                },
                              ),
                            ),
                        SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                        color: Colors.black, fontSize: 14),
                         children: <TextSpan>[
                         TextSpan(
                       text: "Register here",
                       style: const TextStyle(
                       color: Colors.black,
                      decoration: TextDecoration.underline),
                       recognizer: TapGestureRecognizer()
                         ..onTap = () {
                        nextScreen(context, registerPage());
                    }),


                          ]
                      )
                  ),
                            SizedBox(
                              height: 15,
                            ),

                            ElevatedButton(onPressed: (){
                             nextScreen(context, loginWithPhnNumber());

                            },
                              child: Text('Login With phn number',style: TextStyle(
                                  color: Colors.yellow
                              ),),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                  shadowColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  )
                              ),),

                          ]
              )
          )
    )
    ),
        )
    );
  }

  login() async{
    if(formKey.currentState!.validate()) {
      setState(() {
        _isLoading=true;
      });
      await authService.logInWithUserWithEmailandPassword( email, password).then((value)
      async{
        if(value==true)
        {
        QuerySnapshot snapshot=await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
        await HelperFunctions.saveUserLoggedInStatus(true);
        await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
        await HelperFunctions.saveEmailSf(email);
          nextScreenReplace(context, HomePage());
        }else {
          setState(() {
            _isLoading=false;
          });
          showSnackBar(context,Colors.red,value);

        }
      }
      );
    }
  }
}