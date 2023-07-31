import 'package:chat_app/Services/auth_service.dart';
import 'package:chat_app/Widgets/Widgets.dart';
import 'package:chat_app/auth/home_page.dart';
import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/helper/helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  bool _isLoading=false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName="";
  AuthServices authService=AuthServices();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       body: SingleChildScrollView(
         child: Container(
           color: Colors.deepOrangeAccent,
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
                              const Text("Create your account to start a chat!!!",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w400)),
                              Image.asset("Assets/images/register.png"),
                        TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Full Name",
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.blueAccent,
                                )),
                          onChanged: (val) {
                            setState(() {
                              fullName= val;
                            });
                          },
                          validator: (val){
                              if(val!.isNotEmpty)
                                {
                                  return null;
                                }
                              else
                                return "Name cannot be empty";
                          },
                        ),
                              SizedBox(
                                height: 10,
                              ),
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

                              const SizedBox(height: 10),

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
                                    register();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text.rich(TextSpan(
                                  text: "Already have an account? ",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Login here",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            decoration: TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            nextScreen(context, LoginPage());
                                          }),


                                  ]
                              )
                              )
                            ]
                        )
                    )
                )
            ),
         ),
       )
    );
  }
  //register the user
  void register() async
  {
    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading=true;
      });
      await authService.registerUserWithEmailandPassword(fullName, email, password).then((value)
      async{
        if(value==true)
          {
             await HelperFunctions.saveUserLoggedInStatus(true);
             await HelperFunctions.saveUserNameSF(fullName);
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
