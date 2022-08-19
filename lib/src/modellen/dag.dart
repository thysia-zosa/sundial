import 'locatie.dart';

class Dag {
  final int dagInHetJaar;
  final int nieweDagInHetJaar;
  final Locatie locatie = Locatie(breedte: 47.475683, lengte: 8.22245);
  // final int _vertraging;

  Dag({required this.dagInHetJaar, required this.nieweDagInHetJaar});
}
