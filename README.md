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

$M = \frac{360°}{n}t$

$M_{r} = \frac{2\pi}{n}t$

* $M$ = Mean Anomaly in degrees
* $M_r$ = Mean Anomaly in radians;
* $t$: day since perihelion,
* $n$ = orbital period in sidereal days

#### Kepler's Equation

$M_r = E_r - e*sin(E_r)$

* $E_r$ = Eccentric Anomaly in Radians
* $e$ = orbital eccentricity (Earth: 0.0167086)
* Hilfsformel: $E_i = M_r + e\sin{E_{i-1}}$

Starte mit der Annahme $E_0 = M_r$, berechne $E_1$ usw.

#### True Anomaly

$\tan{\frac{v}{2}} = \sqrt{\frac{1+e}{1-e}}*\tan{\frac{E}{2}}$

$\cos{v} = \frac{\cos{E}-e}{1-e*\cos{E}}$

* $v$ = True Anomaly

$\tan{\frac{E}{2}} = \sqrt{\frac{1-e}{1+e}}*\tan{\frac{v}{2}}$

### Opgang, Doorvoer en Ondergang

(Vertaling van Meeus, Astronomical Algorithms, Hoofdstuk 15)

De lokale uurhoek die overeenkomt met de tijd van opkomst en ondergang van een hemellichaam wordt verkregen door $h = 0$ in formule

$\sin{h} = \sin{\varphi}\sin{\delta} + \cos{\varphi}\cos{\delta}\cos{H}$

te zetten. Dit geeft

$\cos{H_0} = -\tan{\varphi}\tan{\delta}$

Het aldus verkregen moment verwijst echter naar de geometrische opkomst of ondergang van het centrum van het hemellichaam. Vanwege de atmosferische breking bevindt het lichaam zich feitelijk onder de horizon op het moment van zijn schijnbare opkomst of ondergang. De waarde van 0°34’ wordt over het algemeen aangenomen voor het effect van breking aan de horizon. Voor de zon verwijzen de berekende tijden over het algemeen naar de schijnbare opkomst of ondergang van het bovendste lidmaat van de schijf; daarom moet 0°16’ worden toegevoegd voor de halve diameter.

In feite verandert de hoeveelheid breking met de luchttemperatuur, -druk en de hoogte van de waarnemer (zie hoofdstuk 16). Een temperatuurverandering van winter naar zomer kan de tijden van zonsop- en -ondergang met ongeveer 20 seconden verschuiven op de midden-noordelijke en midden-zuidelijke breedtegraden. Evenzo leidt het observeren van zonsop- of -ondergang over een reeks barometrische drukken tot en variatie van een dozijn seconden in de tijd. In dit hoofdstuk zullen we echter een gemiddelde waarde gebruiken voor de atmosferische breking aan de horizon, namelijk de hierboven genoemde waarde van 0°34’.

We zullen de volgende symbolen gebruiken:

$L$ = geografische lengtegraad van de waarnemer in graden, *positief gemeten ten oosten van Greenwich*, negatief ten westen (zie hoofdstuk 13);

$\varphi$ = geografische breedte van de waarnemer, positief op het noordelijk halfrond, negatief op het zuidelijk halfrond;

${\Delta}T$ = het verschil TD - UT tussen dynamische tijd en universele tijd, in *tijdseconden*;

$h_0$ = de "standaard" hoogte, d.w.z. de geometrische hoogte van het midden van het lichaam op het moment van schijnbare opkomst of ondergang, namelijk

$h_0 = -0°34’ = -0.5667°$ voor sterren en planeten;

$h_0 = -0°50’ = -0.8333°$ voor de Zon.

Voor de Maan is het probleem ingewikkelder omdat $h_0$ niet constant is. Rekening houdend met de variaties van halve diameter en parallax, hebben we $h_0 = 0.7275\pi - 0°34’$, waarbij $\pi$ de horizontale parallax van de Maan is. Als er geen grote nauwkeurigheid vereist is, kan voor de Maan de gemiddelde waarde $h_0 = +0.125°$ worden gebruikt.

