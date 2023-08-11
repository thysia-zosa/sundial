import '../gereedschappen/constanten.dart';

class HebreeuwsJaar {
  final int jaar;
  final int vooravondRosjHasjana;
  final int vooravondVolgendRosjHasjana;
  late final int lengte;

  bool get isSchrikkeljaar => isHetEenSchrikkeljaar(jaar);

  HebreeuwsJaar({required this.jaar})
      : vooravondRosjHasjana = berekenVooravondRosjHasjana(jaar),
        vooravondVolgendRosjHasjana = berekenVooravondRosjHasjana(jaar + 1) {
    lengte = vooravondVolgendRosjHasjana - vooravondRosjHasjana;
  }

  static int berekenVooravondRosjHasjana(int jaar) {
    int jaarGetal = jaar - 1;
    int afgelopenCyclussen = jaarGetal ~/ 19;
    int afgelopenCyclusjaaren = jaarGetal % 19;
    int afgelopenCyclusmaanden = (afgelopenCyclusjaaren * 12.37 + 0.06).floor();
    int chalaqim = afgelopenCyclussen * kCyclusCharakter +
        afgelopenCyclusmaanden * kMaandCharakter +
        kEpochCharakter;
    int afgelopenDagen = afgelopenCyclussen * kCyclusInDagen +
        afgelopenCyclusmaanden * 29 +
        chalaqim ~/ kDagInChalaqim;
    chalaqim %= kDagInChalaqim;
    int weekDagGetal = afgelopenDagen % 7;

    // Betutaqpat
    if (isHetEenSchrikkeljaar(jaar) &&
        weekDagGetal == 0 &&
        chalaqim >= kBetutaqpat) {
      chalaqim = kMiddag;
    }
    // Gatrad
    if (!isHetEenSchrikkeljaar(jaar + 1) &&
        weekDagGetal == 1 &&
        chalaqim >= 9924) {
      chalaqim = kMiddag;
    }
    // Jach
    if (chalaqim >= kMiddag) {
      afgelopenDagen++;
    }
    // Adu
    weekDagGetal = afgelopenDagen % 7; // aktualiseering
    if ([2, 4, 6].contains(weekDagGetal)) {
      afgelopenDagen++;
    }

    return afgelopenDagen;
  }

  static bool isHetEenSchrikkeljaar(int jaar) =>
      [3, 6, 8, 11, 14, 17, 19].contains((jaar - 1) % 19 + 1);
}
