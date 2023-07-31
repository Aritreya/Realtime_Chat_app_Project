import 'package:chat_app/Widgets/Widgets.dart';
import 'package:chat_app/Widgets/round_button.dart';
import 'package:chat_app/auth/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class otpScreen extends StatefulWidget {
  final String verificationId;
  otpScreen( {super.key,required this.verificationId});

  @override
  State<otpScreen> createState() => _otpScreenState();
}

class _otpScreenState extends State<otpScreen> {
  final pinCotroller=TextEditingController();
  final auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return  Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          elevation: 0,
          title: Text('Verify karawo!!!!!'),
        ),

        body: Center(
          child: Container(
            color: Colors.orangeAccent,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Groupie",
                    style: TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Image.asset('Assets/images/login.png',width: 300,height: 300,),
                  SizedBox(

                    height: 10,
                  ),
                  Text('OTP Verification',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 50,
                  ),
                  Pinput(
                    controller: pinCotroller,
                    length: 6,
                    showCursor: true,
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: RoundButton(title: "Verify Code", onTap: () async {
                        final credential=PhoneAuthProvider.credential(verificationId:  widget.verificationId, smsCode: pinCotroller.text.toString());
                        try
                        {
                          await auth.signInWithCredential(credential);
                        } on FirebaseAuthException catch (e)
                        {
                          showSnackBar(context, Colors.green, e.message);
                        }
                        nextScreen(context, HomePage());


                      }
                      )
                  )
                ]
            ),
          ),
        ),
    );
  }
}