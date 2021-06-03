import 'package:flutter/material.dart';

// Test
var userData = manchen;
var pRideList = [pRide];
var dRideList = [dRide];
var pList = [yalee];
var dList = [tsay];

// Color
Color appBackgroundColor = Color.fromRGBO(249, 249, 249, 1.0);
Color appMainColor = Color.fromRGBO(61, 59, 64, 1.0);
Color appWhiteColor = Color.fromRGBO(61, 59, 64, 1.0);

// Style
final labelStyle = TextStyle(
  fontSize: 18.0,
  color: appWhiteColor,
);
final textButtonStyle = TextStyle(
  fontSize: 18.0,
  color: appWhiteColor,
    decoration: TextDecoration.underline,
);
final hintStyle = TextStyle(
  color: appWhiteColor,
);
final underlineStyle = UnderlineInputBorder(
  borderSide: BorderSide(color: appMainColor, width: 2.5),
);
final titleStyle = TextStyle(fontSize: 24.0, color: appBackgroundColor);
final nameStyle = TextStyle(fontSize: 24.0, color: appMainColor);
final attrStyle = TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: appWhiteColor);
final dataStyle = TextStyle(fontSize: 18.0, color: appWhiteColor);

// String
/* Title */
const appTitle = "Buber-Bike";
const reqTitle = "Request";
/* HintText */
const idHintText = "Account ID";
const pwHintText = "Password";
/* ButtonText */
const loginButtonText = "Login";
const signUpButtonText = "Sign up";
const beADriverButtonText = "Wanna be a driver?";
const wallButtonText = "Take a ride!";
const saveChangeButtonText = "Save changes";
const chooseImageButtonText = "Upload your bike license!";
const uploadImageButtonText = "Upload";
const sendButtonText = "Send";
/* Validator & ErrorText */
const idIsEmptyText = "Please enter your ID.";
const pwIsEmptyText = "Please enter your password.";
const nameIsEmptyText = "Name cannot be empty.";
const deptIsEmptyText = "Dep. cannot be empty.";
const gradeIsEmptyText = "Grade cannot be empty.";
const startIsEmptyText = "Please enter a starting point.";
const destIsEmptyText = "Please enter a destination.";
const loginFailedText = "Login failed";
/* Alert */
const logoutAlertTitle = "Logout";
const logoutAlertText = "Are you sure to logout?";
const discardAlertTitle = "Discard";
const discardAlertText = "Are you sure to discard your changes?";
const declinedAlertTitle = "Decline";
const declinedAlertText = "Are you sure to decline the request?";
const disable = '-';
/* Attribute */
const nameAttr = "Name";
const genderAttr = "Gender";
const deptAttr = "Dep.";
const gradeAttr = "Grade";
const statusAttr = "Status";
const rateAttr = "Ratings";
const prateAttr = "Passenger";
const drateAttr = "Driver";
const startAttr = "Starting Point";
const destAttr = "Destination";
/* Scaffold Message */
const uploadImageHintText = "You should upload your bike license.";
const queryHintText = "Query";
/* Others */
const driverReceivedText = " needs your help!";
const pasWaitText = "Waiting for response...";
const pasAcceptedText = " accepted the request.";
const DeclinedText = " declined the request.";
const driverAcceptedText = "Request from ";
const FinishedText = "Have a nice day!";
const chooseLocationText = "Enter a starting point and a destination.";
const noRequestText = "No request";

// List
const statusList = [prateAttr, drateAttr];
const genderList = ['M', 'F', '-'];
const deptList = [];
const startList = ['A', 'B', 'C', 'D', 'E'];
const destList = ['1', '2', '3', '4', '5'];
const tabPList = [prateAttr];
const tabDList = [prateAttr, drateAttr];
var driverList = [yalee, tsay, kong, Ayee, kong, kong, kong,];

// Pages
const loginTag = 'Login';
const mainPageTag = 'MainPage';
const registerTag = 'Register';
const modifiedTag = 'Modified';
const notificationTag = 'Notification';
const wallTag = 'Wall';

// Images
Image appLogo = Image.asset('assets/images/buber-bike-logo2.png');
Image appIcon = Image.asset('assets/icons/icon1.jpg');

// Sizes
const bigRadius = 65.0;
const smallSpace = 5.0;
const buttonHeight = 24.0;

// User
class User {
  var sid;
  var name;
  var password;
  var dept;
  var grade;
  var gender;
  var is_driver;
  var cert;
  double prate;
  double drate;

  User(this.sid, this.name, this.password, this.dept, this.grade, this.gender,
      this.is_driver, this.cert, this.prate, this.drate);
}

var manchen = new User('manchen', '曼成', '005', 'IM', '3', 'F',
    0, '', 3.0, -1);
var yalee = new User('yalee', '雅麗', 'CSwoman', 'IM', 'P', 'F',
                  1, '', 4.0, 3.0);
var tsay = new User('tsay', '益坤', 'algorithm', 'IM', 'P', 'M',
    1, '', 2.0, 1.0);
var kong = new User('kong', '令傑', 'thinking', 'IM', 'P', 'M',
    1, '', 3.5, 5.0);
var Ayee = new User('Ayee', '阿姨', 'statistics', 'IM', 'P', 'F',
    1, '', 2.5, 3.0);

// Ride

class Ride {
  var pid;
  var did;
  var s;
  var d;
  var state;
  double prate;
  double drate;

  Ride(this.pid, this.did, this.s, this.d, this.state, this.prate, this.drate);
}
var pRide = new Ride(userData.sid, tsay.sid, 'A', '2', 1, -1, -1);
// var pRide = new Ride(userData.sid, tsay.sid, 'B', '3', 1, -1, -1);
var dRide = new Ride(yalee.sid, userData.sid, 'D', '2', 0, -1, -1);