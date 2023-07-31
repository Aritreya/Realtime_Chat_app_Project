import 'package:chat_app/Services/data_service.dart';
import 'package:chat_app/helper/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthServices{
  final FirebaseAuth firebaseauth=FirebaseAuth.instance;
  //login
  Future logInWithUserWithEmailandPassword( String email,String password) async
  {
    try {
      User user = (await firebaseauth.signInWithEmailAndPassword(
          email: email, password: password)).user!;
      if (user != null) {
        return true;
      }
    }on FirebaseAuthException catch(e)
    {
      return e.message;
    }
  }

//register
Future registerUserWithEmailandPassword( String fullName,String email,String password) async
{
  try {
    User user = (await firebaseauth.createUserWithEmailAndPassword(
        email: email, password: password)).user!;
    if (user != null) {
      await DataBaseService(uid: user.uid).savingUserData(fullName, email);
      return true;
    }
  }on FirebaseAuthException catch(e)
  {
    return e.message;
  }
}

//signout
  Future signOut() async{
  await HelperFunctions.saveUserLoggedInStatus(false);
  await HelperFunctions.saveEmailSf("");
  await HelperFunctions.saveUserNameSF("");
  await firebaseauth.signOut();
}
}