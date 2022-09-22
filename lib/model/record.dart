class Record {
  String? id;
  int? datetime;
  String? genre;
  String? content;
  int? money;
  String? type;

  Record({this.id, this.datetime, this.genre, this.content, this.money, this.type});

  Record.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    datetime = json['datetime'];
    genre = json['genre'];
    content = json['content'];
    money = json['money'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['datetime'] = datetime;
    data['genre'] = genre;
    data['content'] = content;
    data['money'] = money;
    data['type'] = type;
    return data;
  }
}