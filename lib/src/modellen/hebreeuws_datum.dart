import '../gereedschappen/constanten.dart';
import 'hebreeuws_jaar.dart';

class HebreeuwsDatum {
  final DateTime datum;
  final int juliaansDatum;
  late final int hebreeuwseDag;
  late final int hebreeuwseMaand;
  late final HebreeuwsJaar hebreeuwsJaar;
  late final int weekDagNummer;
  late final int arabischeMaand;
  late final int arabischJaar;

  HebreeuwsDatum({required this.datum})
      : juliaansDatum = berekenJuliaansDatum(datum) {
    weekDagNummer = weekDagVanJuliaansDatum(juliaansDatum);
    _berekenHebreeuwsDatum();
    _berekenArabischDatum();
  }

  static int berekenJuliaansDatum(DateTime datum) {
    int maand = (datum.month + 9) % 12;
    int jaar = datum.year;
    if (maand > 9) jaar--;
    int juliaansDatum = (jaar * 365.25).floor() +
        (maand * 30.6 + 0.5).floor() +
        datum.day +
        1721117;
    if (juliaansDatum > 2299170) {
      juliaansDatum += 2 + jaar ~/ 400 - jaar ~/ 100;
    }
    return juliaansDatum;
  }

  static int weekDagVanJuliaansDatum(int juliaansDatum) {
    return (juliaansDatum + 1) % 7;
  }

  void _berekenHebreeuwsDatum() {
    int hebreeuwsEpochDag = juliaansDatum - 347997;
    int maandGetal = hebreeuwsEpochDag ~/ kHebreeuwseMaandLengte;
    int afgelopenCyclussen = (maandGetal - 1) ~/ 235;
    maandGetal -= afgelopenCyclussen * 235;
    int jaarGetal = afgelopenCyclussen * 19 +
        1 +
        (maandGetal + 0.94) ~/ kHebreeuwseJaarLengte;
    HebreeuwsJaar jaar = HebreeuwsJaar(jaar: jaarGetal);
    if (jaar.vooravondRosjHasjana >= hebreeuwsEpochDag) {
      jaar = HebreeuwsJaar(jaar: --jaarGetal);
    }
    int dagInDitJaar = hebreeuwsEpochDag - jaar.vooravondRosjHasjana;
    int dagGetal = (dagInDitJaar + 205) % jaar.lengte;

    // TODO: dat moet je nog uitleggen!
    if (dagGetal < 265) {
      dagGetal++;
      maandGetal = dagGetal ~/ 29.55;
      dagGetal -= (maandGetal * 29.5).floor();
    } else {
      dagGetal -= 264;
      switch (jaar.lengte) {
        case 353:
        case 383:
          maandGetal = (dagGetal + 0.15) ~/ 29.55;
          dagGetal -= (maandGetal * 29.4).floor();
          maandGetal += 9;
          break;
        case 354:
        case 384:
          maandGetal = (dagGetal - 0.95) ~/ 29.52;
          dagGetal -= (maandGetal * 29.5 + 0.9).floor();
          maandGetal += 9;
          break;
        case 355:
        case 385:
          maandGetal = (dagGetal - 1.95) ~/ 29.52 + 1;
          dagGetal += 29 - (maandGetal * 29.6 + 0.9).floor();
          maandGetal += 8;
          break;
        default:
      }
    }
    hebreeuwsJaar = jaar;
    hebreeuwseMaand = maandGetal;
    hebreeuwseDag = dagGetal;
  }

  void _berekenArabischDatum() {
    int maanden = hebreeuwseMaand - 6;
    if (hebreeuwseMaand < 7) {
      maanden += 12;
      if (hebreeuwsJaar.isSchrikkeljaar) maanden++;
    }
    int afgelopenCyclussen = hebreeuwsJaar.jaar ~/ 19;
    int afgelopenCyclusjaaren = hebreeuwsJaar.jaar % 19;
    int afgelopenCyclusmaanden = (afgelopenCyclusjaaren * 12.37 + 0.06).floor();
    maanden += afgelopenCyclussen * 235 + afgelopenCyclusmaanden - 54197;
    arabischJaar = maanden ~/ 12;
    arabischeMaand = maanden % 12;
  }
}
