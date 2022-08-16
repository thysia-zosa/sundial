// import 'dart:math';

// void main() {
//   String twoDig(num number) {
//     String prefix = number < 10 ? '0' : '';
//     return '$prefix$number';
//   }

//   String secondsToTime(num daySeconds) {
//     var hours = twoDig(daySeconds ~/ 3600);
//     var minutes = twoDig(daySeconds ~/ 60 % 60);
//     var seconds = twoDig(daySeconds % 60);
//     return '$hours:$minutes:$seconds';
//   }

//   double degToRad(num degree) => pi * degree / 180;
//   double degMinSecToRad(
//     int sign,
//     int degree,
//     int minute,
//     num second,
//   ) {
//     return sign * degToRad(degree + minute / 60 + second / 3600);
//   }

//   double radToDeg(num radians) => 180 * radians / pi;

//   double secondsToRad(num seconds) => seconds * pi / 43200;

//   double timeToRad(
//     int hour,
//     int minute,
//     num second,
//   ) {
//     return secondsToRad(hour * 3600 + minute * 60 + second);
//   }

//   double modRad(num radians) {
//     return (radians + 2 * pi) % (2 * pi);
//   }

//   double getJulianDate(DateTime dateTime) {
//     var millisecondsOfDateTime = dateTime.toUtc().millisecondsSinceEpoch;
//     var julianDate = 2440587.5 + millisecondsOfDateTime / 86400000;
//     return julianDate;
//   }

//   // T: Julianische Säkula
//   double getJulianSaeculum(num julianDate) => (julianDate - 2451545) / 36525;

//   // M: Mittlere Anomalie
//   // M = 357.52911° + 35999.05029° T - 0.0001537° T^2
//   double getMeanAnomaly(num julianSaeculum) => modRad(6.240060141224984 +
//       628.301955151519532 * julianSaeculum -
//       0.00000268257106 * julianSaeculum * julianSaeculum);

//   // e: Exzentrizität (22 e + ∂e)
//   // e = 0.016708634 - 0.000042037T - 0.0000001267T^2
//   double getExcentricity(num julianSaeculum) =>
//       0.016708634 -
//       0.000042037 * julianSaeculum -
//       0.0000001267 * julianSaeculum * julianSaeculum;

//   // E: Exzentrische  Anomalie
//   // E = M - e * sin(E) (iterativ zu lösen)
//   double getExcentricAnomaly(
//     num meanAnomaly,
//     num excentricity,
//   ) {
//     double eA;
//     double eccentricAnomaly = meanAnomaly as double;
//     double diff = 1.0; // for while-loop
//     while (diff.abs() > 0.0000000000001) {
//       eA = eccentricAnomaly;
//       eccentricAnomaly = meanAnomaly + excentricity * sin(eA);
//       diff = eccentricAnomaly - eA;
//     }
//     return eccentricAnomaly;
//   }

//   // v: Wahre Anomalie
//   // v = 2arctan{ [(1-e)/(1+e)]^(1/2) * tan(E/2)}
//   double getTrueAnomaly(
//     num excentricAnomaly,
//     num excentricity,
//   ) {
//     var radicand = (1 + excentricity) / (1 - excentricity);
//     var tangentHalfExAnomaly = tan(excentricAnomaly / 2);
//     var tangentTrueAnomaly = sqrt(radicand) * tangentHalfExAnomaly;

//     // var cosinExAnomaly = cos(excentricAnomaly);
//     // var dividend = cosinExAnomaly - excentricity;
//     // var divisor = 1 - excentricity * cosinExAnomaly;
//     // var cosinTrueAnomaly = dividend / divisor;

//     // cos       tan
//     // -|+ -2|+2 -|+ -1|+1 -3|+3
//     // --- ----- --- ----- -----
//     // -|+ -2|+2 +|- +1|-1 -1|+1
//     // var quadrant =
//     //     (2 * cosinTrueAnomaly.sign - tangentTrueAnomaly).sign / -2 + 0.5;
//     // double trueAnomaly = acos(cosinTrueAnomaly) + pi * quadrant;
//     // return trueAnomaly;
//     return modRad(2 * atan(tangentTrueAnomaly));
//   }

