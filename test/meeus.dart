import 'dart:math';

void main() {
  String twoDig(num number) {
    String prefix = number < 10 ? '0' : '';
    return '$prefix$number';
  }

  String secondsToTime(num daySeconds) {
    var hours = twoDig(daySeconds ~/ 3600);
    var minutes = twoDig(daySeconds ~/ 60 % 60);
    var seconds = twoDig(daySeconds % 60);
    return '$hours:$minutes:$seconds';
  }

  /// sin(h) = sin(phi)sin(delta)+cos(phi)cos(delta)cos(H)
  /// h: 'Null'punkt, 5/6°
  /// phi: gegraphische Breite
  /// delta: Deklination
  /// sin(h)-sin(phi)sin(delta) = cos(phi)cos(delta)cos(H)
  /// cosH = (sin(h)-sin(phi)sin(delta))/(cos(phi)cos(delta))
  ///
  /// [heightAtHorizon], [latitude] und [declination] sind in Winkelmass (Radian) anzugeben
  double getHourAngle({
    required num heightAtHorizon,
    required num latitude,
    required num declination,
  }) {
    var dividend = sin(heightAtHorizon) - sin(latitude) * sin(declination);
    var divisor = cos(latitude) * cos(declination);
    var cosHourAngle = dividend / divisor;
    return acos(cosHourAngle);
  }

  // Julianisches Datum um 0h UT
  double getJulianDate(DateTime dateTime) {
    var millisecondsOfDateTime = dateTime.toUtc().millisecondsSinceEpoch;
    var julianDate = 2440587.5 + millisecondsOfDateTime / 86400000;
    return julianDate;
  }

  // T: Julianische Säkula
  double getJulianSaec(num julianDate) => (julianDate - 2451545) / 36525;

  /// gibt die scheinbare Sternzeit um 0h UT in Greenwich an. in Sekunden
  double getApparentSidTime(num julianDate) {
    var julianSaec = getJulianSaec(julianDate);
    var gsmt = 24110.54841 +
        8640148.812866 * julianSaec +
        0.093104 * julianSaec * julianSaec -
        0.0000062 * julianSaec * julianSaec * julianSaec;
    var hours = (julianDate + 0.5) % 1;
    return (gsmt + hours * 86400) % 86400;
  }

  double getApSidTimeZero(num julianDate) {
    julianDate = (julianDate - 0.5).floorToDouble() + 0.5;
    return getApparentSidTime(julianDate);
  }

  double getDeltaT(DateTime date) {
    var years = (date.millisecondsSinceEpoch - 1420070400000) / 31556952000;
    var deltaT = 67.62 + 0.3645 * years + 0.0039755 * years * years;
    return deltaT;
  }

  DateTime getDtDate(DateTime date) {
    var deltaT = (1000 * getDeltaT(date)).toInt();
    return date.subtract(Duration(milliseconds: deltaT));
  }

  var date = DateTime.utc(1988, 3, 20);
  var dtDate = getDtDate(date);
  var julianDate = getJulianDate(date);
  var capThetaZero = getApSidTimeZero(julianDate);
  var julianDtDate = getJulianDate(dtDate);
  var sidTime = getApparentSidTime(julianDtDate);
  print(secondsToTime(capThetaZero));
}
