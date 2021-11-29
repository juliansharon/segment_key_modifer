import 'dart:io';

class FileRepository {
  String androidManifestPath = "./android/app/src/main/AndroidManifest.xml";
  String iosInfoPlistPath = "./ios/Runner/Info.plist";
  String writeKeyPath = "./assets/ecoSdkConfig/segment_config.json";
  Future<List<String>> readFileAsLineByline(String filePath) async {
    try {
      String fileAsString = await File(filePath).readAsString();
      return fileAsString.split("\n");
    } catch (e) {
      return [];
    }
  }
}
