import 'package:chat_app/Services/data_service.dart';
import 'package:chat_app/Widgets/Widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
class groupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const groupInfo({super.key, required this.groupId, required this.groupName, required this.adminName});

  @override
  State<groupInfo> createState() => _groupInfoState();
}

class _groupInfoState extends State<groupInfo> {
  Stream? members;

  @override
  void initState() {
    // TODO: implement initState
    getMembers();
    super.initState();

  }
  getMembers() async {
    DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }
  String getName(String s)
  {
     return s.substring(s.indexOf("_")+1);
     
  }
  String getId(String res)
  {
    return res.substring(0,res.indexOf("_"));
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.orange,
        title: Text("Group Info"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Exit"),
                        content:
                        const Text("Are you sure you want to exit the group? "),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              DataBaseService(
                                  uid: FirebaseAuth
                                      .instance.currentUser!.uid)
                                  .toggleGroupJoin(
                                  widget.groupId,
                                  getName(widget.adminName),
                                  widget.groupName)
                                  .whenComplete(() {
                                nextScreenReplace(context, const HomePage());
                              });
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.exit_to_app))

        ],
      ),




      body: Container(
        color: Colors.orangeAccent,
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color:Colors.orange.withOpacity(0.2),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.deepOrange,
                    child: Text(widget.groupName.substring(0,1).toUpperCase(),style: TextStyle(
                      fontWeight: FontWeight.w500,color: Colors.black
                    ),),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group:${widget.groupName}",style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),),
                      SizedBox(height: 10,),
                      Text("Admin: ${getName(widget.adminName)}")
                      
                    ],
                  )
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
      
    );
  }
  memberList(){
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          getName(snapshot.data['members'][index])
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(getName(snapshot.data['members'][index])),
                      subtitle: Text(getId(snapshot.data['members'][index])),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ));
        }
      },
    );
  }
}
