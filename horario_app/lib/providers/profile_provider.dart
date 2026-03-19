import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';

class ProfileNotifier extends StateNotifier<Profile> {
  ProfileNotifier()
      : super(Profile(
          name: "Tonny HC",
          career: "Ingeniería",
          semester: "1",
        )) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('profile');

    if (data != null) {
      state = Profile.fromMap(json.decode(data));
    }
  }

  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile', json.encode(state.toMap()));
  }

  void updateProfile(Profile newProfile) {
    state = newProfile;
    saveProfile();
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, Profile>(
        (ref) => ProfileNotifier());