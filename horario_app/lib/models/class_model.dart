import 'dart:convert';
import 'package:flutter/material.dart';

class SchoolClass {
  final String name;
  final String teacher;
  final String room;
  final String day;
  final int startHour;
  final int endHour;
  final int colorValue;

  SchoolClass({
    required this.name,
    required this.teacher,
    required this.room,
    required this.day,
    required this.startHour,
    required this.endHour,
    required this.colorValue,
  });

  Color get color => Color(colorValue);

  bool isNowActive() {
    final now = DateTime.now();
    return now.hour >= startHour && now.hour < endHour;
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'teacher': teacher,
        'room': room,
        'day': day,
        'startHour': startHour,
        'endHour': endHour,
        'colorValue': colorValue,
      };

  factory SchoolClass.fromMap(Map<String, dynamic> map) => SchoolClass(
        name: map['name'],
        teacher: map['teacher'],
        room: map['room'],
        day: map['day'],
        startHour: map['startHour'],
        endHour: map['endHour'],
        colorValue: map['colorValue'],
      );

  static String encode(List<SchoolClass> classes) =>
      json.encode(classes.map((e) => e.toMap()).toList());

  static List<SchoolClass> decode(String classes) =>
      (json.decode(classes) as List<dynamic>)
          .map((e) => SchoolClass.fromMap(e))
          .toList();
}