import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import '../models/profile_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends ConsumerState<ProfileScreen> {
  final nameController = TextEditingController();
  final careerController = TextEditingController();
  final semesterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    nameController.text = profile.name;
    careerController.text = profile.career;
    semesterController.text = profile.semester;

    return Scaffold(
      appBar: AppBar(title: const Text("Editar Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController),
            TextField(controller: careerController),
            TextField(controller: semesterController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(profileProvider.notifier).updateProfile(
  Profile(
    name: nameController.text,
    career: careerController.text,
    semester: semesterController.text,
  ),
);
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            )
          ],
        ),
      ),
    );
  }
}