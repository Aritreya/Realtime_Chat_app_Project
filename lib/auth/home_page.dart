import 'package:chat_app/Services/auth_service.dart';
import 'package:chat_app/Services/data_service.dart';
import 'package:chat_app/Widgets/Widgets.dart';
import 'package:chat_app/Widgets/grouo_tile.dart';
import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/auth/profile_page.dart';
import 'package:chat_app/auth/search_space.dart';
import 'package:chat_app/helper/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
String userName="";
String email="";
AuthServices authService=AuthServices();
Stream? groups;
bool _isLoading=false;
String groupName="";

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Container(
      color: Colors.orangeAccent,
    );
    getUserData();
  }
  //getttingStringManipulation
String getId(String res)
{
  return res.substring(0,res.indexOf("_"));
}
String getName(String res)
{
  return res.substring(res.indexOf("_")+1);
}
  void getUserData()async
  {
    await HelperFunctions.getUserEmailFromSf().then((value) {
      setState(() {
        email=value!;
      });
    });
    await HelperFunctions.getUserNameFromSf().then((value) {
      setState(() {
        userName=value!;
      });
    });
    await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot){
      setState(() {
        groups=snapshot;
      });
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            nextScreen(context, SearchPage());
          }, icon: Icon(Icons.search)),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red,
        title: Text("Groups",style: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.bold,
          color: Colors.orange
        ),),

      ),
      drawer: Drawer(
        backgroundColor: Colors.tealAccent,
        child: ListView(
          padding:EdgeInsets.symmetric(vertical: 50),
              children: [
                Icon(Icons.account_circle,size: 150,),
                SizedBox(
                  height: 15,
                ),
                Text(userName,textAlign: TextAlign.center,
                    style:TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                SizedBox(
                  height: 40,
                ),
                ListTile(
                  onTap: (){

                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  leading: Icon(Icons.group),
                  title: Text("Groups",style:TextStyle(
                    color:Colors.black,fontWeight: FontWeight.bold,fontSize: 15
                  )),
                ),
                ListTile(
                  onTap: (){
                    nextScreenReplace(context, profilePage(userName: userName,email: email,));
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
                    );


                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  leading: Icon(Icons.exit_to_app),
                  title: Text("SignOut",style:TextStyle(
                      color:Colors.black,fontWeight: FontWeight.bold,fontSize: 15
                  )),
                )
          ],
        ),
      ),
      body: groupList(),
        floatingActionButton: Container(
        child: FloatingActionButton(
          onPressed: (){
            popUpDialog(context);

          },
          elevation: 0,
          backgroundColor: Colors.orange,
          child: Icon(Icons.add,color:Colors.white),
        ),
      ),


    );

  }
  groupList(){
  return StreamBuilder(
    stream: groups,
    builder: (context,AsyncSnapshot snapshot){
      if(snapshot.hasData)
        {
          if(snapshot.data['groups']!=null)
            {
                 if(snapshot.data['groups'].length!=0)
                   {
                     return ListView.builder(

                         itemCount: snapshot.data['groups'].length,
                         itemBuilder: (context,index)
                         {
                           int reverseIndex=snapshot.data['groups'].length-index-1;
                           return GroupTile(
                               groupId: getId(snapshot.data['groups'][reverseIndex]),
                               groupName: getName(snapshot.data['groups'][reverseIndex]),
                               userName: snapshot.data['fullName']);
                         });
                   }else {
                   return noGroupWidget();
                 }
            }else
              {
                return noGroupWidget();
              }
        }else
          {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
    }
  );
  }
  popUpDialog(BuildContext context)
  {
    showDialog(barrierDismissible: false,
        context: context,
    builder: (context)
    {
      return AlertDialog(
        title:Text("Create a group",textAlign: TextAlign.left,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _isLoading==true?Center(
              child: CircularProgressIndicator(
                color:Colors.green
              ),
            ):TextField(
              onChanged: (value)
              {
                setState(() {
                  groupName=value;
                });
              },
              style: const TextStyle(color:Colors.black),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:Colors.amber,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:Colors.greenAccent,
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:Colors.red,
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  )
              ),
            )
          ],
        ),
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.of(context).pop();
          },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,

              ),
              child:Text("Cancel") ),

            ElevatedButton(onPressed: (){
                if(groupName!="")
                  {
                    setState(() {
                      _isLoading=true;
                    });
                    DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(
                        userName, FirebaseAuth.instance.currentUser!.uid, groupName).whenComplete((){
                          _isLoading=false;
                    });
                    Navigator.of(context).pop();
                    showSnackBar(context, Colors.green, "Group created succesfully.");
                  }
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,

              ),
              child:Text("Create") )
        ],

      );
    });
  }
  noGroupWidget()
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 65),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.add_circle,color: Colors.grey[700],size: 95,),
          SizedBox(
            height: 20,
          ),
          Text("You have not joined any group!!!Search above!!",textAlign: TextAlign.center,)

        ],
      )
    );

  }
}
