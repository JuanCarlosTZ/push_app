import 'package:flutter/material.dart';

class CustomIconAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  const CustomIconAction({
    super.key,
    this.onPressed,
    this.icon = Icons.arrow_back_ios_new,
    this.color = Colors.black,
    this.backgroundColor = Colors.white24,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: backgroundColor,
          )
        ]),
        child: IconButton(
          color: color,
          onPressed: onPressed,
          icon: Icon(icon),
        ),
      ),
    );
  }
}
