class File {
  String? name;
  String? mimetype;
  String? type;
  int? size;
  String? user;
  bool? hidden;
  bool? encrypted;
  bool? locked;
  bool? trash;
  String? store;
  String? createdAt;
  String? updatedAt;
  String? id;
  String? url;

  File(
      {this.name,
      this.mimetype,
      this.type,
      this.size,
      this.user,
      this.hidden,
      this.encrypted,
      this.locked,
      this.trash,
      this.store,
      this.createdAt,
      this.updatedAt,
      this.id,
      this.url});

  File.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mimetype = json['mimetype'];
    type = json['type'];
    size = json['size'];
    user = json['user'];
    hidden = json['hidden'];
    encrypted = json['encrypted'];
    locked = json['locked'];
    trash = json['trash'];
    store = json['store'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['mimetype'] = mimetype;
    data['type'] = type;
    data['size'] = size;
    data['user'] = user;
    data['hidden'] = hidden;
    data['encrypted'] = encrypted;
    data['locked'] = locked;
    data['trash'] = trash;
    data['store'] = store;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['id'] = id;
    data['url'] = url;
    return data;
  }
}

class Files {
  late List<File> _files;
  List<File> get files => _files;

  Files({required files}) {
    _files = files;
  }

  Files.fromJson(List data) {
    _files = <File>[];
    for (var v in data) {
      _files.add(File.fromJson(v));
    }
  }
}
