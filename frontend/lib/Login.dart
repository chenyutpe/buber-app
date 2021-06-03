import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'MainPage.dart';
import 'Register.dart';

// 登入頁。輸入帳號(sid)、密碼(password)以登入。
// 點擊『註冊』後進入[Register]。
// 點擊『登入』後，將(sid)(password)傳回後端，若登入成功則進入[MainPage]。

class Login extends StatefulWidget{
  LoginPage createState()=> LoginPage();
}

class LoginPage extends State<Login> {

  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final snackBar = SnackBar(content: Text(loginFailedText));
  bool _idValidate = false;
  bool _pwValidate = false;

  @override
  Widget build(BuildContext context) {
    /* logo */
    final logo = CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: bigRadius,
      child: appLogo,
    );
    /* 帳號(學號) */
    final account_id = TextFormField(
      controller: _idController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      decoration: InputDecoration(
          hintText: idHintText,
          errorText: _idValidate ? idIsEmptyText : null,
          contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0.0),
          enabledBorder: underlineStyle,
          focusedBorder: underlineStyle,
          hintStyle: hintStyle,
      ),
      style: labelStyle,
    );
    /* 密碼 */
    final password = TextFormField(
      controller: _pwController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      decoration: InputDecoration(
          hintText: pwHintText,
          errorText: _pwValidate ? pwIsEmptyText : null,
          contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0.0),
          enabledBorder: underlineStyle,
          focusedBorder: underlineStyle,
          hintStyle: hintStyle,
      ),
      obscureText: true,
      style: labelStyle,
    );
    /* 登入按鈕 */
    final loginButton = Padding(
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
          setState((){
            _idValidate = _idController.text.isEmpty;
            _pwValidate = _pwController.text.isEmpty;}
            );
            if (!_idValidate && !_pwValidate) {
              // TODO: send {sid: _idController.text, password: _pwController.text} to backend.
              // TODO: Backend return {isLogin: bool, userData: object}.
              // @post: FormData({sid: _idController.text, password: _pwController.text})
              // @return: (isLogin) ? userData: Object(FormData?) : message: String
              bool isLogin = true;
              if(isLogin) Navigator.of(context).pushNamed(mainPageTag);
              else ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        child: Text(loginButtonText, style: titleStyle),
      ),
    );
    /* 註冊按鈕 */
    final signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: TextButton(
        style: ButtonStyle(
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(registerTag);
          },
        child: Text(signUpButtonText, style: textButtonStyle),
      ),
    );
    // 3f
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: bigRadius),
            account_id,
            SizedBox(height: smallSpace),
            password,
            SizedBox(height: buttonHeight),
            loginButton,
            signUpButton,
          ],
        ),
      ),
    );
  }
}

final routes = <String, WidgetBuilder>{
  mainPageTag: (context) => MainPage(),
  registerTag: (context) => Register(),
};