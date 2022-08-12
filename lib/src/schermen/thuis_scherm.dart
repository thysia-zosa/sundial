import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class ThuisScherm extends StatefulWidget {
  const ThuisScherm({Key? key}) : super(key: key);
  static String routeNaam = '/zonnewijzer';

  @override
  State<ThuisScherm> createState() => _ThuisSchermState();
}

class _ThuisSchermState extends State<ThuisScherm> {
  double _hours = 0;
  double _minutes = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calculateTime();
  }

  void _calculateTime() {
    DateTime now = DateTime.now();
    setState(() {
      _hours = now.hour + now.minute / 60;
      _minutes = now.minute + now.second / 60;
      Timer(Duration(seconds: 5), _calculateTime);
    });
  }

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tweedag, 10.5',
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
                              image: AssetImage('assets/images/clock1.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                          height: 200,
                        ),
                        Container(
                          transform: Matrix4.rotationZ(_hours * math.pi / 6),
                          transformAlignment: FractionalOffset.center,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/hour.png'),
                                fit: BoxFit.contain),
                          ),
                          height: 200,
                        ),
                        Container(
                          transform: Matrix4.rotationZ(_minutes * math.pi / 30),
                          transformAlignment: FractionalOffset.center,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/minute1.png'),
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
                    'Moeharram 1444',
                    style: TextStyle(
                      fontFamily: 'Gentium',
                      fontSize: 30.0,
                    ),
                  ),
                  Text(
                    'Middaggebed',
                    style: TextStyle(
                      fontFamily: 'Gentium',
                      fontSize: 40.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
