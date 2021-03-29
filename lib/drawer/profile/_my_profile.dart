import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_mobile_app_dev/drawer/profile/Avatar.dart';
import 'package:flutter_application_mobile_app_dev/login/_login_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MyProfilePage extends StatefulWidget {
  @override
  MyProfileStage createState() => MyProfileStage();
}

class MyProfileStage extends State<MyProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  final picker = ImagePicker();
  File _image;
  User _currentUser;

  /// Text controller
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    /// Check if the User is logged in, if not -> push LoginPage
    // Get the firebase user
    _currentUser = FirebaseAuth.instance.currentUser;

    if (_currentUser == null) {
      return LoginPage();
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Avatar(
                    avatarUrl: _currentUser?.photoURL,
                    onTap: () async {
                      File image = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                      print(image.path);
                      _setProfilePicture(_currentUser.uid, image);
                    },
                  ),
                  Text(
                    _currentUser?.displayName ?? 'No User name set',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white

                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      autofocus: false,
                      controller: usernameController,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(node);
                      },
                      decoration: InputDecoration(
                        hintText:
                            _currentUser?.displayName ?? 'Insert Username ',
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            autofocus: false,
                            obscureText: true,
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(node);
                            },
                            decoration: InputDecoration(
                              hintText: "new Password",
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () {
                          saveChanges(
                              usernameController.text, passwordController.text);
                        },
                        padding: EdgeInsets.all(15),
                        color: Colors.lightBlueAccent,
                        child: Text('Save changes',
                            style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  _setProfilePicture(String userId, File profilePicture) async {
    firebase_storage.UploadTask uploadTask;
    String imageUrl;

    firebase_storage.Reference storage = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("UserImages")
        .child("${userId}_profilePicture");

    uploadTask = storage.putData(await profilePicture.readAsBytes());
    try {
      imageUrl = await storage.getDownloadURL();
      String userName = _currentUser.displayName;

      _currentUser.updateProfile(displayName: userName, photoURL: imageUrl);
    } catch (onError) {
      print("Error");
    }

    print("Upload profile picture...");
  }

  void saveChanges(String userName, String password) {
    print(userName + password);
    if (userName.isNotEmpty) {
      _currentUser.updateProfile(
          displayName: userName, photoURL: _currentUser.photoURL);
    }
    if (password.isNotEmpty) {
      _currentUser.updatePassword(password);
    }
  }
}
