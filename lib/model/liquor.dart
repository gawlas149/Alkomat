import 'dart:convert';

class Liquor {
  Liquor(this.name, this.percentage, this.volume);

  final String name;
  final double percentage;
  final int volume;

  Liquor.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        percentage = json['percentage'],
        volume = json['volume'];

  static Map<String, dynamic> toMap(Liquor liquor) => {
        'name': liquor.name,
        'percentage': liquor.percentage,
        'volume': liquor.volume,
      };

  static String encode(List<Liquor> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((music) => Liquor.toMap(music))
            .toList(),
      );

  static List<Liquor> decode(String liquors) =>
      (json.decode(liquors) as List<dynamic>)
          .map<Liquor>((item) => Liquor.fromJson(item))
          .toList();
}
