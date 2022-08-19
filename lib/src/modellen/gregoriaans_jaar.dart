class GregoriaansJaar {
  int jaarGetal;
  final int _goudenGetal;
  final int _epacta;
  final bool _isSchrikkeljaar;
  late final List<int> _nieuweMaanden;
  final int _zondagsGetal;

  GregoriaansJaar(
    this.jaarGetal,
  )   : _goudenGetal = jaarGetal % 19 + 1,
        _isSchrikkeljaar =
            jaarGetal % 400 == 0 || jaarGetal % 4 == 0 && jaarGetal % 100 != 0,
        _zondagsGetal = (0 -
                jaarGetal -
                (jaarGetal / 4).floor() -
                (jaarGetal / 400).floor() +
                (jaarGetal / 100).floor()) %
            7,
        _epacta = (26 +
                    11 * (jaarGetal % 19 + 1) +
                    ((jaarGetal / 100 + 11).floor() * 8 / 25 - 3).floor() -
                    ((jaarGetal / 100 + 1).floor() * 3 / 4).floor()) %
                30 +
            1 {
    int vroeger = _epacta < (_goudenGetal > 11 ? 26 : 25) ? 1 : 0;
    _nieuweMaanden = [
      1 - _epacta,
      31 - _epacta,
      61 - _epacta - vroeger,
      90 - _epacta,
      120 - _epacta - vroeger,
      149 - _epacta,
      179 - _epacta - vroeger,
      208 - _epacta,
      238 - _epacta - vroeger,
      267 - _epacta,
      297 - _epacta - vroeger,
      326 - _epacta,
      356 - _epacta - vroeger,
    ];
    if (_goudenGetal == 1) _nieuweMaanden.first++;
    if (_epacta > 19) _nieuweMaanden.add(385 - _epacta);
  }

  int get goudenGetal => _goudenGetal;
  int get epacta => _epacta;
  bool get isSchrikkelJaar => _isSchrikkeljaar;
  List<int> get nieweMaanden => _nieuweMaanden;
  int get zondagsGetal => _zondagsGetal;
}