//   // pg: Ekliptische Länge im Perigäum
//   // gemäss CelestialCalculations:
//   // pg = 281.2208444 + 1.719175T + 0.000452778T^2
//   // 4.908229660018657 + 0.000042037 T - 0.0000001267 T^2
//   // TODO: WHAT?
//   // gemäss Meeus:
//   // pg = 4.895063168412976 + 628.331966786139276 T + 0.000005291838292 T^2
//   double getEclipticLongPerigee(num julianSaeculum) =>
//       modRad(4.895063168412976 +
//           628.331966786139276 * julianSaeculum +
//           0.000005291838292 * julianSaeculum * julianSaeculum);

//   // l: ekkliptische Länge
//   // l = v + pg
//   double getEclipticLongitude(
//     num trueAnomaly,
//     num ecLongPerigee,
//   ) =>
//       modRad(trueAnomaly + ecLongPerigee);

//   // e: Ekkliptikschräge
//   // e = 23.439292 - (46.815T + 0.00059T^2 - 0.001813T^3) / 3600
//   double getEclipticObliquity(num julianSaeculum) =>
//       0.409092813918603 -
//       0.000226965524811 * julianSaeculum -
//       0.000000002908882 * julianSaeculum * julianSaeculum +
//       0.000000008775128 * julianSaeculum * julianSaeculum * julianSaeculum;

//   // sin(d) = sin(b)cos(e) + cos(b)sin(e)sin(l)
//   // d: Deklination, zu berechnen
//   double getDeclination(
//     num eclipticObliquity,
//     num eclipticLongitude, [
//     num eclipticLatitude = 0,
//   ]) {
//     var firstSummand = sin(eclipticLatitude) * cos(eclipticObliquity);
//     var secondSummand =
//         cos(eclipticLatitude) * sin(eclipticObliquity) * sin(eclipticLongitude);
//     var sinDeclination = firstSummand + secondSummand;
//     var declination = asin(sinDeclination);
//     return declination;
//   }

//   // a: Rektaszension
//   // tan(a) = [sin(l)cos(e) - tan(b)sin(e)] / cos(l)
//   // TODO: ArcusTangens auf vier Quadranten korrigieren
//   double getRectascension(
//     num eclipticObliquity,
//     num eclipticLongitude, [
//     num eclipticLatitude = 0,
//   ]) {
//     // var tanRectascension = cos(eclipticObliquity) * tan(eclipticLongitude);
//     var minuend = sin(eclipticLongitude) * cos(eclipticObliquity);
//     var subtrahend = tan(eclipticLatitude) * sin(eclipticObliquity);
//     var dividend = minuend - subtrahend;
//     var divisor = cos(eclipticLongitude);
//     var rectascension = atan2(dividend, divisor);
//     return modRad(rectascension);
//   }

//   // returns Greenwich Sidereal Mean Time in Seconds
//   // 236.555367908720055 / d
//   // 6.97891470732778e-11 / d
//   // 1.2723922513927220627e-13 / d
//   double getGsmt(num julianDate) {
//     var julianSaeculum = getJulianSaeculum(julianDate);
//     var gsmt = 24110.54841 +
//         8640148.812866 * julianSaeculum +
//         0.093104 * julianSaeculum * julianSaeculum -
//         0.0000062 * julianSaeculum * julianSaeculum * julianSaeculum;
//     var h = (julianDate + 0.5) % 1;
//     return (gsmt + h * 86400) % 86400;
//   }

//   double getLsmt(num gsmt, num longitude) =>
//       (gsmt + 86400 + longitude * 240) % 86400;

//   // H: Stundenwinkel, zu berechnen, in Radian
//   // H = (LST-a)
//   // LST: Lokale Siderische Zeit
//   double getHourAngle(
//     double localSidTime,
//     double rectascension,
//   ) =>
//       localSidTime * pi / 43200 - rectascension;

//   // sin(h) = sin(d)sin(f)+cos(d)cos(f)cos(H)
//   // h: Höhe, Ziel der Berechnung
//   // f: geographische Breite, einzugeben
//   double getHeight(
//     num latitude,
//     num hourAngle,
//     num declination,
//   ) {
//     var sinDec = sin(declination);
//     var sinLat = sin(latitude);
//     var cosDec = cos(declination);
//     var cosLat = cos(latitude);
//     var cosHour = cos(hourAngle);
//     var sinHeight = sinDec * sinLat + cosDec * cosLat * cosHour;
//     var height = asin(sinHeight);
//     return height;
//   }

