import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String? uid;

  DataBaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection("users");
  final CollectionReference groupCollection = FirebaseFirestore.instance
      .collection("groups");

  //saving the data
  Future savingUserData(String fullName, String email) async
  {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "uid": uid,
      "groups": [],
    });
  }

//getting user data
  Future gettingUserData(String email) async
  {
    QuerySnapshot snapshot = await userCollection.where(
        "email", isEqualTo: email).get();
    return snapshot;
  }

  //getting usergroups
  getUserGroups() async
  {
    return await userCollection.doc(uid).snapshots();
  }

//creating a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });
    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
      FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  getChats(String groupId) async {
    return await groupCollection.doc(groupId).collection("messages")
        .orderBy("time")
        .snapshots();
  }
  Future getGroupAdmin(String groupId)async{
    DocumentReference d=groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot=await d.get();
    return documentSnapshot['admin'];
  }
  //get  group members
getGroupMembers(groupId)async{
    return groupCollection.doc(groupId).snapshots();
}
//searchbyName
searchByName(String groupName)
{
  return groupCollection.where("groupName",isEqualTo: groupName).get();
}
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }
  //toggling the group login/exit
Future toggleGroupJoin(String groupId,String userName,String groupName)async
{
  //create document reference
  DocumentReference userDocumentReference=userCollection.doc(uid);
  DocumentReference groupDocumentReference=groupCollection.doc(groupId);
  DocumentSnapshot documentSnapshot=await userDocumentReference.get();
  List<dynamic> groups=await documentSnapshot['groups'];
  //if user has our groups ->then either rejoin or remove
  if(groups.contains("${groupId}_${groupName}")){
    await userDocumentReference.update({"groups":FieldValue.arrayRemove(["${groupId}_$groupName"])});
    await groupDocumentReference.update({"members":FieldValue.arrayRemove(["${uid}_$userName"])});
  }else{
    await userDocumentReference.update({"groups":FieldValue.arrayUnion(["${groupId}_$groupName"])});
    await groupDocumentReference.update({"groups":FieldValue.arrayUnion(["${uid}_$userName"])});
  }
}
sendMessage(String groupId,Map<String, dynamic> chatMessageData)async{
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage":chatMessageData['message'],
      "recentMessageSender":chatMessageData['time'].toString(),
    });
}
}