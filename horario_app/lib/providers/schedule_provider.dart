import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/class_model.dart';
import '../services/notification_service.dart';

class ScheduleNotifier extends StateNotifier<List<SchoolClass>> {
  ScheduleNotifier() : super([]) {
    loadClasses();
  }

  Future<void> loadClasses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('classes');

    if (data != null) {
      state = SchoolClass.decode(data);

      // Reprogramar notificaciones al iniciar app
      for (final c in state) {
        await NotificationService.scheduleClassNotification(c);
      }
    }
  }

  Future<void> saveClasses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('classes', SchoolClass.encode(state));
  }

  Future<void> addClass(SchoolClass newClass) async {
    state = [...state, newClass];
    await saveClasses();
    await NotificationService.scheduleClassNotification(newClass);
  }

  Future<void> updateClass(
      SchoolClass oldClass, SchoolClass newClass) async {
    await NotificationService.cancelNotification(oldClass);

    state =
        state.map((c) => c == oldClass ? newClass : c).toList();

    await saveClasses();
    await NotificationService.scheduleClassNotification(newClass);
  }

  Future<void> deleteClass(SchoolClass classToDelete) async {
    await NotificationService.cancelNotification(classToDelete);

    state =
        state.where((c) => c != classToDelete).toList();

    await saveClasses();
  }
}

final scheduleProvider =
    StateNotifierProvider<ScheduleNotifier, List<SchoolClass>>(
        (ref) => ScheduleNotifier());