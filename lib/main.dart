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

  bool switchItem = false;
  DateTime dateTimeItem;
  double sliderItem = 15.0;

  Color type = Colors.red;

  String textItem;
  String textSubmit;

  int selectActivity;
  List<String> activityList = [
    "Low",
    "Medium",
    "High"
  ];

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
          CustomText(activityList[i], color: type,)
        ],
      );
      l.add(column);
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: CustomText("Calories Counter Demo Page", color: Colors.white,),
          backgroundColor: type,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomText("Remplissez tous les champs pour obtenir votre besoin journalier en calories"),
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
                          CustomText("Femme", color: Colors.red,),
                          Switch(
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
                          ),
                          CustomText("Homme", color: Colors.blue,),
                        ],
                      ),
                      RaisedButton(
                        child: CustomText("Votre age : ${(dateTimeItem!=null)? responseAgeMethod().toInt() : ''}", color: Colors.white, weight: FontWeight.bold,),
                          color: type,
                          onPressed: showBirthDate
                      ),
                      CustomText("Votre taille : ${sliderItem.toInt()*10} cm", color: type, factor: 1.2,),
                      Slider(
                          value: sliderItem,
                          min: 15.0,
                          max: 21.0,
                          inactiveColor: (type==Colors.red)? Colors.red[100] : Colors.blue[100],
                          activeColor: type,
                          onChanged: (double d) {
                            setState(() {
                              sliderItem = d;
                            });
                          }
                      ),
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
                      CustomText("Quelle est votre activité sportive ?", color: type, factor: 1.2,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: activityStatus(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                child: CustomText("Calculate", color: Colors.white, weight: FontWeight.bold,),
                  color: type,
                  onPressed: checkFieldStatusAll,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> showBirthDate() async {
    DateTime select = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.year,
        firstDate: DateTime(1900),
        lastDate: DateTime(2050),
    );
    if(select!=null) {
      setState(() {
        dateTimeItem = select;
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
                  CustomText("Votre métabolisme basal est de ${methodCalCount()} ", color: type,),
                  CustomText("Votre besoin journalier est de ${(methodCalCount().toDouble()*methodActivityCount()).toInt()}", color: type,),
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
          return AlertDialog(
            backgroundColor: Colors.red,
            title: CustomText("All fields are required", color: Colors.white,),
          );
      }
    );
  }

  void checkFieldStatusAll() {
    if(switchItem!=null && dateTimeItem!=null && sliderItem!=null && textItem!=null && selectActivity!=null){
      showEstimation();
    }else {
      showError();
    }
  }

  double responseAgeMethod() {
    var dateSelected = dateTimeItem;
    var dateNow = DateTime.now();
    var difference = dateNow.difference(dateSelected);
    double d = (difference.inDays/365).toDouble();
    return d;
  }

  int methodCalCount() {
    double weight = double.parse(textItem);
    if(type==Colors.red) {
      double x = 655.0955 + (9.5634*weight) + (1.8496*sliderItem) - (4.6756*responseAgeMethod());
      return x.toInt();
    }
    else {
      double x = 666.4730 + (13.7516*weight) + (5.0033*sliderItem) - (6.7550*responseAgeMethod());
      return x.toInt();
    }
  }

  double methodActivityCount() {
    switch(activityList[selectActivity]) {
      case "Low":
        double r = 1.2;
        return r;
      case "Medium":
        double r = 1.5;
        return r;
      case "High":
        double r = 1.8;
        return r;
    }
  }

}
