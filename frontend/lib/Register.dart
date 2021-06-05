import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:developer';
import 'helpers/Constants.dart';
import 'Login.dart';


class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBackgroundColor,
          title: Text('Sign up', style: TextStyle(fontSize: 24.0, color: appMainColor)),
          leading: GestureDetector(
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text("Exit"),
                content: Text("Back to login?"),
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
                      log("Back to Login.");
                      Navigator.pop(context, 'Yes');
                      Navigator.of(context).pop();
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
        body: RegisterPage(),
      );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  RegisterForm createState() {
    return RegisterForm();
  }
}

class RegisterForm extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _nameController = TextEditingController();
  /*
  final _deptController = TextEditingController();
  final _gradeController = TextEditingController();
  */
  final snackBar = SnackBar(content: Text(uploadImageHintText ));
  final errorSnackBar = SnackBar(content: Text("Existing Account!"));
  var newUser = {"sid": '', "password": '', 'name': ''};
  /*
  var _gender;
  var _status;
  */
  var be_a_driver;
  var _isChosen;
  File file = File('');

  final String phpEndPoint = '';
  final String nodeEndPoint = '';

  void _choose() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _upload() {
    if (file == null) return;
    String base64Image = base64Encode(file.readAsBytesSync());
    String fileName = file.path.split("/").last;

    http.post(phpEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((res) {
      print(res.statusCode);
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void initState() {
    setState(() {
      be_a_driver = false;
      _isChosen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    /* 帳號(學號) */
    final account_id = TextFormField(
      controller: _idController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      decoration: InputDecoration(
        labelText: idHintText,
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
          return idIsEmptyText;
        }
        else {
          log("Set id.");
          newUser['sid'] = value;
          return null;
        }
      },
    );
    /* 密碼 */
    final password = TextFormField(
      controller: _pwController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      decoration: InputDecoration(
        labelText: pwHintText,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
        enabledBorder: underlineStyle,
        focusedBorder: underlineStyle,
        labelStyle: labelStyle,
      ),
      obscureText: true,
      style: TextStyle(
        fontSize: 24.0,
        color: appWhiteColor,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return pwIsEmptyText;
        }
        else {
          log("Set password.");
          newUser['password'] = value;
          return null;
        }
      },
    );
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
          log("Set name.");
          newUser['name'] = value;
          return null;
        }
      },
    );
    /*
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
        log("Set gender.");
        setState(() => _gender = newValue);
        newUser.gender = _gender;
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
          log("Set dept.");
          newUser.dept = value;
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
          log("Set grade.");
          newUser.grade = value;
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
        log("Set status.");
        setState(() => _status = newValue);
        newUser.is_driver = (_status == prateAttr) ? 0 : 1;
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
    */
    /* 註冊完成按鈕 */
    final saveChangeButton = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.app_registration , color: appMainColor, size: 24.0,),
        SizedBox(width: smallSpace),
          Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: TextButton(
              style: ButtonStyle(

            ),
              onPressed: () async {
                // Navigator.of(context).pop();
              if(_formKey.currentState!.validate()) {
                log("Debuging");
                log(newUser["sid"].toString());
                log(newUser["password"].toString());
                log(newUser["name"].toString());
                var newUserEncoded = json.encode(newUser);
                var res =  await http.post(url + "/register", body: newUserEncoded , headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },);
                log(res.toString());
                log(res.statusCode.toString());
                if (res.statusCode == 200) {
                  if(res.body == "Register success") {
                    log("register success");
                    Navigator.of(context).pop();
                  }
                  else {
                    log("register failed");
                    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                  }
                } else {
                  log("error");
                  throw Exception('Failed to create user.');
                }

              }
            },
            //padding: EdgeInsets.all(12),
             child: Text(signUpButtonText, style: nameStyle),
            ),
          ),
      ],
    );

    /* 上傳照片 */
    final beADriver = Visibility(
        visible: (be_a_driver) ? false : true,
        child: TextButton(
        style: ButtonStyle(
        ),
        onPressed: () {
          setState(() {
            be_a_driver = true;
          });
        },
        child: Text(beADriverButtonText, style: textButtonStyle),
      ),
    );
    /* 上傳照片 */
    final chooseImage = Visibility(
      visible: (be_a_driver) ? true : false,
      child: TextButton(
        style: ButtonStyle(
        ),
        onPressed: () {
          _choose();
          //TODO: Upload {cert: image} through image_picker and http.
          //TODO: Send {cert: image} to backend.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Text(chooseImageButtonText, style: textButtonStyle),
      ),
    );
    final uploadImage = Visibility(
      visible: (_isChosen) ? true : false,
      child: TextButton(
        style: ButtonStyle(
        ),
        onPressed: () {
          _upload();
          //TODO: Upload {cert: image} through image_picker and http.
          //TODO: Send {cert: image} to backend.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Text(uploadImageButtonText, style: textButtonStyle),
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
              account_id,
              SizedBox(height: smallSpace),
              password,
              SizedBox(height: smallSpace),
              userName,
              SizedBox(height: smallSpace),
              /*
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
              */
              // beADriver,
              // chooseImage,
              // uploadImage,
              saveChangeButton,
            ],
          ),
        ),
      ),
    );
  }
}

// final routes = <String, WidgetBuilder> {
//   loginTag: (context) => Login(),
// };