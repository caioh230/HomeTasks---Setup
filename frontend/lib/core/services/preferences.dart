//Verificar em caso de erro
import 'dart:convert';
import 'package:hometasks/core/services/storage.dart';

class UserPreferences {
  static String tema = 'Sistema';
  static String idioma = 'Português (Brasil)';

  static Future<void> getPreferences() async {
    try {
      String? jsonRaw = await UserStorage.getConfig();

      if (jsonRaw != null && jsonRaw.isNotEmpty) {
        var dados = jsonDecode(jsonRaw);

        if (dados is List && dados.length >= 2) {
          tema = dados[0];
          idioma = dados[1];
        }
      } else {
        _definirPadrao();
      }
    } catch (_) {
      _definirPadrao();
    }
  }

  static Future<void> setPreferences(Map<String, dynamic> map) async {
    await UserStorage.saveConfig(map);
  }

  static void _definirPadrao() {
    tema = 'Sistema'; 
    idioma = 'Português (Brasil)';
  }
}
