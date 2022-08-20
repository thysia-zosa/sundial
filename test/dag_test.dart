// import 'package:zonnewijzer/src/modellen/dag.dart';
// import 'package:zonnewijzer/src/modellen/gregoriaans_jaar.dart';
// import 'package:zonnewijzer/src/modellen/maand.dart';

// void main() {
//   DateTime vandaag = DateTime.now().subtract(const Duration(hours: 19));
//   DateTime oudJaar = DateTime(vandaag.year - 1, 12, 31);
//   GregoriaansJaar vanjaar = GregoriaansJaar(vandaag.year);
//   int dagInhetJaar = vandaag.difference(oudJaar).inDays;
//   dagInhetJaar -= vanjaar.isSchrikkelJaar && dagInhetJaar > 55 ? 1 : 0;
//   Dag a = Dag(
//     dagInHetJaar: dagInhetJaar,
//     datum: vandaag,
//     maand: Maand(
//         gregoriaansJaar: vandaag.year,
//         epacta: vanjaar.epacta,
//         nieuweMaandInHetJaar: vanjaar.nieweMaanden
//             .firstWhere((element) => element >= dagInhetJaar)),
//   );
//   print(a.zonsOpgang);
//   print(a.zonsOndergang);
//   print(dagInhetJaar);
//   print(vandaag);
//   print(oudJaar);
// }

import 'dart:io';

import 'package:zonnewijzer/src/logica/kalender.dart';
import 'package:zonnewijzer/src/modellen/zonnetijd.dart';

void main() {
  Kalender kal = Kalender();
  Zonnetijd tijd = kal.krijgZonnetijd(1);
  stdout.writeln(tijd.toString());
}
