import 'dart:async';

import '../modellen/dag.dart';
import '../modellen/gregoriaans_jaar.dart';
import '../modellen/maand.dart';
import '../modellen/zonnetijd.dart';

class Kalender {
  late Dag gisteren;
  late Dag vandaag;
  late Dag morgen;

  GregoriaansJaar? afgelopenJaar;
  late GregoriaansJaar ditJaar;
  GregoriaansJaar? volgendJaar;

  Maand? afgelopenMaand;
  late Maand dezeMaand;
  Maand? volgendeMaand;

  Kalender() {
    DateTime nu = DateTime.now();
    ditJaar = GregoriaansJaar(nu.year);
    int dagInHetJaar = krijgDagInHetJaar(nu, ditJaar);
    dezeMaand = Maand(
      gregoriaansJaar: ditJaar.jaarGetal,
      epacta: ditJaar.epacta,
      nieuweMaandInHetJaar: ditJaar.nieweMaanden.lastWhere(
        (element) => element <= dagInHetJaar,
      ),
    );
    vandaag = Dag(
      dagInHetJaar: dagInHetJaar,
      datum: nu,
      maand: dezeMaand,
    );
    if (dagInHetJaar == 1) afgelopenJaar = GregoriaansJaar(nu.year - 1);
    if (dagInHetJaar == dezeMaand.nieuweMaandInHetJaar) {
      afgelopenMaand = Maand(
        gregoriaansJaar: ditJaar.jaarGetal,
        epacta: ditJaar.epacta,
        nieuweMaandInHetJaar: ditJaar.nieweMaanden.firstWhere(
          (element) => element >= dagInHetJaar - 1,
        ),
      );
    }
    DateTime afgelopenDag = DateTime(nu.year, nu.month, nu.day - 1);
    gisteren = Dag(
      dagInHetJaar: krijgDagInHetJaar(afgelopenDag, afgelopenJaar ?? ditJaar),
      datum: afgelopenDag,
      maand: afgelopenMaand ?? dezeMaand,
    );

    _nieuweMorgen(vandaag);
  }

  void _nieuweMorgen(Dag vandaag) {
    if (vandaag.dagInHetJaar == 365) {
      volgendJaar = GregoriaansJaar(vandaag.datum.year + 1);
    }
    DateTime komendeDag = DateTime(
      vandaag.datum.year,
      vandaag.datum.month,
      vandaag.datum.day + 1,
    );
    int komendeDIHJ = krijgDagInHetJaar(komendeDag, volgendJaar ?? ditJaar);
    if (volgendJaar?.nieweMaanden.contains(komendeDIHJ) ??
        ditJaar.nieweMaanden.contains(komendeDIHJ)) {
      volgendeMaand = Maand(
        gregoriaansJaar: volgendJaar?.jaarGetal ?? ditJaar.jaarGetal,
        epacta: volgendJaar?.epacta ?? ditJaar.epacta,
        nieuweMaandInHetJaar: komendeDIHJ,
      );
    }
    morgen = Dag(
      dagInHetJaar: komendeDIHJ,
      datum: komendeDag,
      maand: volgendeMaand ?? dezeMaand,
    );
  }

  int krijgDagInHetJaar(DateTime datum, GregoriaansJaar jaar) {
    int dagInHetJaar = 275 * datum.month ~/ 9 -
        (datum.month + 9) ~/ 12 * (jaar.isSchrikkelJaar ? 1 : 2) -
        30 +
        datum.day;
    return dagInHetJaar - (jaar.isSchrikkelJaar && dagInHetJaar > 55 ? 1 : 0);
  }

  Stream<Zonnetijd> krijgZonnetijdStroom() => Stream<Zonnetijd>.periodic(
        const Duration(seconds: 5),
        krijgZonnetijd,
      );

  Zonnetijd krijgZonnetijd(_) {
    DateTime nu = DateTime.now();
    if (nu.day != vandaag.datum.day) _nieuweDag();
    int tijdStempel = nu.millisecondsSinceEpoch;

    if (tijdStempel >= vandaag.zonsOndergang) return _volgendNacht(tijdStempel);
    if (tijdStempel >= vandaag.zonsOpgang) return _overDag(tijdStempel);
    return _nacht(tijdStempel);
  }

  Zonnetijd _volgendNacht(int tijdStempel) {
    return _zetZonnetijd(
      dag: morgen,
      uur: 12 *
          _angebrokenDagNacht(
            vandaag.zonsOndergang,
            tijdStempel,
            morgen.zonsOpgang,
          ),
    );
  }

  Zonnetijd _overDag(int tijdStempel) {
    return _zetZonnetijd(
      dag: vandaag,
      uur: 12 +
          12 *
              _angebrokenDagNacht(
                vandaag.zonsOpgang,
                tijdStempel,
                vandaag.zonsOndergang,
              ),
    );
  }

  Zonnetijd _nacht(int tijdStempel) {
    return _zetZonnetijd(
      dag: vandaag,
      uur: 12 *
          _angebrokenDagNacht(
            gisteren.zonsOndergang,
            tijdStempel,
            vandaag.zonsOpgang,
          ),
    );
  }

  double _angebrokenDagNacht(int begin, int tijdpunt, int einde) =>
      (tijdpunt - begin) / (einde - begin);

  Zonnetijd _zetZonnetijd({required Dag dag, required double uur}) {
    return Zonnetijd(
      weekdag: dag.datum.weekday,
      dag: dag.maandDag,
      joodseMaand: dag.maand.joodseMaand,
      hidjriMaand: dag.maand.hidjriMaand,
      hidjriJaar: dag.maand.hidjriJaar,
      uur: uur,
    );
  }

  void _nieuweDag() {
    gisteren = vandaag;
    afgelopenMaand = null;
    afgelopenJaar = null;

    vandaag = morgen;
    if (volgendeMaand != null) {
      afgelopenMaand = dezeMaand;
      dezeMaand = volgendeMaand!;
      volgendeMaand = null;
    }

    if (volgendJaar != null) {
      afgelopenJaar = ditJaar;
      ditJaar = volgendJaar!;
      volgendJaar = null;
    }
    _nieuweMorgen(vandaag);
  }
}
