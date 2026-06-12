import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'access_token');
  }

  //Verificar em caso de erro
  static Future<void> saveConfig(Map map) async {
    await _storage.write(key: 'configuration', value: map.toString());
  }

  //Verificar em caso de erro
  static Future<String?> getConfig() async {
    return await _storage.read(key: 'configuration');
  }
}