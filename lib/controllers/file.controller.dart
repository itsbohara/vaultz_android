import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vaultz/controllers/auth_controller.dart';
import 'package:vaultz/controllers/directory.controller.dart';
import 'package:vaultz/controllers/vaultz_controller.dart';
import 'package:vaultz/core/snackbar.dart';
import 'package:vaultz/models/ResponseModel.dart';
import 'package:vaultz/models/User.model.dart';
import 'package:vaultz/repository/auth_repo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:vaultz/repository/file_repo.dart';
import 'package:vaultz/utils/constants.dart';
import 'dart:convert' show base64, utf8;
import 'package:webcrypto/webcrypto.dart';

// app auth controller

class FileController extends GetxController implements GetxService {
  final FileRepo fileRepo;
  final FlutterSecureStorage storage;
  FileController({required this.fileRepo, required this.storage});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isDecrypting = false;
  bool get isDecrypting => _isDecrypting;

  bool _authorized = false;
  bool get isAuthorized => _authorized;
//
  Uint8List? _key;
  Uint8List? get key => _key;

  String? _session;
  String? get session => _session;

  static int CHUNK_SIZE = 64 * 1024 * 1024; // 64 MB
  static int startIndex = 17;
  static int ivLength = 16;

  Uint8List? decryptionIVBytes;
  AesCbcSecretKey? theDecryptionKey;

  int fileSize = 0;
  int fileIndex = 0;

  Uint8List _file = Uint8List.fromList([]);
  // Uint8List _file = Uint8List.fromList(List.empty(growable: true));

  var _encryptedFile = ValueNotifier<File?>(null);
  ValueNotifier<File?> get encryptedFile => _encryptedFile;
  File? _decryptedFile;
  File? get decryptedFile => _decryptedFile;
  Uint8List _encFileData = Uint8List.fromList([]);

//  file encryption at client side for before uploading
  Uint8List? toEncryptFile;
  bool _encryptForUploading = true;
  bool get encryptFile => _encryptForUploading;

  bool _isEncrypting = false;
  bool get isEncrypting => _isEncrypting;
  AesCbcSecretKey? theEncryptionKey;
  Uint8List? encryptionSalt;
  Uint8List? encryptionIVBytes;

  Future<void> initVaultz({bool? encryption = false}) async {
    _key = Get.find<VaultzController>().key;
    if (!encryption!) _isDecrypting = true;
  }

  void stopDecryption() {
    _file = Uint8List.fromList([]);
    _decryptedFile = null;
    _isDecrypting = false;
    update();
  }

  void reset() {
    fileIndex = 0;
    fileSize = 0;
    update();
  }
  //// ==========================
  /// ======= ENCRYPTION ========
  /// ===========================

  Future<void> setupVaultzEncryptionKey() async {
    encryptionSalt = Uint8List(8);
    fillRandomBytes(encryptionSalt!);

    var importKey = await Pbkdf2SecretKey.importRawKey(key!);
    var pbkdf2bytes = await importKey.deriveBits(
        AppConstants.PBKDF2DeriveBitLength,
        Hash.sha256,
        encryptionSalt!,
        AppConstants.pbkdf2iterations);

    var keybytes = pbkdf2bytes.sublist(0, 32);
    encryptionIVBytes = pbkdf2bytes.sublist(32);

    theEncryptionKey = await AesCbcSecretKey.importRawKey(keybytes);
  }

  //// ==========================
  /// ======= DECRYPTION ========
  /// ===========================

  Future<void> deleteDecryptedFile() async {
    if (_decryptedFile == null) return;
    var vaultzFileExists = await _decryptedFile!.exists();
    if (vaultzFileExists) await _decryptedFile?.delete();
  }

  Future<void> tryDecryption(File file) async {
    reset();
    _isLoading = true;
    _isDecrypting = true;
    _encryptedFile.value = file;
    _file = Uint8List.fromList([]);
    update();

    var signature = await file.openRead(0, 9).first;
    var salt = await file.openRead(9, 17).first;

    if (utf8.decode(signature) == "ibVaultz_") {
      _encFileData = await file.readAsBytes();

      // var chunk = await file
      //     .openRead(startIndex, startIndex + ivLength + CHUNK_SIZE)
      //     .first;

      var chunkSize = startIndex + ivLength + CHUNK_SIZE;
      if (_encFileData.length < chunkSize) chunkSize = _encFileData.length;
      var chunk = _encFileData.sublist(startIndex, chunkSize);

      bool testDecrypted = await requestDecryption(salt, chunk);
      if (testDecrypted) {
        fileSize = await file.length();
        fileIndex = startIndex + ivLength + CHUNK_SIZE;
        decryptChunks(chunk, fileIndex >= fileSize);
      }
    } else {
      _isDecrypting = false;
      _isLoading = false;
    }
    update();
  }

  Future<void> decryptChunks(chunk, last) async {
    fileIndex = ivLength + CHUNK_SIZE;
    var decryptedChunk =
        await theDecryptionKey?.decryptBytes(chunk, decryptionIVBytes!);

    _file =
        Uint8List.fromList([..._file.toList(), ...decryptedChunk!.toList()]);
    // _file.addAll(decryptedChunk!);

    if (!last) continueDecryption();
    if (last) finalizeDecryption();
  }

