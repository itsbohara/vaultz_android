class User {
  String? id;
  String? name;
  String? email;
  String? createdAt;
  String? updatedAt;
  int? storageQuota;
  String? vaultzKey;
  User(
      {this.name,
      this.email,
      this.createdAt,
      this.updatedAt,
      this.storageQuota,
      this.vaultzKey,
      this.id});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    storageQuota = json['storageQuota'];
    id = json['id'];
    vaultzKey = json['vaultzKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['storageQuota'] = storageQuota;
    data['vaultzKey'] = vaultzKey;
    data['id'] = id;
    return data;
  }
}
