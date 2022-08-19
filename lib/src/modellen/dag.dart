import 'dart:math' as math;

import 'locatie.dart';

class Dag {
  final int dagInHetJaar;
  final DateTime vandaag;
  final int nieweMaandInHetJaar;
  final Locatie locatie;
  late final int _vertraging;
  late final int _halfDag;
  late final DateTime _zonsOpgang;
  late final DateTime _zonsOndergang;

  DateTime get zonsOpgang => _zonsOpgang;
  DateTime get zonsOndergang => _zonsOndergang;

  Dag({
    required this.dagInHetJaar,
    required this.vandaag,
    required this.nieweMaandInHetJaar,
    this.locatie = const Locatie(breedte: 47.475683, lengte: 8.22245),
  }) {
    _vertraging = _berekenVertraging();
    _halfDag = _berekenHalfDag();
    _zonsOpgang = DateTime(
      vandaag.year,
      vandaag.month,
      vandaag.day,
      12,
      0,
      0,
      _vertraging - _halfDag,
    );
    _zonsOndergang = DateTime(
      vandaag.year,
      vandaag.month,
      vandaag.day,
      12,
      0,
      0,
      _vertraging + _halfDag,
    );
  }

  int _berekenVertraging() {
    double basis =
        vandaag.timeZoneOffset.inMilliseconds - locatie.lengte * 240000;
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
