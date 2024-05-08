class Biblio {
  String name;
  String adress;
  String imagePath;
  String status;

  Biblio(
      {required this.name,
      required this.adress,
      required this.status,
      required this.imagePath});

  String get _name => name;
  String get _adress => adress;
  String get _imagePath => imagePath;
  String get _status => status;
}
