class User {
  String? name;
  String? email;
  int? id;
  late bool verified;

  User({this.name, this.email, this.id, this.verified = false});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    email = json['email'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['email'] = email;
    data['verified'] = verified;
    return data;
  }
}
