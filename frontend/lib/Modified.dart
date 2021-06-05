import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'models/User.dart';
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
          title: Text(editTitle, style: TextStyle(fontSize: 24.0, color: appMainColor)),
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
                    child: const Text(cancelButtonText),
                  ),
                  TextButton(
                    onPressed: () {
                      log("Back to MainPage");
                      Navigator.pop(context, 'Yes');
                      Navigator.of(context).pushNamed(mainPageTag);
                    },
                    child: const Text(yesButtonText),
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

  var editedUser = {'id': userData.id, 'name': '' , 'dept': '' , 'grade': '' , 'gender': ''};
  final _formKey = GlobalKey<FormState>();
  var _gender;
  var _isChosen;
  /*
  var _status;
  */
  var be_a_driver = userData.is_driver;
  File file = File('');

  final String phpEndPoint = '';
  final String nodeEndPoint = '';

  void _choose() async {
    file = await ImagePicker.pickImage(source: ImageSource.camera);
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
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
      be_a_driver = (userData.is_driver != 0);
      _isChosen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    //final editedUser = ModalRoute.of(context)!.settings.arguments as User;

    final _nameController = TextEditingController(text: editedUser['name'].toString());
    final _deptController = TextEditingController(text: editedUser['dept'].toString());
    final _gradeController = TextEditingController(text: editedUser['grade'].toString());
    final snackBar = SnackBar(content: Text(uploadImageHintText ));
    // log("be_a_driver "+be_a_driver.toString());

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
          editedUser['name'] = value;
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
        //setState(() => _gender = newValue);
        _gender = newValue;
        editedUser['gender'] = _gender;
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
          editedUser['dept'] = value;
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
          editedUser['grade'] = value;
          return null;
        }
      },
    );
    /*
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
    */
    /* 儲存修改按鈕 */
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
              if(_formKey.currentState!.validate()) {
                log(editedUser["id"].toString());
                log(editedUser["name"].toString());
                log(editedUser["dept"].toString());
                log(editedUser["grade"].toString());
                log(editedUser["gender"].toString());
                var editedUserEncoded = json.encode(editedUser);
                var res =  await http.post(url + '/profile', body: editedUserEncoded , headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  },);
                log(res.toString());
                log(res.statusCode.toString());
                if (res.statusCode == 200) {
                  var isEdited = res.body;
                  if(isEdited == "true") {
                    log("success");
                    var getData = await http.get(url + '/users/' + userData.id , headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },);
                    userData = User.fromJson(jsonDecode(getData.body));
                    Navigator.of(context).pushNamed(mainPageTag);
                  }
                  else {
                    log("edit failed");
                  }
                } else {
                  log("error");
                  throw Exception('Failed to edit data.');
                }
              }
              // TODO: send newUser to backend.
              // @post: newUser: Object(FormData?)
              // @return: message: String
            },
            //padding: EdgeInsets.all(12),
            child: Text(saveChangeButtonText, style: nameStyle),
          ),
        ),
      ],
    );
    /* 上傳圖片 */
    final beADriver = Visibility(
      visible: (be_a_driver) ? false : true,
      child: TextButton(
        style: ButtonStyle(
        ),
        onPressed: () async {
          var changeState = {'oid': userData.id};
          var changeStateEncode = jsonEncode(changeState);
          var res = await http.post(url + '/set_driver', body: changeStateEncode, headers: <String, String> {
            'Content-Type': 'application/json; charset=UTF-8',
          },);
          // log(res.statusCode.toString());
          if(res.statusCode == 200) {
            // log("return ok");
            if(res.body == "false") {
              log("set driver failed");
            }
            else {
              log("set driver success");
            }
          }
          else {
            log("error");
          }
          setState(() {
            be_a_driver = true;
          });
        },
        child: Text(beADriverButtonText, style: textButtonStyle),
      ),
    );
    /* 上傳照片 */
    final chooseImage = Visibility(
      visible: (be_a_driver && editedUser['cert'] == '') ? true : false,
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
      visible: (_isChosen && editedUser['cert'] == '') ? true : false,
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
          child: Scaffold(
            body: Center(
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
                    /*
                  SizedBox(height: smallSpace),
                  status,
                  */

                    beADriver,
                    chooseImage,
                    uploadImage,
                    saveChangeButton,
                  ],
                ),
              ),
            ),
          ),
        );
  }
}

final routes = <String, WidgetBuilder> {
  mainPageTag: (context) => MainPage(),
};