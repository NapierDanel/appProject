import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
     return  SettingsList(
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile(
                title: 'Language',
                subtitle: 'English',
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) {},
              ),
             SettingsTile(title: 'Darkmode',
             leading: Icon(Icons.wb_sunny))
            ],
          ),
        ],
      );
  }


}