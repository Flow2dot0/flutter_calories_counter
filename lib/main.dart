import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calories_counter/widgets/custom_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calories Counter',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Calories Counter Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int base;
  int activityBase;

  bool switchItem = false;
  double dateTimeItem;
  double sliderItem = 15.0;
  double sizeValue;

  Color type = Colors.red;

  String textItem;
  String textSubmit;

  int selectActivity;

  List<String> activityList = [
    "Low",
    "Medium",
    "High"
  ];

  Map activityMap = {
    0 : 'Low',
    1 : 'Medium',
    2 : 'High',
  };

  List<Widget> activityStatusMap() {
    List<Widget> l = [];
    activityMap.forEach((key, value) {
      Column column = Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Radio(
              activeColor: type,
              value: key,
              groupValue: selectActivity,
              onChanged: (Object i) {
                setState(() {
                  selectActivity = i;
                });
              }
          ),
          customText(value, color: type,)
        ],
      );
      l.add(column);
    });
    return l;
  }

  List<Widget> activityStatus() {
    List<Widget> l = [];
    for(int i = 0; i < activityList.length; i++) {
      Column column = Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Radio(
            activeColor: type,
              value: i,
              groupValue: selectActivity,
              onChanged: (int i) {
                setState(() {
                  selectActivity = i;
                });
              }
          ),
          customText(activityList[i], color: type,)
        ],
      );
      l.add(column);
    }
    return l;
  }

  Widget sliderIsPlatform() {
    if(Platform.isIOS) {
      return CupertinoSlider(
          value: sliderItem,
          min: 15.0,
          max: 21.0,
          activeColor: type,
          onChanged: (double d) {
            setState(() {
              sliderItem = d;
              sizeValue = d*10;
            });
          }
      );
    } else {
      return  Slider(
          value: sliderItem,
          min: 15.0,
          max: 21.0,
          inactiveColor: (type==Colors.red)? Colors.red[100] : Colors.blue[100],
          activeColor: type,
          onChanged: (double d) {
            setState(() {
              sliderItem = d;
              sizeValue = d*10;
            });
          }
      );
    }
  }

  Widget methodButton() {
    if(Platform.isIOS){
      return CupertinoButton(
        child: customText("Calculate", color: Colors.white, weight: FontWeight.bold,),
        color: type,
        onPressed: checkFieldStatusAll,
      );
    }else{
      return RaisedButton(
        child: customText("Calculate", color: Colors.white, weight: FontWeight.bold,),
        color: type,
        onPressed: checkFieldStatusAll,
      );
    }
  }

  Widget ageButton() {
    if(Platform.isIOS){
      return CupertinoButton(
          child: customText("Votre age : ${(dateTimeItem!=null)? dateTimeItem.toInt() : ''}", color: Colors.white, weight: FontWeight.bold,),
          color: type,
          onPressed: showBirthDate
      );
    }else{
      return RaisedButton(
          child: customText("Votre age : ${(dateTimeItem!=null)? dateTimeItem.toInt() : ''}", color: Colors.white, weight: FontWeight.bold,),
          color: type,
          onPressed: showBirthDate
      );
    }
  }

  Widget switchIsPlatform() {
    if(Platform.isIOS) {
      return CupertinoSwitch(
          value: switchItem,
          activeColor: Colors.blue,
          onChanged: (bool b) {
            if(b) {
              type = Colors.blue;
            }else {
              type = Colors.red;
            }
            setState(() {
              switchItem = b;
            });
          }
      );
    }else {
      return Switch(
          value: switchItem,
          activeColor: Colors.blue,
          inactiveTrackColor: Colors.red,
          onChanged: (bool b) {
            if(b) {
              type = Colors.blue;
            }else {
              type = Colors.red;
            }
            setState(() {
              switchItem = b;
            });
          }
      );
    }
  }

  Widget customText(String text,
      {
        color : Colors.black,
        textAlign : TextAlign.center,
        factor,
        weight : FontWeight.normal,
        style : FontStyle.normal,
      }){
    if(Platform.isIOS) {
      return DefaultTextStyle(
          style: TextStyle(
              color: color,
              fontWeight: weight,
              fontStyle: style,
            ),
          child: Text(
            text,
            textAlign : textAlign,
            textScaleFactor : factor,
          ),
      );
    }else {
      return Text(
          text,
          textAlign : textAlign,
          textScaleFactor : factor,
          style : TextStyle(
            color: color,
            fontWeight: weight,
            fontStyle: style,
          )
      );
    }
  }

  Widget body() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          customText("Remplissez tous les champs pour obtenir votre besoin journalier en calories"),
          SizedBox(
            height: 20.0,
          ),
          Card(
            child: Container(
              height: MediaQuery.of(context).size.height/1.5,
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      customText("Femme", color: Colors.red,),
                      switchIsPlatform(),
                      customText("Homme", color: Colors.blue,),
                    ],
                  ),
                  ageButton(),
                  customText("Votre taille : ${sizeValue.toInt()} cm", color: type, factor: 1.2,),
                  sliderIsPlatform(),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (String s) {
                      textItem = s;
                    },
                    onSubmitted: (String s) {
                      textItem = s;
                      setState(() {
                        textSubmit = s;
                      });
                    },
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Entrez votre poids en kilos",
                    ),
                  ),
                  customText("Quelle est votre activité sportive ?", color: type, factor: 1.2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: activityStatusMap(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          methodButton()
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sizeValue = sliderItem*10;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      print("IOS");
    }
    else {
      print("ANDROID");
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: (Platform.isIOS)?
      CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: type,
          middle: customText(widget.title, color: Colors.white, factor: 1.5),
        ),
          child: body(),
      )
          :
      Scaffold(
        appBar: AppBar(
          title: customText("Calories Counter Demo Page", color: Colors.white,),
          backgroundColor: type,
        ),
        body: body(),
      ),
    );
  }

  DateTime lockedToMajority() {
    var lockedDate = DateTime.now();
    var get18 = lockedDate.subtract(Duration(days: 365*18));
    return get18;
  }

  Future<Null> showBirthDate() async {
    DateTime select = await showDatePicker(
        context: context,
        initialDate: lockedToMajority(),
        initialDatePickerMode: DatePickerMode.year,
        firstDate: DateTime(1900),
        lastDate: lockedToMajority(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: (type==Colors.red)? ThemeData.dark() : ThemeData.light(),
          child: child,
        );
      },
    );
    if(select!=null) {
      double d = responseAgeMethod(select);
      setState(() {
        dateTimeItem = d;
      });

    }
  }

  Future<Null> showEstimation() async {
    return showDialog(
        context: context,
      barrierDismissible: true,
      builder: (BuildContext estimationContext) {
          return SimpleDialog(
            backgroundColor: Colors.white,

            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  customText("Votre métabolisme basal est de $base", color: type,),
                  customText("Votre besoin journalier est de $activityBase", color: type,),
                ],
              )
            ],
          );
      }
    );
  }

  Future<Null> showError() async {
    return showDialog(
        context: context,
      barrierDismissible: true,
      builder: (BuildContext errorContext) {
         if(Platform.isIOS) {
           return CupertinoAlertDialog(
             title: customText("All fields are required", color: type,),
             actions: <Widget>[
               CupertinoButton(
                   child: customText("OK", color: type),
                   onPressed: () {
                     Navigator.pop(errorContext);
                   }
               )
             ],
           );
         }else {
           return AlertDialog(
             backgroundColor: type,
             title: customText("All fields are required", color: Colors.white,),
             actions: <Widget>[
               RaisedButton(
                   child: customText("OK", color: type),
                   color: Colors.white,
                   onPressed: () {
                     Navigator.pop(errorContext);
                   }
               )
             ],
           );
         }
      }
    );
  }

  void checkFieldStatusAll() {
    if(switchItem!=null && dateTimeItem!=null && sliderItem!=null && textItem!=null && selectActivity!=null){
      base = methodCalCount();
      activityBase = (methodActivityCount()*base).toInt();
      showEstimation();
    }else {
      showError();
    }
  }

  double responseAgeMethod(DateTime date) {
    var dateSelected = date;
    var dateNow = DateTime.now();
    var difference = dateNow.difference(dateSelected);
    double d = (difference.inDays/365).toDouble();
    return d;
  }

  int methodCalCount() {
    double weight = double.parse(textItem);
    if(type==Colors.red) {
      double x = 655.0955 + (9.5634*weight) + (1.8496*sizeValue) - (4.6756*dateTimeItem);
      return x.toInt();
    }
    else {
      double x = 666.4730 + (13.7516*weight) + (5.0033*sizeValue) - (6.7550*dateTimeItem);
      return x.toInt();
    }
  }

  double methodActivityCount() {
    switch(selectActivity) {
      case 0:
        double r = 1.2;
        return r;
      case 1:
        double r = 1.5;
        return r;
      case 2:
        double r = 1.8;
        return r;
      default :
        return 1.00;
        break;
    }
  }

}
