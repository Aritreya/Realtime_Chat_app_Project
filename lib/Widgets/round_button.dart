import 'package:flutter/material.dart';
class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const RoundButton({ required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }
}