Stel dat we de tijden (in *Universele Tijd*) van opgang, doorvoer (wanneer het lichaam de plaatselijke meridiaan kruist op het bovenste hoogtepunt), en ondergang van een hemellichaam op een bepaalde plaats op een bepaalde datum *D* willen berekenen. We nemen de volgende waarden uit een almanak, of we berekenen ze zelf met een computerprogramma:

* de schijnbare sterrentijd $\Theta_0$ at $0^h$ *Universele Tijd* op dag $D$ voor de meridiaan van Greenwich, omgerekend in graden;
* de schijnbare rechte klimmingen en declinaties van het lichaam

    $\alpha_1$ en $\delta_1$ op dag $D$ - 1 om $0^h$ Dynamische Tijd.  
    $\alpha_2$ en $\delta_2$ op dag $D$ om $0^h$ Dynamische Tijd.  
    $\alpha_3$ en $\delta_3$ op dag $D$ + 1 om $0^h$ Dynamische Tijd.

De rechte klimmingen moeten ook in *graden* worden uitgedrukt.

We berekenen eerst de *geschatte* tijden als volgt.

$\cos{H_0} = \frac{\sin{h_0}-\sin{\varphi}\sin{\delta_2}}{\cos{\varphi}\cos{\delta_2}}$

Let op! Test eerst of het tweede lid tussen -1 en +1 ligt voordat $H_0$ wordt berekend. Zie noot 2 aan het einde van dit hoofdstuk.
Druk $H_0$ uit in graden. $H_0$ moet tussen 0° en +180° worden genomen. Dann hebben we:

* voor de doorvoer: $m_0 = \frac{\alpha_2-L-\Theta_0}{360}$
* voor de opgang: $m_1 = m_0 - \frac{H_0}{360}$
* voor de ondergang: $m_1 = m_0 + \frac{H_0}{360}$

Deze drie waarden $m$ zijn tijden, op dag $D$, uitgedrukt als fracties van een dag. Daarom moeten ze tussen 0 en +1 liggen. Als een of meer van deze waarden buiten dit bereik vallen, moet u 1 optellen of aftrekken. Zoe moet +0.3744 ongewijzigd blijven, maar -0.1709 moet worden gewijzigd in +0.8291 en +1.1853 moet worden gewijzigd in +0.1853.

Voer nu voor *elk* van de drie $m$-waarden *afzonderlijk* de volgende berekening uit.

Zoek de sterrentijd in Greenwich, in *graden*, vanaf

$\theta_0 = \Theta_0 + 360.985647m$

waarbij $m$ ofwel $m_0$, $m_1$ of $m_2$ is.

Interpoleer voor $n = m + \frac{{\Delta}T}{86400}$ $\alpha$ uit $\alpha_1$, $\alpha_2$, $\alpha_3$ en $\delta$ uit $\delta_1$, $\delta_2$, $\delta_3$ met behulp van de interpolatieformule (3.3). Voor de berekening van de doorvoertijd is $\delta$ niet nodig.

Bepaal de lokale uurhoek van het lichaam uit $H = \theta_0 - L - \alpha$, en vervolgens de lichaamshoogte $h$ met formule (13.6). Deze hoogte is niet nodig voor de berekening van de doorvoertijd.

Dan wordt de correctie naar $m$ als volgt gevonden:

* in het geval van een doorvoer:  
    ${\Delta}m = -\frac{H}{360}$  
    waarbij $H$ wordt uitgedrukt in graden en tussen -180 en +180 graden *moet* liggen. (In de meeste gevallen zal $H$ een kleine hoek zijn en tussen -1° en +1° liggen);
* in het geval van een op- of ondergang,  
    ${\Delta}m = \frac{h-h_0}{360\cos{\delta}\cos{\varphi}\sin{H}}$  
    waarbij $h$ en $h_0$ worden uitgedrukt in graden.

De correcties ${\Delta}m$ zijn kleine hoeveelheden, in de meeste gevallen tussen -0.01 en +0.01. De gecorrigeerde waarde van $m$ is dan $m + {\Delta}m$. Indien nodig moet een nieuwe berekening worden uitgevoerd met de nieuwe waarde van $m$.

