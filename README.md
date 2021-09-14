# SunDial

## Beschreibung

Uhr mit tatsächlichen Tages-Nachtstunden mit Sonnenauf-/-untergang als 12-Uhr-
Zeitpunkten. Sofern möglich, auch mit dynamischem Icon (à la iPhoneUhr).  
Es soll auch die Möglichkeit geben, zu bestimmten Sonnenuhrzeiten einen Wecker
zu setzen.

## Planung

### Wie soll's aussehen?

* Screens:
  * Hauptbildschirm: die Sonnenuhr, evtl. mit Unterscheidung dunkler/heller
  Hintergrund bei Nacht/Tag;
  * Ortsauswahl: Eine Liste mit Locations; Standardeinstellung ist Jerusalem,
  Tempelberg (31.778074 N, 35.235287 E / 31°46'41.1"N 35°14'07.0"E);
  * Ortbearbeitung;
  * ¿Karte zur Ortsauswahl?
  * ¿Wecker?: Hier können Wecker à la Apple Clock eingestellt werden
  * Einstellungen: hell/dunkel/fix/Systemeinstellung, fixe/aktuelle Position

### Astronomisches

#### Mean Anomaly

M = 360°/n*t
Mr = 2PI/n*t

* M = Mean Anomaly in degrees
* Mr = Mean Anomaly in radians;
* t: day since perihelion,
* n = orbital period in sidereal days

#### Kepler's Equation

Mr = Er - e*sin(Er)

* Er = Eccentric Anomaly in Radians
* e = orbital eccentricity (Earth: 0.0167086)
* Hilfsformel: Ei = Mr + e*sin(Ei-1)

Starte mit der Annahme E0 = Mr, berechne E1 usw.

#### True Anomaly

tan(v/2) = [(1+e)/(1-e)]^(1/2) *tan(E/2)  
cos(v) = (cos(E)-e) / (1-e*cos(E))

* v = True Anomaly

tan(E/2) = [(1-e)/(1+e)]^(1/2) *tan(v/2)
