class Profile {
  final String name;
  final String career;
  final String semester;

  Profile({
    required this.name,
    required this.career,
    required this.semester,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'career': career,
        'semester': semester,
      };

  factory Profile.fromMap(Map<String, dynamic> map) => Profile(
        name: map['name'] ?? '',
        career: map['career'] ?? '',
        semester: map['semester'] ?? '',
      );
}