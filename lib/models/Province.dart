
class Province {
  final String name;
  final String codeName;

  Province({
    required this.name,
    required this.codeName,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      name: json['name'],
      codeName: _removePrefix(json['codename']),
    );
  }

  static _removePrefix(String codename) {
    return codename.replaceFirst(
      RegExp(r'^(tinh_|thanh_pho_)'),
      '',
    );
  }
}


