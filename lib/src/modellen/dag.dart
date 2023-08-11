import 'dart:math' as math;

import 'hebreeuws_datum.dart';
import 'locatie.dart';
import 'maand.dart';

class Dag {
  final int dagInHetJaar;
  final DateTime datum;
  final Maand maand;
  final Locatie locatie;
  final HebreeuwsDatum hebreeuwsDatum;
  late final int _vertraging;
  late final int _halfDag;
  late final int _zonsOpgang;
  late final int _zonsOndergang;

  int get zonsOpgang => _zonsOpgang;
  int get zonsOndergang => _zonsOndergang;
  int get maandDag => dagInHetJaar - maand.nieuweMaandInHetJaar + 1;

  Dag({
    required this.dagInHetJaar,
    required this.datum,
    required this.maand,
    this.locatie = const Locatie(breedte: 47.475683, lengte: 8.22245),
  }) : hebreeuwsDatum = HebreeuwsDatum(datum: datum) {
    _vertraging = _berekenVertraging();
    _halfDag = _berekenHalfDag();
    _zonsOpgang = DateTime(
      datum.year,
      datum.month,
      datum.day,
      12,
      0,
      0,
      _vertraging - _halfDag,
    ).millisecondsSinceEpoch;
    _zonsOndergang = DateTime(
      datum.year,
      datum.month,
      datum.day,
      12,
      0,
      0,
      _vertraging + _halfDag,
    ).millisecondsSinceEpoch;
  }

  int _berekenVertraging() {
    double basis =
        datum.timeZoneOffset.inMilliseconds - locatie.lengte * 240000;
    return (basis +
            615600 * math.sin(0.0337 * dagInHetJaar + 0.465) +
            442440 * math.sin(0.01787 * dagInHetJaar - 0.168))
        .round();
  }

  int _berekenHalfDag() {
    double phi = locatie.breedte * math.pi / 180;
    double epsilon = 23.43 *
        math.pi /
        180 *
        math.sin(
          (dagInHetJaar - 80) * math.pi / 182.5,
        );
    return (math.acos((0 -
                    math.sin(math.pi / 360) -
                    math.sin(epsilon) * math.sin(phi)) /
                (math.cos(epsilon) * math.cos(phi))) *
            43200000 /
            math.pi)
        .round();
  }
}
