// import 'dart:async';

// void main() async {
//   await Future.delayed(Duration(seconds: 10));
//   krijgZonnetijd().listen((event) {
//     print(event);
//   });
// }

// Stream<int> krijgZonnetijd() {
//   int k = 0;
//   return Stream<int>.periodic(const Duration(seconds: 2), (_) => ++k);
// }

import 'dart:io';

import 'package:zonnewijzer/src/logica/kalender.dart';

void main() {
  Kalender kalender = Kalender();
  kalender.krijgZonnetijdStroom().listen((tijd) {
    int uur = tijd.uur.toInt();
    double minuut = tijd.uur.remainder(1) * 60;
    stdout.writeln('$uur:$minuut');
  });
}
