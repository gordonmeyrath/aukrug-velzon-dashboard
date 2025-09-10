import 'dart:convert';
import 'dart:html' as html;

/// Web-kompatible Speicher-Service ohne Isar
class WebStorageService {
  static const String _reportsKey = 'aukrug_reports';
  
  /// Speichere Reports im Browser LocalStorage
  static Future<void> saveReports(List<Map<String, dynamic>> reports) async {
    final jsonString = jsonEncode(reports);
    html.window.localStorage[_reportsKey] = jsonString;
  }
  
  /// Lade Reports aus Browser LocalStorage
  static Future<List<Map<String, dynamic>>> loadReports() async {
    final jsonString = html.window.localStorage[_reportsKey];
    if (jsonString == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }
  
  /// Lösche alle gespeicherten Reports
  static Future<void> clearReports() async {
    html.window.localStorage.remove(_reportsKey);
  }
}
