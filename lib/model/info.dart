class Info {
  late String sender;
  late String text;
  late var time;

  Info();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['text'] = text;
    map['sender'] = sender;
    map['time'] = time;
    return map;
  }

  Info.fromJson(Map<String, dynamic> toJson) {
    text = toJson['text'];
    sender = toJson['sender'];
    time = toJson['time'];
  }
}