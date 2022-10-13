import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lab_assignment/model/weather_model.dart';
import 'package:lab_assignment/serivce/weather_api_client.dart';
import 'package:lab_assignment/views/current_weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: home(),
    );
  }
}

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  WeatherApiClient client = WeatherApiClient();
  TextEditingController name = new TextEditingController();
  String cityname = "";

  Weather data = Weather();
  Future<void> getData() async {
    data = (await client.getCurrentWeather(cityname))!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFf9f9f9),
        appBar: AppBar(
     
          elevation: 0.0,
          title:
              const Text("Weather App", style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 18),
                    child: TextField(
                      controller: name,
                      autocorrect: true,
                      decoration: const InputDecoration(
                        hintText: 'City Name',
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white70,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.black26, width: 2),
                        ),
                        labelText: 'City',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        String city = name.text.toString();
                        setState(() {
                          cityname = city;
                        });
                      },
                      child: const Text(
                        'Search',
                        style: TextStyle(color: Colors.black),
                      )),
                  currentWeather(Icons.sunny_snowing,"${data.temp}",
                      "${data.cityName}"),
                  SizedBox(
                    height: 60,
                  ),
               
                  SizedBox(
                    height: 20.0,
                  ),
                  
                  Card(elevation: 50,
          shadowColor: Colors.black,
          color: Colors.greenAccent[100],
          
          ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListTile(title: Text("wind"),trailing: Text("${data.wind}"),),
                       ListTile(title: Text("humidity"),trailing: Text("${data.humidity}"),),
                        ListTile(title: Text("pressure"),trailing: Text("${data.pressure}"),),
                   
                    ],
                  )
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            return Container();
          },
        ));
  }
}
