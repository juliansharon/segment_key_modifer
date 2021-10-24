library segment_key_modifier;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:segment_key_modifier/file_repo.dart';

class SegmentKeyModifier {
  final String flavor;

  late String writeKey;
  final FileRepository _fileRepository = FileRepository();
  SegmentKeyModifier(this.flavor);
  void modifyKeys() async {
    final jsonPath =
        "$_fileRepository.writeKeyPath+\\ibb\\$flavor\\segment_configuration.dart";
    final decoded = jsonDecode(await rootBundle.loadString(jsonPath));
    print("${decoded['writeKey']}");
    writeKey = decoded['writeKey'];
    await _modifyKeysInAndroid(writeKey);
    await _modifyKeysInIOS(writeKey);
  }

  Future<void> _modifyKeysInAndroid(String writeKey) async {
    final List<String> fileContent = await _fileRepository
        .readFileAsLineByline(_fileRepository.androidManifestPath);

    for (int i = 0; i < fileContent.length; i++) {
      if (fileContent[i].contains('WRITE_KEY')) {
        fileContent[i] =
            '<meta-data android:name="com.claimsforce.segment.WRITE_KEY" android:value="$writeKey"/>';
        break;
      }
    }

    await File(_fileRepository.androidManifestPath).writeAsString(
      fileContent.join('\n'),
    );
  }

  Future<void> _modifyKeysInIOS(String writeKey) async {
    final List<String> fileContent = await _fileRepository
        .readFileAsLineByline(_fileRepository.androidManifestPath);

    for (int i = 0; i < fileContent.length; i++) {
      if (fileContent[i].contains('WRITE_KEY')) {
        fileContent[i + 1] = '<string>$writeKey</string>';
        break;
      }
    }

    await File(_fileRepository.androidManifestPath).writeAsString(
      fileContent.join('\n'),
    );
  }
}
