import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ScheduleView { calendar, list }

class ViewNotifier extends StateNotifier<ScheduleView> {
  ViewNotifier() : super(ScheduleView.calendar) {
    loadView();
  }

  Future<void> loadView() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('view');

    if (saved != null) {
      state = ScheduleView.values
          .firstWhere((e) => e.toString() == saved);
    }
  }

  Future<void> toggle() async {
    state = state == ScheduleView.calendar
        ? ScheduleView.list
        : ScheduleView.calendar;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('view', state.toString());
  }
}

final viewProvider =
    StateNotifierProvider<ViewNotifier, ScheduleView>(
        (ref) => ViewNotifier());