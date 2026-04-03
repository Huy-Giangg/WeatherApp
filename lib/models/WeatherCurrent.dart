
class Weathercurrent {
  final DateTime lastUpdate;
  final double temp_c;
  final String desc;
  final String icon;

  Weathercurrent ({
    required this.lastUpdate,
    required this.temp_c,
    required this.desc,
    required this.icon,
  });

  factory Weathercurrent.fromJson(Map<String, dynamic> json){
    return Weathercurrent(
        lastUpdate: DateTime.parse(json['last_updated']),
        temp_c: json['temp_c'].toDouble(),
        desc: json['condition']['text'],
        icon: json['condition']['icon'],
    );
  }
}