library segment_key_modifier;

import 'dart:developer';
import 'dart:io';

import 'package:segment_key_modifier/file_repo.dart';

class SegmentKeyModifier {
  final String flavor;

  late String writeKey;
  final FileRepository _fileRepository = FileRepository();
  SegmentKeyModifier(this.flavor);

  void modifyKeys() async {
    final fileContents = await _fileRepository.readFileAsLineByline(
      _fileRepository.writeKeyPath,
    );
    _parseWriteKey(fileContents);
    await _modifyKeysInAndroid(writeKey);
    await _modifyKeysInIOS(writeKey);
  }

  Future<void> _modifyKeysInAndroid(String writeKey) async {
    final List<String> fileContent = await _fileRepository
        .readFileAsLineByline(_fileRepository.androidManifestPath);
    _addWriteKeyForAndroid(fileContent, writeKey);
    await writeFile(fileContent, _fileRepository.androidManifestPath);
  }

  Future<void> _modifyKeysInIOS(String writeKey) async {
    final List<String> fileContent = await _fileRepository
        .readFileAsLineByline(_fileRepository.iosInfoPlistPath);
    addWriteKeyForIos(fileContent, writeKey);
    await writeFile(fileContent, _fileRepository.iosInfoPlistPath);
  }

  void _addWriteKeyForAndroid(List<String> fileContent, String writeKey) {
    for (int i = 0; i < fileContent.length; i++) {
      if (fileContent[i].contains('WRITE_KEY')) {
        fileContent[i] =
            '\t<meta-data android:name="com.claimsforce.segment.WRITE_KEY" android:value="$writeKey"/>';
        break;
      }
    }
  }

  void addWriteKeyForIos(List<String> fileContent, String writeKey) {
    for (int i = 0; i < fileContent.length; i++) {
      if (fileContent[i].contains('WRITE_KEY')) {
        fileContent[i + 1] = '\t<string>$writeKey</string>';
        break;
      }
    }
  }

  Future<File> writeFile(List<String> fileContent, String path) async {
    return await File(path).writeAsString(
      fileContent.join('\n'),
    );
  }

  void _parseWriteKey(List<String> fileContents) {
    for (int i = 0; i < fileContents.length; i++) {
      if (fileContents[i].contains("writeKey")) {
        log("filecontent ${fileContents[i]}");
        var splittedContents = fileContents[i].split(":");
        writeKey = splittedContents.last.replaceAll('"', "").trim();
        break;
      }
    }
  }
}
