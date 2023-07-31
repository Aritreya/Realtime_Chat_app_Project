import 'package:chat_app/Widgets/Widgets.dart';
import'package:flutter/material.dart';

import '../auth/chat_page.dart';
class GroupTile extends StatefulWidget {
  final String userName;
  final String groupName;
  final String groupId;
  const GroupTile({
    super.key,required this.groupId,
  required this.groupName,
    required this.userName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        nextScreen(context, chatPage(groupId: widget.groupId,
       groupName: widget.groupName, userName: widget.userName,));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.tealAccent,
            child: Text(widget.groupName.substring(0,1).toUpperCase(),style:TextStyle(
              fontWeight:FontWeight.bold,color: Colors.black
            )),
          ),
          title: Text(widget.groupName,style: TextStyle(
            fontWeight: FontWeight.bold
          ),),
          subtitle: Text("Join the conversation as ${widget.userName}"
          ,style: TextStyle(
              fontSize: 13
            ),),
        ),
      ),
    );


  }
}
