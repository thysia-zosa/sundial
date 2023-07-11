import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../gereedschappen/daten.dart' as daten;
import '../logica/kalender.dart';
import '../modellen/zonnetijd.dart';

class ThuisScherm extends StatefulWidget {
  const ThuisScherm({Key? key}) : super(key: key);
  static String routeNaam = '/';

  @override
  State<ThuisScherm> createState() => _ThuisSchermState();
}

class _ThuisSchermState extends State<ThuisScherm> {
  final Kalender kalender = Kalender();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
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
                    return !snapshot.hasData
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${daten.talen['nederlands']['weekdagen'][snapshot.data!.weekdag]}\n${snapshot.data!.dag} ${daten.talen['nederlands']['maanden'][snapshot.data!.isSchrikkelMaand ? 0 : snapshot.data!.joodseMaand]} ${snapshot.data!.joodsJaar + 1744}',
                                style: const TextStyle(
                                  fontFamily: 'Gentium',
                                  fontSize: 30.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Divider(
                                thickness: 2.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/clock.png'),
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
                                              'assets/images/minute.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      height: 200,
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness: 2.0,
                              ),
                              // Text(
                              //   '${daten.talen['nederlands']['maanden'][snapshot.data?.hidjriMaand ?? 0]} ${snapshot.data?.hidjriJaar ?? 0}',
                              //   style: const TextStyle(
                              //     fontFamily: 'Gentium',
                              //     fontSize: 30.0,
                              //   ),
                              // ),
                              Text(
                                daten.talen['nederlands']['groeten'][
                                    daten.tijden.indexWhere((element) =>
                                        element <= (snapshot.data?.uur ?? 0))],
                                style: const TextStyle(
                                  fontFamily: 'Gentium',
                                  fontSize: 40.0,
                                ),
                                textAlign: TextAlign.center,
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
