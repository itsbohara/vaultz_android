import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:vaultz/controllers/file.controller.dart';
import 'package:vaultz/core/snackbar.dart';
import 'package:vaultz/fileViewer/AudioPLayer.dart';
import 'package:vaultz/fileViewer/ImageViewer.dart';
import 'package:vaultz/fileViewer/VideoViewer.dart';
import 'package:vaultz/models/File.model.dart' as VaultzFile;
import 'package:vaultz/utils/file.dart';

class FileViewer extends StatefulWidget {
  FileViewer({super.key, this.file});

  VaultzFile.File? file;

  @override
  State<FileViewer> createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer> {
  var fileController = Get.find<FileController>();

  File? vautlzFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fileController.initVaultz();
    downloadFile();
  }

  downloadFile() async {
    var url = widget.file!.url!;
    if (Uri.parse(widget.file!.url!).host.isEmpty) {
      // url = 'http://192.168.0.108:9999' + url;
      showCustomErrorSnackbar("Invalid file source");
      Navigator.pop(context);
    }
    var file = await DefaultCacheManager().getSingleFile(url);

    setState(() {
      vautlzFile = file;
    });

    if (widget.file!.encrypted!) {
      var b = await file.openRead(0, 9).first;
      if (utf8.decode(b) == "ibVaultz_") {
        try {
          Get.find<FileController>().tryDecryption(file);
        } catch (e) {
          print("decryot failed ???");
        }
      } else {
        // print("decryption Failed!");
        // showCustomErrorSnackbar("File decryption failed!");
        showCustomErrorSnackbar(
            "File is not encrypted using vaultz or file may corrupted!");
        Get.back();
      }
    } else {
      fileController.stopDecryption();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.find<FileController>().deleteDecryptedFile();
  }

  getFileType() {
    var format = getFileFormat(widget.file!.mimetype!);
    // if format is file, try to get file type using name ext
    if (format == 'file') {
      format = getFileFormat(widget.file!.name!.split(".").last);
    }
    if (format == 'img') format = 'image';
    return format;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.file?.name ?? "File Viewer")),
      body: GetBuilder<FileController>(builder: (file) {
        if (file.isDecrypting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        File vaultzFile =
            widget.file!.encrypted! ? file.decryptedFile! : vautlzFile!;
        var fileType = getFileType();

        if (fileType == 'image') {
          return ImageViewer(file: vaultzFile);
        }

        if (fileType == 'video') {
          return VideoViewer(file: vaultzFile);
        }
        if (fileType == 'audio') {
          return AudioPlayer(file: vaultzFile);
        }
        return Container(
          child: Text("File Viewer"),
        );
      }),
    );
  }
}