  Future<void> continueDecryption() async {
    var chunk = await encryptedFile.value
        ?.openRead(fileIndex, ivLength + CHUNK_SIZE)
        .first;
    decryptChunks(chunk, fileIndex >= fileSize);
  }

  Future<bool> requestDecryption(salt, chunk) async {
    try {
      var importKey = await Pbkdf2SecretKey.importRawKey(key!);
      var pbkdf2bytes = await importKey.deriveBits(
          AppConstants.PBKDF2DeriveBitLength,
          Hash.sha256,
          salt,
          AppConstants.pbkdf2iterations);

      var keybytes = pbkdf2bytes.sublist(0, 32);
      decryptionIVBytes = pbkdf2bytes.sublist(32);

      theDecryptionKey = await AesCbcSecretKey.importRawKey(keybytes);
      var data =
          await theDecryptionKey?.decryptBytes(chunk, decryptionIVBytes!);
      return true;
    } catch (e) {
      print("file decrypt test failed ??");
      print(e);
      _isDecrypting = false;
      _isLoading = false;
      return false;
    }
  }

  Future<void> finalizeDecryption() async {
    final tempDir = await getTemporaryDirectory();

    _decryptedFile = await File("${tempDir.path}/vaultz-${Uuid().v4()}")
        .writeAsBytes(_file, mode: FileMode.writeOnly);

    _isDecrypting = false;
    _isLoading = false;
    update();
  }

///// ====================
///// ======= ENCRYPTION =============

  Future<void> encryptFirstChunks(chunk, last) async {
    var encryptedChunk =
        await theEncryptionKey?.encryptBytes(chunk, encryptionIVBytes!);

    _file = Uint8List.fromList([
      ...utf8.encode("ibVaultz_"),
      ...encryptionSalt!,
      ...encryptedChunk!.toList()
    ]);

    if (!last) continueEncryption();
    if (last) finalizeEncryption();
  }

  Future<void> encryptRestofChunks(chunk, last) async {
    var encryptedChunk =
        await theEncryptionKey?.encryptBytes(chunk, encryptionIVBytes!);

    _file =
        Uint8List.fromList([..._file.toList(), ...encryptedChunk!.toList()]);

    if (!last) continueEncryption();
    if (last) finalizeEncryption();
  }

  Future<void> continueEncryption() async {
    fileIndex += CHUNK_SIZE;
    var chunkSize = fileSize < fileIndex ? fileSize : fileIndex;
    var chunk = toEncryptFile?.sublist(fileIndex, ivLength + CHUNK_SIZE).first;
    encryptRestofChunks(chunk, fileIndex >= fileSize);
  }

  Future<void> finalizeEncryption() async {
    final tempDir = await getTemporaryDirectory();

    _encryptedFile.value = await File("${tempDir.path}/vaultz-${Uuid().v4()}")
        .writeAsBytes(_file, mode: FileMode.writeOnly);

    _isEncrypting = false;
    _isLoading = false;
    update();
  }

  Future encryptVaultzFile(File file) async {
    toEncryptFile = await file.readAsBytes();
    reset();
    fileSize = file.lengthSync();
    await setupVaultzEncryptionKey();
    var chunkSize = fileSize < CHUNK_SIZE ? fileSize : CHUNK_SIZE;
    var chunk = toEncryptFile?.sublist(fileIndex, chunkSize);
    fileIndex = CHUNK_SIZE;
    encryptFirstChunks(chunk, fileIndex >= fileSize);
  }

  Future<ResponseModel> uploadEncryptedFile(
      String fileName, String fileType) async {
    _isLoading = true;
    update();
    late ResponseModel responseModel;
    var activeFolder = Get.find<DirectoryController>().activeFolder;
    try {
      var res = await fileRepo.uploadEncryptedFile(
          encryptedFile.value!, fileName, fileType,
          dir: activeFolder?.id, mbCloud: true);

      if (res.statusCode == 200) {
        Get.find<DirectoryController>().onNewFile(res.body);
        responseModel = ResponseModel(true, "File uploaded");
      } else {
        responseModel =
            ResponseModel(false, res.statusText ?? "Failed to upload");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Failed to upload");
    }
    return responseModel;
  }

  Future<ResponseModel> uploadFile(File file) async {
    _isLoading = true;
    update();
    late ResponseModel responseModel;
    var activeFolder = Get.find<DirectoryController>().activeFolder;
    try {
      var res =
          await fileRepo.uploadFile(file, mbCloud: true, dir: activeFolder?.id);
      if (res.statusCode == 200) {
        Get.find<DirectoryController>().onNewFile(res.body);
        responseModel = ResponseModel(true, "File uploaded");
      } else {
        responseModel =
            ResponseModel(false, res.statusText ?? "Failed to upload");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Failed to upload");
    }

    _isLoading = false;
    update();
    responseModel = ResponseModel(false, "Failed to upload");
    return responseModel;
  }

  void toggleFileEncrypt() {
    _encryptForUploading = !_encryptForUploading;
    update();
  }
}
