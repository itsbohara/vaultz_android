import 'dart:convert';

class Folder {
  String? name;
  String? parent;
  int? size;
  String? user;
  bool? hidden;
  bool? trash;
  String? createdAt;
  String? updatedAt;
  String? id;

  Folder(
      {this.name,
      this.parent,
      this.size,
      this.user,
      this.hidden,
      this.trash,
      this.createdAt,
      this.updatedAt,
      this.id});

  Folder.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['parent'] != null) {
      if (json['parent'].runtimeType != String) {
        parent = json['parent']?['id'] ?? json['parent'];
      } else
        parent = json['parent'];
    }
    size = json['size'];
    user = json['user'];
    hidden = json['hidden'];
    trash = json['trash'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['parent'] = parent;
    data['size'] = size;
    data['user'] = user;
    data['hidden'] = hidden;
    data['trash'] = trash;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['id'] = id;
    return data;
  }
}

class Folders {
  late List<Folder> _folders;
  List<Folder> get folders => _folders;

  Folders({required folders}) {
    _folders = folders;
  }

  Folders.fromJson(List data) {
    _folders = <Folder>[];
    for (var v in data) {
      _folders.add(Folder.fromJson(v));
    }
  }
}
