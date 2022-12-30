import 'package:get/get.dart';
import 'package:vaultz/core/snackbar.dart';
import 'package:vaultz/models/File.model.dart' as VaultzFile;
import 'package:vaultz/models/Folder.model.dart';
import 'package:vaultz/models/ResponseModel.dart';
import 'package:vaultz/repository/file_repo.dart';

class DirectoryController extends GetxController implements GetxService {
  final FileRepo fileRepo;
  DirectoryController({required this.fileRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Folder> _folders = [];
  List<Folder> get folders => _folders;

  List<VaultzFile.File> _files = [];
  List<VaultzFile.File> get files => _files;

  Folder? _activeFolder;
  Folder? get activeFolder => _activeFolder;

  List<String> _openedDirs = [];
  List<String> get openedDirs => _openedDirs;

  void addActiveDir(String dir) {
    if (_openedDirs.indexWhere((element) => element == dir) == -1) {
      _openedDirs.add(dir);
    }
  }

  void removeActiveDir(String dir) {
    _openedDirs.remove(dir);
    update();
  }

  void removeLastDir() {
    _openedDirs.removeLast();
    update();
  }

  Future<ResponseModel> getMyCloud() async {
    _isLoading = true;
    update();
    Response foldersRes = await fileRepo.getFolders();
    Response filesRes = await fileRepo.getFiles();
    late ResponseModel responseModel;

    if (foldersRes.isOk) {
      _folders = Folders.fromJson(foldersRes.body).folders;
    }
    if (filesRes.isOk) {
      _files = VaultzFile.Files.fromJson(filesRes.body).files;
    }
    if (!foldersRes.isOk && !filesRes.isOk) {
      responseModel = ResponseModel(false, "Failed to load vaultz");
    } else
      responseModel = ResponseModel(true, "Cloud Fetched");

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> getFolder(String folderID) async {
    _isLoading = true;
    Future.microtask(() => update());
    Response folderRes = await fileRepo.getFolder(folderID);
    if (folderRes.isOk) {
      _folders = Folders.fromJson(folderRes.body?['subDir']).folders;
      _files = VaultzFile.Files.fromJson(folderRes.body?['files']).files;
      _activeFolder = Folder.fromJson(folderRes.body['folder']);
    }
    _isLoading = false;
    update();
  }

  // FOLDER CRUD

  Future<void> createFolder(dynamic data) async {
    await fileRepo.newFolder(data);
  }

  Future<void> updateFolder(String folderID, dynamic data) async {
    var res = await fileRepo.updateFolder(folderID, data);
    int Index = _folders.indexWhere((element) => element.id == folderID);
    _folders[Index] = Folder.fromJson(res.body);
  }

  Future<void> trashFolder(String folderID) async {
    var res = await fileRepo.trashFolder(folderID);
    if (res.isOk) {
      showSuccessSnackbar("Folder trashed");
      _folders.removeWhere((element) => element.id == folderID);
      update();
    }
  }

  Future<void> restoreFolder(String folderID) async {
    await fileRepo.restoreFolder(folderID);
    _folders.removeWhere((element) => element.id == folderID);
    update();
  }

  Future<void> deleteFolder(String folderID) async {
    var res = await fileRepo.deleteFolder(folderID);
    if (res.isOk) {
      showSuccessSnackbar("Folder deleted permanently!");
      _folders.removeWhere((element) => element.id == folderID);
      update();
    }
  }

  /// ========= FILES CRUD
  ///
  ///
  ///
  Future<void> onNewFile(dynamic file) async {
    _files.add(VaultzFile.File.fromJson(file));
    update();
  }

  Future<void> updateFile(String fileID, dynamic data) async {
    var res = await fileRepo.updateFile(fileID, data);
    if (res.isOk) {
      int fileIndex = _files.indexWhere((element) => element.id == fileID);
      _files[fileIndex] = VaultzFile.File.fromJson(res.body);
      update();
    } else {
      showSuccessSnackbar("File update Failed!");
    }
  }

  Future<void> trashFile(String fileID) async {
    var res = await fileRepo.trashFile(fileID);
    if (res.isOk) {
      showSuccessSnackbar("File trashed");
      _files.removeWhere((element) => element.id == fileID);
      update();
    }
  }

  Future<void> restoreFile(String fileID) async {
    var res = await fileRepo.restoreFile(fileID);
    if (res.isOk) _files.removeWhere((element) => element.id == fileID);
    update();
  }

  Future<void> deleteFile(String fileID) async {
    var res = await fileRepo.deleteFile(fileID);
    if (res.isOk) {
      showSuccessSnackbar("File deleted permanently!");
      _files.removeWhere((element) => element.id == fileID);
      update();
    }
  }

  // TRASH
  Future<void> getTrashRoot() async {
    _isLoading = true;
    Future.microtask(() => update());
    Response trashRes = await fileRepo.getTrash();
    if (trashRes.isOk) {
      _folders = Folders.fromJson(trashRes.body?['folders']).folders;
      _files = VaultzFile.Files.fromJson(trashRes.body?['files']).files;
    }
    _isLoading = false;
    update();
  }

  Future<void> getTrashFolder(String folderID) async {
    _isLoading = true;
    Future.microtask(() => update());
    Response folderRes = await fileRepo.getTrashFolder(folderID);
    if (folderRes.isOk) {
      _folders = Folders.fromJson(folderRes.body?['folders']).folders;
      _files = VaultzFile.Files.fromJson(folderRes.body?['files']).files;
      _activeFolder = Folder.fromJson(folderRes.body['activeFolder']);
    }
    _isLoading = false;
    update();
  }

  Future<void> clearTrash() async {
    await fileRepo.clearTrash();
    _folders.removeRange(0, _folders.length < 1 ? 0 : _folders.length);
    _files.removeRange(0, _files.length < 1 ? 0 : _files.length);
    update();
  }
}
