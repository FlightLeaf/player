import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {

  static Future<bool> requestAllPermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.photos,
      Permission.speech,
      Permission.storage,
      Permission.phone,
      Permission.notification,
    ].request();
    if (await Permission.photos.isGranted) {

      print("照片权限申请通过");
      return true;
    } else {
      print("照片权限申请失败");
    }
    if (await Permission.speech.isGranted) {
      print("语音权限申请通过");
      return true;
    } else {
      print("语音权限申请失败");
    }
    if (await Permission.storage.isGranted) {
      print("文件权限申请通过");
      return true;
    } else {
      print("文件权限申请失败");
    }
    if (await Permission.phone.isGranted) {
      print("手机权限申请通过");
      return true;
    } else {
      print("手机权限申请失败");
    }
    if (await Permission.notification.isGranted) {
      print("通知权限申请通过");
      return true;
    } else {
      print("通知权限申请失败");
    }
    return false;
  }

  static Future<bool> requestPhotosPermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.photos,
    ].request();
    if (await Permission.photos.isGranted) {
      print("照片权限申请通过");
      return true;
    } else {
      print("照片权限申请失败");
    }
    return false;
  }

  static Future<bool> requestSpeechPermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.speech,
    ].request();
    if (await Permission.speech.isGranted) {
      print("语音权限申请通过");
      return true;
    } else {
      print("语音权限申请失败");
    }
    return false;
  }

  static Future<bool> requestStoragePermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.storage,
    ].request();
    if (await Permission.storage.isGranted) {
      print("文件权限申请通过");
      return true;
    } else {
      print("文件权限申请失败");
    }
    return false;
  }

  static Future<bool> requestPhonePermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.phone,
    ].request();
    if (await Permission.phone.isGranted) {
      print("手机权限申请通过");
      return true;
    } else {
      print("手机权限申请失败");
    }
    return false;
  }

  static Future<bool> requestNotificationPermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.notification,
    ].request();
    if (await Permission.notification.isGranted) {
      print("通知权限申请通过");
      return true;
    } else {
      print("通知权限申请失败");
    }
    return false;
  }

}