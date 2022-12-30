import 'dart:math';

List<String> viewSupportedFileExts = ['image', 'video', 'audio', 'pdf'];
List<String> imgExts = ['jpg', 'jpeg', 'png', 'gif'];
List<String> audioExts = ['wav', 'ogg', 'mp3', 'm4a'];
List<String> videoExts = ['mp4', 'mkv', 'avi', 'flv', "webm", 'mov'];

String formatBytes(int bytes, {int decimals = 2}) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
}

String getFileFormat(String mimeType) {
  mimeType = mimeType.toLowerCase();
  var format;
  if (mimeType.contains("image") ||
      (imgExts.indexWhere((element) => element == mimeType) != -1)) {
    format = 'img';
  } else if (mimeType.contains("audio") ||
      (audioExts.indexWhere((element) => element == mimeType) != -1)) {
    format = 'audio';
  } else if (mimeType.contains("video") ||
      (videoExts.indexWhere((element) => element == mimeType) != -1)) {
    format = 'video';
  } else if (mimeType.contains("zip")) {
    format = 'zip';
  } else {
    format = 'file';
  }

  return format;
}

getIconAsset(mime) {
  if (mime == 'folder') return "assets/icons/ic_folder.svg";

  /// try to get file icon
  return "assets/icons/file/ic_" + getFileFormat(mime) + '.svg';
}