Aan het einde van de berekening moet elke waarde van $m$ worden omgezet in uren door vermenigvuldiging met 24.

#### Voorbeeld 15.a

Venus op 20 maart 1988 in Boston,

* lengte = +71°05’ = +71.0833°,
* breedte = +42°20’ = +42.3333°.

Van een nauwkeurige efemeride nemen we de volgende waarden:

1988 maart 20, $0^h$ UT: $\Theta_0$ = $11^h50^m58.10^s$ = 177.74208°

Coördinaten van Venus om $0^h$ TD:

maart 19 $\alpha_1$ = $2^h42^m43.25^s$ = 40.68021°, $\delta_1$ = +18°02’51.4” = +18.04761°  
maart 20 $\alpha_2$ = $2^h46^m55.51^s$ = 41.73129°, $\delta_2$ = +18°26’27.3” = +18.44092°  
maart 21 $\alpha_3$ = $2^h51^m07.69^s$ = 42.78204°, $\delta_3$ = +18°49’38.7” = +18.82742°

We nemen $h_0$ = -0.5667°, ${\Delta}T$ = +56 seconden, en vinden met formule (15.1) $\cos{H_0}$ = -0.3178735, $H_0$ = 108.5344°, vanwaar de geschatte waarden:

* doorvoer: $m_0$ = -0.18035, vanwaar $m_0$ = +0.81965
* opgang: $m_1$ = $m_0$ - 0.30148 = +0.51817
* ondergang: $m_2$ = $m_0$ + 0.30148 = +1.12113, vanwaar $m_2$ = +0.12113

Berekening van preciesere tijden:

| | | opgang | doorvoer | ondergang
--- | --- | --- | --- | ---
| | $m$ | +0.51817 | +0.81965 | +0.12113
| | $\theta_0$ | 4.79401° | 113.62397° | 221.46827°
| | $n$ | +0.51882 | +0.82030 | +0.12178
inter- | $\alpha$ | 42.27648° | 42.59324° | 41.85927°
polation | $\delta$ | +18.64229° | | +18.48835°
| | $H$ | -108.56577° | -0.05257° | +108.52570°
| | $h$ | -0.44393° | | -0.52711°
| | ${\Delta}m$ | -0.00051 | +0.00015 | 0.00017
gecorrigeerd | $m$ | +0.51766 | +0.81980 | +0.12130

Een nieuwe berekening, die deze nieuwe waarden van $m$ gebruikt, levert de nieuwe correcties -0.000003, -0.000004 en -0.000004 respectievelijk op, die kunnen worden verwaarloosd. We hebben dus eindelijk:

gebeuren | $m$ | tijd
--- | --- | ---
opgang: | $m_1 = +0.51766$ | $24^h$ x 0.51766 = $12^h25^m$ UT
doorvoer: | $m_0 = +0.81980$ | $24^h$ x 0.81980 = $19^h41^m$ UT
ondergang: | $m_2 = +0.12130$ | $24^h$ x 0.12130 = $2^h55^m$ UT

#### Noten

1. In voorbeeld 15.a ontdekten we dat in Boston de tijd van ondergang op 20 maart $2^h55^m$ UT was. Omgerekend naar *lokale* standaardtijd komt dit echter overeen met een moment op de avond van de vorige dag! Als echt de tijd van ondergang op 20 maart in lokale tijd nodig is, moet de berekening worden uitgevoerd met de waarde $m_2$ = +1.12113 die het eerst is gevonden, in plaats van +0.12113.
2. Als het lichaam cirkelvormig is, zal het tweede lid van formule (15.1) in absolute waarde groter zijn dan 1 en zal er geen hoek $H_0$ zijn. In zo'n geval blijft het lichaam de hele dag boven of beneden de horizon.
3. Als *geschatte* tijden voldoende zijn gebruik dan gewoon de *begin*waarden $m_0$, $m_1$ en $m_2$ gegeven door (15.2).
