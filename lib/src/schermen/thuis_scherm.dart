import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zonnewijzer/src/gereedschappen/daten.dart';
import 'package:zonnewijzer/src/logica/kalender.dart';
import 'dart:math' as math;

import 'package:zonnewijzer/src/modellen/zonnetijd.dart';

class ThuisScherm extends StatefulWidget {
  const ThuisScherm({Key? key}) : super(key: key);
  static String routeNaam = '/zonnewijzer';

  @override
  State<ThuisScherm> createState() => _ThuisSchermState();
}

class _ThuisSchermState extends State<ThuisScherm> {
  final Kalender kalender = Kalender();
  double _hours = 0;
  double _minutes = 0;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _calculateTime();
  // }

  // void _calculateTime() {
  //   DateTime now = DateTime.now();
  //   setState(() {
  //     _hours = now.hour + now.minute / 60;
  //     _minutes = now.minute + now.second / 60;
  //     Timer(Duration(seconds: 5), _calculateTime);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/jerusalem.jpg'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: StreamBuilder<Zonnetijd>(
                  stream: kalender.krijgZonnetijdStroom(),
                  builder: (context, snapshot) {
                    print(snapshot.data?.uur);
                    return !snapshot.hasData
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${talen['nederlands']['weekdagen'][snapshot.data!.weekdag]}, ${snapshot.data!.dag}.${snapshot.data!.joodseMaand}',
                                style: TextStyle(
                                  fontFamily: 'Gentium',
                                  fontSize: 30.0,
                                ),
                              ),
                              Divider(
                                thickness: 2.0,
                              ),
                              Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/clock1.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      height: 200,
                                    ),
                                    Container(
                                      transform: Matrix4.rotationZ(
                                          snapshot.data!.uur * math.pi / 6),
                                      transformAlignment:
                                          FractionalOffset.center,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/hour.png'),
                                            fit: BoxFit.contain),
                                      ),
                                      height: 200,
                                    ),
                                    Container(
                                      transform: Matrix4.rotationZ(
                                          snapshot.data!.uur * math.pi * 2),
                                      transformAlignment:
                                          FractionalOffset.center,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/minute1.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      height: 200,
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 2.0,
                              ),
                              Text(
                                '${talen['nederlands']['maanden'][snapshot.data?.hidjriMaand ?? 0]} ${snapshot.data?.hidjriJaar ?? 0}',
                                style: TextStyle(
                                  fontFamily: 'Gentium',
                                  fontSize: 30.0,
                                ),
                              ),
                              Text(
                                talen['nederlands']['groeten'][
                                    tijden.indexWhere((element) =>
                                        element <= (snapshot.data?.uur ?? 0))],
                                style: TextStyle(
                                  fontFamily: 'Gentium',
                                  fontSize: 40.0,
                                ),
                              ),
                            ],
                          );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
