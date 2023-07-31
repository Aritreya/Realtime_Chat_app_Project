import'package:flutter/material.dart';
final textInputDecoration=InputDecoration(
  labelStyle: TextStyle(color: Colors.black),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(21),
      borderSide: BorderSide(
        width: 4,color: Colors.red,
      ),
    ),
  enabledBorder:OutlineInputBorder(
      borderRadius: BorderRadius.circular(21),
      borderSide: BorderSide(
        color: Colors.grey,
        width:2,
      )
  ),errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(21),
     borderSide: BorderSide(
     color: Colors.grey,
        width:2,
   )
)

);
void nextScreen(context,page)
{
  Navigator.push(context, MaterialPageRoute(builder: (context)=>page));
}
void nextScreenReplace(context,page)
{
  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>page));
}
void showSnackBar(context,color,message)
{
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message,style: TextStyle(
        fontSize:14
      ),
      ),
          backgroundColor: color,
        duration: const Duration(
          seconds: 2),
        action: SnackBarAction(label: "Okk!!!", onPressed: (){},textColor: Colors.deepPurple),
          )
  );
}