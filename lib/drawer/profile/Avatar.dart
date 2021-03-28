import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String avatarUrl;
  final Function onTap;

  const Avatar({this.avatarUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: avatarUrl == null
            ? CircleAvatar(
          radius: 70.0,
          backgroundColor: Colors.orange,
          child: Icon(Icons.photo_camera, size: 55,color: Colors.white,),
        )
            : CircleAvatar(
          radius: 50.0,
          backgroundImage: NetworkImage(avatarUrl),
        ),
      ),
    );
  }
}