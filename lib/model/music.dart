import 'dart:convert';

MusicModel musicFromJson(String str) => MusicModel.fromMap(json.decode(str));

String musicToJson(MusicModel data) => json.encode(data.toJson());

class MusicModel {
  late String id;
  late String name;
  late String author;
  late String thumbnail;
  late String url;

  MusicModel({
    required this.id,
    required this.name,
    required this.url,
    required this.author,
    required this.thumbnail,
  });

  factory MusicModel.fromMap(Map<String, String?> json) => MusicModel(
    id: json["id"]!,
    name: json["name"]!,
    author: json["author"]!,
    thumbnail: json["thumbnail"]!,
    url: json["url"]!,
  );

  Map<String, String> toJson() => {
    "id": id,
    "name": name,
    "author": author,
    "thumbnail": thumbnail,
    "url": url,
  };
}
