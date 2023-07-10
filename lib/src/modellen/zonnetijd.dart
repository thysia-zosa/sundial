class Zonnetijd {
  final int weekdag;
  final int dag;
  final int joodseMaand;
  final int joodsJaar;
  final int hidjriMaand;
  final int hidjriJaar;
  final double uur;

  Zonnetijd({
    required this.weekdag,
    required this.dag,
    required this.joodseMaand,
    required this.joodsJaar,
    required this.hidjriMaand,
    required this.hidjriJaar,
    required this.uur,
  });

  @override
  String toString() {
    return '''weekdag: $weekdag
dag: $dag
joodseMaand: $joodseMaand
joodsJaar: $joodsJaar
hidjriMaand: $hidjriMaand
hidjriJaar: $hidjriJaar
uur: $uur''';
  }
}
