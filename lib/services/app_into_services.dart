import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService {

  static Future<PackageInfo> getAppInfo() async {
    return await PackageInfo.fromPlatform();
  }

}