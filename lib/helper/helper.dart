import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static const String userLoggedInKEY = "LOGGEDINKEY";
  static const String userNameKey = "USERNAMEKEY";
  static const String userEmailKey = "USEREMAILKEY";

  static Future<bool>  saveUserLoggedInStatus(bool isUserLoggedIn)
  async{
    SharedPreferences sf= await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKEY, isUserLoggedIn);
  }
  static Future<bool>  saveUserNameSF(String userName)
  async{
    SharedPreferences sf= await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }
  static Future<bool>  saveEmailSf(String userEmail)
  async{
    SharedPreferences sf= await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool?> getUserLoggedInStatus()
async {
    SharedPreferences sf=await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKEY);
}
  static Future<String?> getUserNameFromSf()
  async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
  static Future<String?> getUserEmailFromSf()
  async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }
}
