import 'package:shared_preferences/shared_preferences.dart';
import '../models/class_model.dart';

class StorageService {
  static const _key = "classes";

  static Future<void> saveClasses(List<SchoolClass> classes) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, SchoolClass.encode(classes));
  }

  static Future<List<SchoolClass>> loadClasses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return [];
    return SchoolClass.decode(data);
  }
}