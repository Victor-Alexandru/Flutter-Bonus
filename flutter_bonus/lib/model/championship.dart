class Championship {
  String _total_matches;
  String _trophy;
  int _id;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  String get trophy => _trophy;

  set trophy(String trophy) {
    _trophy = trophy;
  }

  String get total_matches => _total_matches;

  set total_matches(String total_matches) {
    _total_matches = total_matches;
  }

  Championship.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _total_matches = json['total_matches'].toString(),
        _trophy = json['trophy'].toString();

  Championship(String tm, String trophy) {
    _total_matches = tm;
    _trophy = trophy;
  }
}
