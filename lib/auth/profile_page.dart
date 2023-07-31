import 'package:chat_app/Services/auth_service.dart';
import 'package:chat_app/Widgets/Widgets.dart';
import 'package:chat_app/auth/home_page.dart';
import 'package:chat_app/auth/login_page.dart';
import'package:flutter/material.dart';
class profilePage extends StatefulWidget {
  String userName;
  String email;
   profilePage({super.key,required this.userName,required this.email});

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {

  AuthServices authService=AuthServices();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
          backgroundColor: Colors.orangeAccent,
          elevation: 0,
        centerTitle: true,
        title: Text("Profile",style: TextStyle(
          fontSize: 27,fontWeight: FontWeight.bold,color: Colors.white
        ),),
      ),
      drawer: Drawer(
        child: ListView(
          padding:EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(Icons.account_circle,size: 150,),
            SizedBox(
              height: 15,
            ),
            Text(widget.userName,textAlign: TextAlign.center,
                style:TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
            SizedBox(
              height: 40,
            ),
            ListTile(
              onTap: (){
                nextScreen(context, HomePage());
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: Icon(Icons.group),
              title: Text("Groups",style:TextStyle(
                  color:Colors.black,fontWeight: FontWeight.bold,fontSize: 15
              )),
            ),
            ListTile(
              onTap: (){
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: Icon(Icons.people),
              title: Text("Profile",style:TextStyle(
                  color:Colors.black,fontWeight: FontWeight.bold,fontSize: 15
              )),
            ),
            ListTile(
              onTap: () async{
                showDialog(
                    barrierDismissible: false,
                    context: context, builder: (context){
                  return AlertDialog(
                    title: Text("LogOut"),
                    content: Text("Are you sure you want to logout??"),
                    actions: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: Icon(Icons.cancel,color: Colors.teal,)),

                      IconButton(onPressed: () async {
                        await authService.signOut();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context)=>LoginPage()), (route) => false);

                      }, icon: Icon(Icons.done,color: Colors.red,))
                    ],
                  );
                }
                );},
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: Icon(Icons.exit_to_app),
              title: Text("SignOut",style:TextStyle(
                  color:Colors.black,fontWeight: FontWeight.bold,fontSize: 15
              )),
            )
          ],
        ),
      ),
      body: Container(
        color: Colors.orangeAccent,
        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 170),
        child:  Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              child: Icon(Icons.account_circle,color: Colors.white,),
           backgroundColor: Colors.grey, ),
            Divider(
              height: 40,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Username:",style: TextStyle(
                  fontSize: 17,fontWeight: FontWeight.bold,
                ),),
                Text(widget.userName,style: TextStyle(
                  fontSize: 17)),
              ],
            ),
            Divider(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Email:",style: TextStyle(
                  fontSize: 17,fontWeight: FontWeight.bold,
                ),),
                Text(widget.email,style: TextStyle(
                    fontSize: 17)),
              ],
            )
          ],
        )
        ),

    );
  }
}