//   // tan(A) = sin(H) / cos(H)sin(f) - tan(∂)cos(f)
//   double getAzimuth(num declination, num latitude, num hourAngle) {
//     var dividend = sin(hourAngle);
//     var minuend = cos(hourAngle) * sin(latitude);
//     var subtrahend = tan(declination) * cos(latitude);
//     var divisor = minuend - subtrahend;
//     var azimuth = atan2(dividend, divisor);
//     return (azimuth + pi) % (2 * pi);
//   }

//   double getLongAscNode(num julianSaec) {
//     return modRad(2.18235969669371 - 33.757041381353046 * julianSaec);
//   }

//   double getAppLong(num longAscNode, num trueLong) {
//     var appLong =
//         trueLong - 0.000099309234438 - 0.000083426738245 * sin(longAscNode);
//     return modRad(appLong);
//   }

//   double getAppEclObl(num eclOblZero, num longAscNode) {
//     return eclOblZero + 0.000044680428851 * cos(longAscNode);
//   }

//   // var dec = degMinSecToRad(-1, 0, 30, 30);
//   // var lat = degMinSecToRad(1, 25, 0, 0);
//   // var hour = timeToRad(16, 29, 45);
//   // var a = getHeight(lat, hour, dec);
//   // print(radToDeg(a));
//   // var b = getAzimuth(dec, lat, hour);
//   // print(radToDeg(b));

//   // const jdAtEpoch = 2440587.5;
//   // var jdDate =
//   //     DateTime.utc(2010, 2, 7, 23, 30).millisecondsSinceEpoch / 86400000;

//   // var jd = jdDate + jdAtEpoch;
//   // var result = getGsmt(jd);
//   // print('${result ~/ 3600}:${result ~/ 60 % 60}:${result % 60}');
//   // result = getLsmt(result, -40);
//   // print('${result ~/ 3600}:${result ~/ 60 % 60}:${result % 60}');

//   /// Gesucht ist der Stundenwinkel H.
//   ///
//   /// L: geographische Länge des Beobachters in Grad (positiv = West!)
//   /// φ: geographische Breite des Beobachters in Grad (positiv = Nord)
//   /// ΔT: TD - UT in Sekunden
//   /// h0: Höhe bei Auf-/Untergang (-0° 50‘“)
//   /// D: Datum
//   /// Θ0: Scheinbare siderische Zeit bei 0h UT für den Greenwich-Meridian, in Grad
//   /// α1, α2, α3 und δ1, δ2, δ3 für Rektaszension und Deklination bei 0h DT an
//   /// * D-1, D und D+1, in Grad (auch die Rektaszension!)
//   ///
//   /// Zuerst werden Näherungswerte ermittelt:
//   /// cos(H0) = [sin(h0) - sin(φ)sin(δ2)] / cos(φ)cos(δ2)
//   /// vor der Berechnung des Arccos muss darauf geachtet werden, dass, der Wert
//   /// -1 <= x <= 1 ist. Im Falle der Mitternachtssonne ist der Wert x > 1, es
//   /// gibt weder Auf- noch Untergang
//   ///
//   /// Dann haben wir:
//   /// Transit (Mittag) m0 = (α2 + L + Θ0) / 360
//   /// Aufgang m1 = m0 - H0 / 360
//   /// Untergang m2 = m0 + H0 / 360
//   ///
//   /// Diese Werte sollten 0 <= x <= 1 sein. Gegebenenfalls muss 1 addiert oder
//   /// subtrahiert werden.
//   /// Für die einzelnen m's ist folgendes durchzuführen
//   ///
//   /// θ0 = Θ0 + 360.985647 * m

