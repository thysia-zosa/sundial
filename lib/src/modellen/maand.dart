class Maand {
  final int gregoriaansJaar;
  final int nieuweMaandInHetJaar;
  final int epacta;
  late int _joodseMaand;
  late int _joodsJaar;
  late int _hidjriMaand;
  late int _hidjriJaar;

  Maand({
    required this.gregoriaansJaar,
    required this.epacta,
    required this.nieuweMaandInHetJaar,
  }) {
    _joodseMaand = nieuweMaandInHetJaar < 67
        ? ((nieuweMaandInHetJaar + (epacta + 25) % 30 + 299) / 29.5).round()
        : ((nieuweMaandInHetJaar + (epacta + 6) % 30 - 66) / 29.5).round();
    int maandenSindsNull =
        (((gregoriaansJaar - 622) * 365.2425 + nieuweMaandInHetJaar - 209) *
                360 /
                10631)
            .round();
    _joodsJaar = gregoriaansJaar + 3760;
    if (nieuweMaandInHetJaar > 243) _joodsJaar++;
    _hidjriJaar = maandenSindsNull ~/ 12 + 1;
    _hidjriMaand = maandenSindsNull % 12;
  }

  int get joodseMaand => _joodseMaand;
  int get joodsJaar => _joodsJaar;
  int get hidjriMaand => _hidjriMaand;
  int get hidjriJaar => _hidjriJaar;
}
