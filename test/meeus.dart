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

  // M: Mittlere Anomalie
  // M = 357.52911° + 35999.05029° T - 0.0001537° T^2
  double getMeanAnomaly(num julianSaeculum) => modRad(6.240060141224984 +
      628.301955151519532 * julianSaeculum -
      0.00000268257106 * julianSaeculum * julianSaeculum);

  // e: Exzentrizität (22 e + ∂e)
  // e = 0.016708634 - 0.000042037T - 0.0000001267T^2
  double getExcentricity(num julianSaeculum) =>
      0.016708634 -
      0.000042037 * julianSaeculum -
      0.0000001267 * julianSaeculum * julianSaeculum;

  // E: Exzentrische  Anomalie
  // E = M - e * sin(E) (iterativ zu lösen)
  double getExcentricAnomaly(
    num meanAnomaly,
    num excentricity,
  ) {
    double eA;
    double eccentricAnomaly = meanAnomaly as double;
    double diff = 1.0; // for while-loop
    while (diff.abs() > 0.0000000000001) {
      eA = eccentricAnomaly;
      eccentricAnomaly = meanAnomaly + excentricity * sin(eA);
      diff = eccentricAnomaly - eA;
    }
    return eccentricAnomaly;
  }

  // v: Wahre Anomalie
  // v = 2arctan{ [(1-e)/(1+e)]^(1/2) * tan(E/2)}
  double getTrueAnomaly(
    num excentricAnomaly,
    num excentricity,
  ) {
    var radicand = (1 + excentricity) / (1 - excentricity);
    var tangentHalfExAnomaly = tan(excentricAnomaly / 2);
    var tangentTrueAnomaly = sqrt(radicand) * tangentHalfExAnomaly;

    // var cosinExAnomaly = cos(excentricAnomaly);
    // var dividend = cosinExAnomaly - excentricity;
    // var divisor = 1 - excentricity * cosinExAnomaly;
    // var cosinTrueAnomaly = dividend / divisor;

    // cos       tan
    // -|+ -2|+2 -|+ -1|+1 -3|+3
    // --- ----- --- ----- -----
    // -|+ -2|+2 +|- +1|-1 -1|+1
    // var quadrant =
    //     (2 * cosinTrueAnomaly.sign - tangentTrueAnomaly).sign / -2 + 0.5;
    // double trueAnomaly = acos(cosinTrueAnomaly) + pi * quadrant;
    // return trueAnomaly;
    return modRad(2 * atan(tangentTrueAnomaly));
  }

  // L: Ekliptische Länge
  // gemäss Meeus:
  // L = 4.895063168412976 + 628.331966786139276 T + 0.000005291838292 T^2
  double getEclipticLong(num julianSaeculum) => modRad(4.895063168412976 +
      628.331966786139276 * julianSaeculum +
      0.000005291838292 * julianSaeculum * julianSaeculum);

  // e: Ekkliptikschräge
  // e = 23.439292 - (46.815T + 0.00059T^2 - 0.001813T^3) / 3600
  double getEclipticObliquity(num julianSaeculum) =>
      0.409092813918603 -
      0.000226965524811 * julianSaeculum -
      0.000000002908882 * julianSaeculum * julianSaeculum +
      0.000000008775128 * julianSaeculum * julianSaeculum * julianSaeculum;

  // sin(d) = sin(b)cos(e) + cos(b)sin(e)sin(l)
  // d: Deklination, zu berechnen
  double getDeclination(
    num eclipticObliquity,
    num eclipticLongitude, [
    num eclipticLatitude = 0,
  ]) {
    var firstSummand = sin(eclipticLatitude) * cos(eclipticObliquity);
    var secondSummand =
        cos(eclipticLatitude) * sin(eclipticObliquity) * sin(eclipticLongitude);
    var sinDeclination = firstSummand + secondSummand;
    var declination = asin(sinDeclination);
    return declination;
  }

  // a: Rektaszension
  // tan(a) = [sin(l)cos(e) - tan(b)sin(e)] / cos(l)
  double getRectascension(
    num eclipticObliquity,
    num eclipticLongitude, [
    num eclipticLatitude = 0,
  ]) {
    var minuend = sin(eclipticLongitude) * cos(eclipticObliquity);
    var subtrahend = tan(eclipticLatitude) * sin(eclipticObliquity);
    var dividend = minuend - subtrahend;
    var divisor = cos(eclipticLongitude);
    var rectascension = atan2(dividend, divisor);
    return modRad(rectascension);
  }

  double getLongAscNode(num julianSaec) {
    return modRad(2.18235969669371 - 33.757041381353046 * julianSaec);
  }

  double getAppLong(num longAscNode, num trueLong) {
    var appLong =
        trueLong - 0.000099309234438 - 0.000083426738245 * sin(longAscNode);
    return modRad(appLong);
  }

  double getAppEclObl(num eclOblZero, num longAscNode) {
    return eclOblZero + 0.000044680428851 * cos(longAscNode);
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

  /// sin(h) = sin(d)sin(f)+cos(d)cos(f)cos(H)
  /// h: Höhe, Ziel der Berechnung
  /// f: geographische Breite, einzugeben
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

  // double getNutLong({
  //   required num longAscNode,
  //   required num meanLongSun,
  //   required num julianSaec,
  // }) {
  //   var meanLongMoon = modRad(3.810341736430201 + 481267.8813 * julianSaec);
  //   var nutLong = (17.2 * sin(longAscNode) -
  //       1.32 * sin(2 * meanLongSun) -
  //       0.23 * sin(2 * meanLongMoon) +
  //       0.21 * sin(2 * longAscNode));
  //   return modRad(nutLong / 1296000);
  // }

  /// Equation of Time
  double getEqOfTime({
    required num rectascension,
    required num meanLongSun,
  }) {
    // var meanLongSun = 4.89506311081711 +
    //     6283.319667475674992 * julianMill +
    //     0.000529188716127 * julianMill * julianMill +
    //     julianMill * julianMill * julianMill * pi / 8987580 -
    //     julianMill * julianMill * julianMill * julianMill * pi/ 2754000 -
    //     julianMill *
    //         julianMill *
    //         julianMill *
    //         julianMill *
    //         julianMill * pi /
    //         360000000;
    var eqOfTime = meanLongSun - 0.000099803162617 - rectascension;
    eqOfTime = eqOfTime.sign * modRad(eqOfTime.abs());
    if (eqOfTime > pi) {
      eqOfTime -= 2 * pi;
    }
    return eqOfTime;
  }

  // var datum = DateTime.utc(1992, 10, 13);
  // var julDate = getJulianDate(datum);
  // var julSae = getJulianSaec(julDate);
  // var eq = getEqOfTime(
  //     rectascension: degToRad(198.378178),
  //     meanLongSun: getEclipticLong(julSae));
  // print('eqTime: ${secondsToTime(radToDeg(eq) * 240)}');

  var date = DateTime.utc(2021, 9, 26);
  var dtDate = getDtDate(date);
  var julianDate = getJulianDate(date);
  var capThetaZero = secondsToRad(getApSidTimeZero(julianDate));
  print('Θ0: ${radToDeg(capThetaZero)}');
  var julianDtDate = getJulianDate(dtDate);
  var sidTime = getApparentSidTime(julianDtDate);
  // print(secondsToTime(capThetaZero));
  List<double> getCoordinates(num julianDate) {
    var t = getJulianSaec(julianDate);
    var l0 = getEclipticLong(t);
    var m = getMeanAnomaly(t);
    var excentricity = getExcentricity(t);
    var excLong = getExcentricAnomaly(m, excentricity);
    var v = getTrueAnomaly(excLong, excentricity);
    var trueLong = l0 + v - m;
    var longAscNode = getLongAscNode(t);
    var appLong = getAppLong(longAscNode, trueLong);
    var eclOblZero = getEclipticObliquity(t);
    var eclObl = getAppEclObl(eclOblZero, longAscNode);
    var rectascension = getRectascension(eclObl, appLong);
    var declination = getDeclination(eclObl, appLong);
    // var nutLong = getNutLong(
    //   longAscNode: longAscNode,
    //   meanLongSun: l0,
    //   julianSaec: t,
    // );
    return [rectascension, declination, l0];
  }

  var ad1 = getCoordinates(julianDate - 1);
  var ad2 = getCoordinates(julianDate);
  var ad3 = getCoordinates(julianDate + 1);

  // L
  var long = degMinSecToRad(1, 8, 13, 21.02592);
  print('L: ${radToDeg(long)}');
  var lat = degMinSecToRad(1, 47, 28, 32.40912);
  print('φ: ${radToDeg(lat)}');
  var a1 = ad1[0];
  print('α1: ${radToDeg(a1)}');
  var a2 = ad2[0];
  print('α2: ${radToDeg(a2)}');
  var a3 = ad3[0];
  print('α3: ${radToDeg(a3)}');
  var d1 = ad1[1];
  print('δ1: ${radToDeg(d1)}');
  var d2 = ad2[1];
  print('δ2: ${radToDeg(d2)}');
  var d3 = ad3[1];
  print('δ3: ${radToDeg(d3)}');
  var h0 = degMinSecToRad(-1, 0, 50, 0);
  print('h0: ${radToDeg(h0)}');
  var deltaT = getDeltaT(date);
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
  var transit = (a2 - long - capThetaZero) / (2 * pi) % 1;
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
  var capH = theta0 + long - a;
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
  capH = theta0 + long - a;
  deltaM = -capH / (2 * pi);
  transit = transit + deltaM;
  print('m0: $transit');

  // Durchgang
  theta0 = modRad(capThetaZero + 2 * pi * transit);
  n = transit + deltaT / 86400;
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  capH = theta0 + long - a;
  deltaM = -capH / (2 * pi);
  transit = transit + deltaM;
  print('m0: $transit');

  // Durchgang
  theta0 = modRad(capThetaZero + 2 * pi * transit);
  n = transit + deltaT / 86400;
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  capH = theta0 + long - a;
  deltaM = -capH / (2 * pi);
  transit = transit + deltaM;
  print('m0: $transit');

  // Durchgang
  theta0 = modRad(capThetaZero + 2 * pi * transit);
  n = transit + deltaT / 86400;
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  capH = theta0 + long - a;
  deltaM = -capH / (2 * pi);
  transit = transit + deltaM;
  print('m0: $transit');

  // --------------------------------------- rising
  // θ0
  theta0 = modRad(capThetaZero + 2 * pi * rising);
  print('θ0: ${radToDeg(theta0)}');
  // n
  n = rising + deltaT / 86400;
  print('n: $n');
  // interpolated α
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  print('int. α: ${radToDeg(a)}');
  // interpolated δ
  var d = interpolation(firstTerm: d1, middleTerm: d2, thirdTerm: d3, part: n);
  print('int. δ: ${radToDeg(d)}');
  // H
  capH = theta0 + long - a;
  print('H: ${radToDeg(capH)}');
  // h
  var h = getHeight(lat, capH, d);
  print('h: ${radToDeg(h)}');
  // Δm
  deltaM = (h - h0) / (2 * pi * cos(d) * cos(lat) * sin(capH));
  print('Δm: ${radToDeg(deltaM)}');
  // corrected m
  rising = rising + deltaM;
  print('m2: $rising');

  // Durchgang
  theta0 = modRad(capThetaZero + 2 * pi * rising);
  n = rising + deltaT / 86400;
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  d = interpolation(firstTerm: d1, middleTerm: d2, thirdTerm: d3, part: n);
  capH = theta0 + long - a;
  h = getHeight(lat, capH, d);
  deltaM = (h - h0) / (2 * pi * cos(d) * cos(lat) * sin(capH));
  rising = rising + deltaM;
  print('m2: $rising');

  // Durchgang
  theta0 = modRad(capThetaZero + 2 * pi * rising);
  n = rising + deltaT / 86400;
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  d = interpolation(firstTerm: d1, middleTerm: d2, thirdTerm: d3, part: n);
  capH = theta0 + long - a;
  h = getHeight(lat, capH, d);
  deltaM = (h - h0) / (2 * pi * cos(d) * cos(lat) * sin(capH));
  rising = rising + deltaM;
  print('m2: $rising');

  // Durchgang
  theta0 = modRad(capThetaZero + 2 * pi * rising);
  n = rising + deltaT / 86400;
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  d = interpolation(firstTerm: d1, middleTerm: d2, thirdTerm: d3, part: n);
  capH = theta0 + long - a;
  h = getHeight(lat, capH, d);
  deltaM = (h - h0) / (2 * pi * cos(d) * cos(lat) * sin(capH));
  rising = rising + deltaM;
  print('m2: $rising');

  // Durchgang
  theta0 = modRad(capThetaZero + 2 * pi * rising);
  n = rising + deltaT / 86400;
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  d = interpolation(firstTerm: d1, middleTerm: d2, thirdTerm: d3, part: n);
  capH = theta0 + long - a;
  h = getHeight(lat, capH, d);
  deltaM = (h - h0) / (2 * pi * cos(d) * cos(lat) * sin(capH));
  rising = rising + deltaM;
  print('m2: $rising');

  // --------------------------------------- setting
  // θ0
  theta0 = modRad(capThetaZero + 2 * pi * setting);
  print('θ0: ${radToDeg(theta0)}');
  // n
  n = setting + deltaT / 86400;
  print('n: $n');
  // interpolated α
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  print('int. α: ${radToDeg(a)}');
  // interpolated δ
  d = interpolation(firstTerm: d1, middleTerm: d2, thirdTerm: d3, part: n);
  print('int. δ: ${radToDeg(d)}');
  // H
  capH = theta0 + long - a;
  print('H: ${radToDeg(capH)}');
  // h
  h = getHeight(lat, capH, d);
  print('h: ${radToDeg(h)}');
  // Δm
  deltaM = (h - h0) / (2 * pi * cos(d) * cos(lat) * sin(capH));
  print('Δm: ${radToDeg(deltaM)}');
  // corrected m
  setting = setting + deltaM;
  print('m3: $setting');

  // Durchgang
  theta0 = modRad(capThetaZero + 2 * pi * setting);
  n = setting + deltaT / 86400;
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  d = interpolation(firstTerm: d1, middleTerm: d2, thirdTerm: d3, part: n);
  capH = theta0 + long - a;
  h = getHeight(lat, capH, d);
  deltaM = (h - h0) / (2 * pi * cos(d) * cos(lat) * sin(capH));
  setting = setting + deltaM;
  print('m3: $setting');

  // Durchgang
  theta0 = modRad(capThetaZero + 2 * pi * setting);
  n = setting + deltaT / 86400;
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  d = interpolation(firstTerm: d1, middleTerm: d2, thirdTerm: d3, part: n);
  capH = theta0 + long - a;
  h = getHeight(lat, capH, d);
  deltaM = (h - h0) / (2 * pi * cos(d) * cos(lat) * sin(capH));
  setting = setting + deltaM;
  print('m3: $setting');

  // Durchgang
  theta0 = modRad(capThetaZero + 2 * pi * setting);
  n = setting + deltaT / 86400;
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  d = interpolation(firstTerm: d1, middleTerm: d2, thirdTerm: d3, part: n);
  capH = theta0 + long - a;
  h = getHeight(lat, capH, d);
  deltaM = (h - h0) / (2 * pi * cos(d) * cos(lat) * sin(capH));
  setting = setting + deltaM;
  print('m3: $setting');

  // Durchgang
  theta0 = modRad(capThetaZero + 2 * pi * setting);
  n = setting + deltaT / 86400;
  a = interpolation(firstTerm: a1, middleTerm: a2, thirdTerm: a3, part: n);
  d = interpolation(firstTerm: d1, middleTerm: d2, thirdTerm: d3, part: n);
  capH = theta0 + long - a;
  h = getHeight(lat, capH, d);
  deltaM = (h - h0) / (2 * pi * cos(d) * cos(lat) * sin(capH));
  setting = setting + deltaM;
  print('m3: $setting');

  var eq = getEqOfTime(
    rectascension: ad2[0],
    meanLongSun: ad2[2],
  );

  print('rising: ${secondsToTime(rising * 86400)}');
  print('transit: ${secondsToTime(transit * 86400)}');
  print('setting: ${secondsToTime(setting * 86400)}');
  print('localTimeDelta: ${secondsToTime(radToDeg(long) * 240)}');
  print('eqTime: ${secondsToTime(radToDeg(eq) * 240)}');
  var sum = radToDeg(pi - long - eq) * 240;
  print(secondsToTime(sum));
}