//   // double computeHeight(
//   //   DateTime dateTime,
//   //   num latitudeDegrees,
//   //   num longitudeDegrees,
//   // ) {
//   //   var julianDate = getJulianDate(dateTime);
//   //   print('julianDate: $julianDate');
//   //   var julianSaeculum = getJulianSaeculum(julianDate);
//   //   print('julianSaeculum: $julianSaeculum');
//   //   var latitude = degToRad(latitudeDegrees);
//   //   print('latitude: $latitude');
//   //   // var longitude = degToRad(longitudeDegrees);
//   //   var ecLongPerigee = getEclipticLongPerigee(julianSaeculum);
//   //   print('ecLongPerigee: $ecLongPerigee');
//   //   var excentricity = getExcentricity(julianSaeculum);
//   //   print('excentricity: $excentricity');
//   //   var meanAnomaly = getMeanAnomaly(julianSaeculum);
//   //   print('meanAnomaly: $meanAnomaly');
//   //   var excentricAnomaly = getExcentricAnomaly(meanAnomaly, excentricity);
//   //   print('excentricAnomaly: $excentricAnomaly');
//   //   var trueAnomaly = getTrueAnomaly(excentricAnomaly, excentricity);
//   //   print('trueAnomaly: $trueAnomaly');
//   //   var eclipticLongitude = getEclipticLongitude(trueAnomaly, ecLongPerigee);
//   //   print('eclipticLongitude: $eclipticLongitude');
//   //   var eclipticObliquity = getEclipticObliquity(julianSaeculum);
//   //   print('eclipticObliquity: $eclipticObliquity');
//   //   var gsmt = getGsmt(julianDate);
//   //   print('gsmt: $gsmt');
//   //   var localSidTime = getLsmt(gsmt, longitudeDegrees);
//   //   print('localSidTime: $localSidTime');
//   //   var rectascension = getRectascension(eclipticObliquity, eclipticLongitude);
//   //   print('rectascension: $rectascension');
//   //   var hourAngle = getHourAngle(localSidTime, rectascension);
//   //   print('hourAngle: $hourAngle');
//   //   var declination = getDeclination(eclipticObliquity, eclipticLongitude);
//   //   print('declination: $declination');
//   //   var height = getHeight(latitude, hourAngle, declination);
//   //   print('height: $height');
//   //   return height;
//   // }

//   // var ex291date = DateTime.utc(2015, 2, 5, 17);
//   // var exercise291 = computeHeight(ex291date, 38, -78);
//   // print(radToDeg(exercise291));

//   var date = DateTime.utc(2021, 9, 23, 12);
//   var julianDate = getJulianDate(date);
//   print('julianDate: $julianDate');
//   var t = getJulianSaeculum(julianDate);
//   print('t: $t');
//   var l0 = getEclipticLongPerigee(t);
//   print('l0: ${radToDeg(l0)}');
//   var m = getMeanAnomaly(t);
//   print('M: ${radToDeg(m)}');
//   var excentricity = getExcentricity(t);
//   print('e: $excentricity');
//   var excLong = getExcentricAnomaly(m, excentricity);
//   print('exLong: ${radToDeg(excLong)}');
//   var v = getTrueAnomaly(excLong, excentricity);
//   print('v: ${radToDeg(v)}');
//   print('C: ${radToDeg(v - m)}');
//   var trueLong = l0 + v - m;
//   print('trueLong: ${radToDeg(trueLong)}');
//   var longAscNode = getLongAscNode(t);
//   print('Ω: ${(radToDeg(longAscNode))}');
//   var appLong = getAppLong(longAscNode, trueLong);
//   print('λ: ${(radToDeg(appLong))}');
//   var eclOblZero = getEclipticObliquity(t);
//   print('ε0: ${(radToDeg(eclOblZero))}');
//   var eclObl = getAppEclObl(eclOblZero, longAscNode);
//   print('ε: ${(radToDeg(eclObl))}');
//   var rectascension = getRectascension(eclObl, appLong);
//   print('α: ${(secondsToTime(radToDeg(rectascension) * 240))}');
//   var declination = getDeclination(eclObl, appLong);
//   print('δ: ${(radToDeg(declination))}');
//   var test = getTrueAnomaly(degToRad(45), 0.5);
//   print(radToDeg(test));

//   var gsmt = getGsmt(julianDate);
//   print(secondsToTime(gsmt));
//   print(secondsToTime(gsmt - radToDeg(rectascension) * 240));

//   /// Was lernen wir daraus?
//   /// 1. Berechne die Sternenzeit um 12 Uhr Mittags lokale mittlere Sonnenzeit.
//   /// 2. Berechne die Rektaszension der Sonne zu diesem Zeitpunkt.
//   /// 3. Daraus lässt sich die Zeitgleichung und der wahre Mittag errechnen.
//   /// 4. Verfeinere den wahren Mittag (Sonnentransit) à la Meeus.
//   /// 5. Berechne dann den vorläufigen Stundenwinkel zu Sonnenauf-/-untergang.
//   /// 6. Verfeinere wiederum die Daten à la Meeus.
//   /// 7. Stelle fest, ob die Zeit vor Sonnenauf-/ nach Sonnenuntergang ist.
//   /// 8. In diesem Fall errechne den letzen Unter- bzw. nächsten Aufgang.
//   /// 9. Dann berechne die aktuelle Tages-/Nachtzeit.
// }
