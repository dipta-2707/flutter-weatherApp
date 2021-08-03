
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future<void> showInformationDialog(BuildContext context) async{
    return await showDialog(context: context, 
    builder: (context){
      return AlertDialog(
        content: Text('Something went wrong'),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text('ok'))
        ],
      );
    });
  }
  var city = "Dhaka";
  // var url = "http://api.openweathermap.org/data/2.5/weather?q=dhaka&appid=87a5903331cabf9d69fe0623c92f6151";
  var temp;
  var tempinF;
  var wind;
  var des;

  final cityCon = new TextEditingController();

  Future _getWeatherData() async {
    try {
      http.Response response = await http.get(Uri.parse(
          "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=87a5903331cabf9d69fe0623c92f6151"));
      var result = jsonDecode(response.body);
      setState(() {
        this.temp = result['main']['temp'];
        temp = (temp - 273.15);
        this.tempinF = (temp * 1.8) + 32;
        this.wind = result['wind']['speed'] * 3.6;
        this.des = result['weather'][0]['description'];
      });
    } catch (_) {
      print("error in try");
      setState(() {
        city = "null";
      });

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getWeatherData();
  }

  Widget _search() {
    print('here');
    return IconButton(
        icon: FaIcon(FontAwesomeIcons.search),
        onPressed: () {
          city = cityCon.text;
          initState();
          print('data changed by search');
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                //height: MediaQuery.of(context).size.height/3,
                // width: MediaQuery.of(context).size.width,
                height: 200,
                color: Colors.red[900],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(bottom: 10.0)),
                    Text(
                      'Weather in $city',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'cursive'),
                    ),
                    Text(
                      temp != null
                          ? temp.toStringAsFixed(2) + '\u00B0C'
                          : 'Loding',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 45.0,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                )),
            Expanded(
                child: ListView(
              children: [
                ListTile(
                  tileColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  leading: FaIcon(FontAwesomeIcons.temperatureHigh),
                  title: Text('Tempareture',
                      style: TextStyle(fontFamily: 'cursive', fontSize: 20.0)),
                  trailing: Text(
                      tempinF != null
                          ? tempinF.toStringAsFixed(2) + '\u00B0F'
                          : 'Loding',
                      style: TextStyle(fontSize: 23.0)),
                ),
                ListTile(
                  tileColor: Colors.blue,
                  leading: FaIcon(FontAwesomeIcons.cloud),
                  title: Text('Weather',
                      style: TextStyle(fontFamily: 'cursive', fontSize: 20.0)),
                  trailing: Text(
                    des != null ? des.toString() : "Loding",
                    style: TextStyle(fontSize: 23.0),
                  ),
                ),
                ListTile(
                  tileColor: Colors.deepPurple,
                  leading: FaIcon(FontAwesomeIcons.wind),
                  title: Text('Wind',
                      style: TextStyle(fontFamily: 'cursive', fontSize: 20.0)),
                  trailing: Text(
                      wind != null
                          ? wind.toStringAsFixed(2) + ' k/h'
                          : "Loding",
                      style: TextStyle(fontSize: 23.0)),
                ),
              ],
            )),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                
                hintText: 'Enter City Name',
                //suffixIcon: _search(),
              ),
              textInputAction: TextInputAction.go,
             
              controller: cityCon,
            ),
            ElevatedButton(
              child: Text('Search'),
              onPressed: () {
                city = cityCon.text;
                _getWeatherData();
                print('data changed');
              },
            )
          ],
        ),
      ),
    );
  }
}
