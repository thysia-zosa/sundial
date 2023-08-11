import 'dag.dart';

class Zonnetijd {
  final int weekdag;
  final Dag dag;
  final int joodseMaand;
  final int joodsJaar;
  final bool isSchrikkelMaand;
  final int hidjriMaand;
  final int hidjriJaar;
  final double uur;

  Zonnetijd({
    required this.weekdag,
    required this.dag,
    required this.joodseMaand,
    required this.joodsJaar,
    required this.isSchrikkelMaand,
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
isSchrikkelMaand: $isSchrikkelMaand
hidjriMaand: $hidjriMaand
hidjriJaar: $hidjriJaar
uur: $uur''';
  }
}
