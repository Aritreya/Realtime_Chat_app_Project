import 'package:chat_app/auth/home_page.dart';
import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/helper/helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const chatApp());
}
class chatApp extends StatefulWidget {
  const chatApp({super.key});

  @override
  State<chatApp> createState() => _chatAppState();
}

class _chatAppState extends State<chatApp> {
  bool _isSignedIn=false;
  @override
  void initState()
  {
    super.initState();
    getUserLoggedInStatus();
  }
  getUserLoggedInStatus() async
  {
    await HelperFunctions.getUserLoggedInStatus().then((value){
      if(value!=null)
        { setState(() {
          _isSignedIn=value;
        });
        }
    });
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _isSignedIn? const HomePage():LoginPage(),
    );
  }
}

