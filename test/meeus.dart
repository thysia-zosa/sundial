import 'dart:io';
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

  double degToRad(num degree) => pi * degree / 180;

  double degMinSecToRad(
    int sign,
    int degree,
    int minute,
    num second,
  ) {
    return sign * degToRad(degree + minute / 60 + second / 3600);
  }

  double secondsToRad(num seconds) => seconds * pi / 43200;

  double timeToRad(
    int hour,
    int minute,
    num second,
  ) {
    return secondsToRad(hour * 3600 + minute * 60 + second);
  }

  double radToDeg(num radians) => 180 * radians / pi;

  double modRad(num radians) {
    return (radians + 2 * pi) % (2 * pi);
  }

  /// interpolation:
  /// y = y2 + n/2 * (a+b+nc)
  /// y123: 1., 2., 3. Wert
  /// n: Bruchteil
  /// a: y2 - y1
  /// b: y3 - y2
  /// c: b - a
  double interpolation({
    required num firstTerm,
    required num middleTerm,
    required num thirdTerm,
    required num part,
  }) {
    var a = middleTerm - firstTerm;
    var b = thirdTerm - middleTerm;
    var c = b - a;
    var value = middleTerm + part * (a + b + part * c) / 2;
    return value;
  }

  /// sin(h) = sin(phi)sin(delta)+cos(phi)cos(delta)cos(H)
  /// h: 'Null'punkt, 5/6°
  /// phi: gegraphische Breite
  /// delta: Deklination
  /// sin(h)-sin(phi)sin(delta) = cos(phi)cos(delta)cos(H)
  /// cosH = (sin(h)-sin(phi)sin(delta))/(cos(phi)cos(delta))
  ///
  /// [heightAtHorizon], [latitude] und [declination] sind in Winkelmass (Radian) anzugeben
  double? getHourAngle({
    required num heightAtHorizon,
    required num latitude,
    required num declination,
  }) {
    var dividend = sin(heightAtHorizon) - sin(latitude) * sin(declination);
    var divisor = cos(latitude) * cos(declination);
    var cosHourAngle = dividend / divisor;
    return cosHourAngle.abs() > 1 ? null : acos(cosHourAngle);
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

  // sin(h) = sin(d)sin(f)+cos(d)cos(f)cos(H)
  // h: Höhe, Ziel der Berechnung
  // f: geographische Breite, einzugeben
  double getHeight(
    num latitude,
    num hourAngle,
    num declination,
  ) {
    var sinDec = sin(declination);
    var sinLat = sin(latitude);
    var cosDec = cos(declination);
    var cosLat = cos(latitude);
    var cosHour = cos(hourAngle);
    var sinHeight = sinDec * sinLat + cosDec * cosLat * cosHour;
    var height = asin(sinHeight);
    return height;
  }

  var date = DateTime.utc(1988, 3, 20);
  var dtDate = getDtDate(date);
  var julianDate = getJulianDate(date);
  var capThetaZero = secondsToRad(getApSidTimeZero(julianDate));
  print('Θ0: ${radToDeg(capThetaZero)}');
  var julianDtDate = getJulianDate(dtDate);
  var sidTime = getApparentSidTime(julianDtDate);
  // print(secondsToTime(capThetaZero));

  // L
  var long = degMinSecToRad(1, 71, 5, 0);
  print('L: ${radToDeg(long)}');
  var lat = degMinSecToRad(1, 42, 20, 0);
  print('φ: ${radToDeg(lat)}');
  var a1 = timeToRad(2, 42, 43.25);
  print('α1: ${radToDeg(a1)}');
  var a2 = timeToRad(2, 46, 55.51);
  print('α2: ${radToDeg(a2)}');
  var a3 = timeToRad(2, 51, 7.69);
  print('α3: ${radToDeg(a3)}');
  var d1 = degMinSecToRad(1, 18, 2, 51.4);
  print('δ1: ${radToDeg(d1)}');
  var d2 = degMinSecToRad(1, 18, 26, 27.3);
  print('δ2: ${radToDeg(d2)}');
  var d3 = degMinSecToRad(1, 18, 49, 38.7);
  print('δ3: ${radToDeg(d3)}');
  var h0 = degMinSecToRad(-1, 0, 34, 0);
  print('h0: ${radToDeg(h0)}');
  var deltaT = 56;
  var capH0 = getHourAngle(
    heightAtHorizon: h0,
    latitude: lat,
    declination: d2,
  );
  if (capH0 == null) {
    print('circumPolar');
    exit(1);
  }
  print('H0: ${radToDeg(capH0)}');
  // m0
  var transit = (a2 + long - capThetaZero) / (2 * pi) % 1;
  print('m0: $transit');
  // m1
  var rising = (transit - capH0 / (2 * pi)) % 1;
  print('m1: $rising');
  // m2
  var setting = (transit + capH0 / (2 * pi)) % 1;
  print('m2: $setting');

  // --------------------------------------- transit
  // θ0
  var theta0 = modRad(capThetaZero + 2 * pi * transit);
  print('θ0: ${radToDeg(theta0)}');
  // n
  var n = transit + deltaT / 86400;
  print('n: $n');
  // interpolated α
  var a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  print('int. α: ${radToDeg(a)}');
  // // H
  var capH = theta0 - long - a;
  print('H: ${radToDeg(capH)}');
  // Δm
  var deltaM = -capH / (2 * pi);
  print('Δm: $deltaM');
  // corrected m
  transit = transit + deltaM;
  print('m0: $transit');

  // Durchgang
  theta0 = modRad(capThetaZero + 2 * pi * transit);
  n = transit + deltaT / 86400;
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  capH = theta0 - long - a;
  deltaM = -capH / (2 * pi);
  transit = transit + deltaM;
  print('m0: $transit');

  // Durchgang
  theta0 = modRad(capThetaZero + 2 * pi * transit);
  n = transit + deltaT / 86400;
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  capH = theta0 - long - a;
  deltaM = -capH / (2 * pi);
  transit = transit + deltaM;
  print('m0: $transit');

  // Durchgang
  theta0 = modRad(capThetaZero + 2 * pi * transit);
  n = transit + deltaT / 86400;
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  capH = theta0 - long - a;
  deltaM = -capH / (2 * pi);
  transit = transit + deltaM;
  print('m0: $transit');

  // Durchgang
  theta0 = modRad(capThetaZero + 2 * pi * transit);
  n = transit + deltaT / 86400;
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  capH = theta0 - long - a;
  deltaM = -capH / (2 * pi);
  transit = transit + deltaM;
  print('m0: $transit');

  // // --------------------------------------- rising
  // // θ0
  // theta0 = modRad(capThetaZero + 2 * pi * rising);
  // print('θ0: ${radToDeg(theta0)}');
  // // n
  // n = rising + deltaT / 86400;
  // print('n: $n');
  // // interpolated α
  // a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  // print('int. α: ${radToDeg(a)}');
  // // interpolated δ
  // var d = interpolation(firstTerm: d1, middleTerm: d2, thirdTerm: d3, part: n);
  // print('int. δ: ${radToDeg(d)}');
  // // H
  // capH = theta0 - long - a;
  // print('H: ${radToDeg(capH)}');
  // // h
  // var h = getHeight(lat, capH, d);
  // print('h: ${radToDeg(h)}');
  // // Δm
  // deltaM = (h - h0) / (cos(d) * cos(lat) * sin(capH));
  // print('Δm: ${radToDeg(deltaM)}');
  // // corrected m
  // rising = rising + deltaM;
  // print('m1: $rising');

  // // --------------------------------------- setting
  // // θ0
  // theta0 = modRad(capThetaZero + 2 * pi * setting);
  // print('θ0: ${radToDeg(theta0)}');
  // // n
  // n = setting + deltaT / 86400;
  // print('n: $n');
  // // interpolated α
  // a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  // print('int. α: ${radToDeg(a)}');
  // // interpolated δ
  // d = interpolation(firstTerm: d1, middleTerm: d2, thirdTerm: d3, part: n);
  // print('int. δ: ${radToDeg(d)}');
  // // H
  // capH = theta0 - long - a;
  // print('H: ${radToDeg(capH)}');
  // // h
  // h = getHeight(lat, capH, d);
  // print('h: ${radToDeg(h)}');
  // // Δm
  // deltaM = (h - h0) / (cos(d) * cos(lat) * sin(capH));
  // print('Δm: ${radToDeg(deltaM)}');
  // // corrected m
  // setting = setting + deltaM;
  // print('m1: $setting');
}
