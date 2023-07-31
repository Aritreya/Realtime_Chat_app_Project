import 'package:chat_app/Services/data_service.dart';
import 'package:chat_app/Widgets/Widgets.dart';
import 'package:chat_app/Widgets/message_tile.dart';
import 'package:chat_app/auth/group_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import'package:flutter/material.dart';
class chatPage extends StatefulWidget {
  final String groupId;
  final  String groupName;
  final String userName;
   chatPage({super.key, required this.groupId, required this.groupName, required this.userName});

  @override
  State<chatPage> createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = "";
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DataBaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DataBaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(widget.groupName),
          backgroundColor: Colors.orange,
          actions: [
            IconButton(onPressed: () {
              nextScreen(context,
                  groupInfo(groupId: widget.groupId,
                    groupName: widget.groupName,
                    adminName: admin,));
            }, icon: Icon(Icons.info))
          ],
        ),
        body: Container(
          color: Colors.orangeAccent,
          child: Stack(
            children: <Widget>[
              ChatMessages(),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  color: Colors.grey,
                  child: Row(
                    children: [
                      Expanded(child: TextFormField(
                        controller: messageController,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                            hintText: "Send a message...",
                            hintStyle: TextStyle(
                                color: Colors.white, fontSize: 16),
                            border: InputBorder.none
                        ),
                      )),
                      SizedBox(width: 12,),
                      GestureDetector(
                        onTap: sendMessage(),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Center(
                            child: Icon(Icons.send, color: Colors.white,),

                          ),
                        ),
                      )

                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  ChatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return MessageTile(message: snapshot.data.docs[index]['message'],
                  sender: snapshot.data.docs[index]['sender'],
                  SendByMe: widget.userName ==
                      snapshot.data.docs[index]['sender']);
            },
          ) : Container();
        });
  }


  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime
            .now()
            .millisecondsSinceEpoch,
      };
      DataBaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
