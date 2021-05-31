import 'package:flutter/material.dart';
//import 'dart:io';
//import 'dart:convert';
//import 'package:http/http.dart' as http;
//import 'package:image_picker/image_picker.dart';
import 'dart:developer';
import 'helpers/Constants.dart';
import 'MainPage.dart';

class Modified extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: modifiedTag,
      theme: new ThemeData(
        scaffoldBackgroundColor: appBackgroundColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: appBackgroundColor,
          title: Text('Edit Profile', style: TextStyle(fontSize: 24.0, color: appMainColor)),
          leading: GestureDetector(
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(discardAlertTitle),
                content: Text(discardAlertText),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      log("Cancel");
                      Navigator.pop(context, 'Cancel');
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      log("Back to MainPage");
                      Navigator.pop(context, 'Yes');
                      Navigator.of(context).pushNamed(mainPageTag);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ),
            child: Icon(
              Icons.arrow_back,
              color: appMainColor,
              size: 30.0,
            ),
          ),
        ),
        body: ModifiedPage(),
      ),
      routes: routes,
    );
  }
}

class ModifiedPage extends StatefulWidget {
  @override
  ModifiedForm createState() {
    return ModifiedForm();
  }
}

class ModifiedForm extends State<ModifiedPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: userData.name);
  final _deptController = TextEditingController(text: userData.dept);
  final _gradeController = TextEditingController(text: userData.grade);
  final snackBar = SnackBar(content: Text(uploadImageHintText ));
  var editedData = userData;
  var _gender;
  var _status;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    /* 暱稱 */
    final userName = TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      decoration: InputDecoration(
          labelText: nameAttr,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
          enabledBorder: underlineStyle,
          focusedBorder: underlineStyle,
          labelStyle: labelStyle,
      ),
      style: TextStyle(
        fontSize: 24.0,
        color: appWhiteColor,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return nameIsEmptyText;
        }
        else {
          log("Save name");
          editedData.name = value;
          return null;
        }
      },
    );
    /* 性別 */
    final gender = DropdownButtonFormField(
      items: genderList.map((String gender) {
        return new DropdownMenuItem(
            value: gender,
            child: Text(gender, style: TextStyle(fontSize: 24.0,
              color: appWhiteColor,)),
            );
      }).toList(),
      onChanged: (newValue) {
        log("Save gender");
        setState(() => _gender = newValue);
        editedData.gender = _gender;
      },
      value: _gender,
      dropdownColor: appBackgroundColor,
      decoration: InputDecoration(
        labelText: genderAttr,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: underlineStyle,
        focusedBorder: underlineStyle,
        labelStyle: labelStyle,
      ),
    );
    /* 學系 */
    final dept = TextFormField(
      controller: _deptController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      decoration: InputDecoration(
        labelText: deptAttr,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
        enabledBorder: underlineStyle,
        focusedBorder: underlineStyle,
        labelStyle: labelStyle,
      ),
      style: TextStyle(
        fontSize: 24.0,
        color: appWhiteColor,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return deptIsEmptyText;
        }
        else {
          log("Save dept");
          editedData.dept = value;
          return null;
        }
      },
    );
    /* 年級 */
    final grade = TextFormField(
      controller: _gradeController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      decoration: InputDecoration(
        labelText: gradeAttr,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
        enabledBorder: underlineStyle,
        focusedBorder: underlineStyle,
        labelStyle: labelStyle,
      ),
      style: TextStyle(
        fontSize: 24.0,
        color: appWhiteColor,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return gradeIsEmptyText;
        }
        else {
          log("Save grade");
          editedData.grade = value;
          return null;
        }
      },
    );
    /* 用戶身份 */
    final status = DropdownButtonFormField(
      items: statusList.map((String status) {
        return new DropdownMenuItem(
          value: status,
          child: Text(status, style: TextStyle(fontSize: 24.0,
            color: appWhiteColor,)),
        );
      }).toList(),
      onChanged: (newValue) {
        log("Save status");
        setState(() => _status = newValue);
        editedData.is_driver = (_status == prateAttr) ? 0 : 1;
      },
      value: _status,
      dropdownColor: appBackgroundColor,
      decoration: InputDecoration(
        labelText: statusAttr,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: underlineStyle,
        focusedBorder: underlineStyle,
        labelStyle: labelStyle,
      ),
    );
    /* 儲存修改按鈕 */
    final saveChangeButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.all(12)),
          backgroundColor: MaterialStateProperty.all<Color>(appMainColor),
        ),
        onPressed: () {
          if(_formKey.currentState!.validate()) Navigator.of(context).pushNamed(mainPageTag);
          // TODO: send changes of userData to backend.

        },
        //padding: EdgeInsets.all(12),
        child: Text(saveChangeButtonText, style: TextStyle(fontSize: 24.0, color: appBackgroundColor)),
      ),
    );
    /* 上傳圖片 */
    final uploadImage = Visibility(
      visible: (_status == drateAttr && userData.cert == '') ? true : false,
      child: TextButton(
        style: ButtonStyle(
        ),
        onPressed: () {
          //TODO: Upload {cert: image} through image_picker and http.
          //TODO: Send {cert: image} to backend.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Text(uploadImageButtonText, style: labelStyle),
      ),
    );

    return Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  userName,
                  SizedBox(height: smallSpace),
                  gender,
                  SizedBox(height: smallSpace),
                  Row(
                    children: <Widget>[
                      Expanded(child: dept,),
                      Expanded(child: grade,),
                    ],
                  ),
                  SizedBox(height: smallSpace),
                  status,
                  SizedBox(height: smallSpace),
                  uploadImage,
                  saveChangeButton,
                ],
              ),
            ),
          ),
        );
  }
}

final routes = <String, WidgetBuilder> {
  mainPageTag: (context) => MainPage(),
};