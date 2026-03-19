import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/schedule_provider.dart';
import '../models/class_model.dart';
import 'dart:math';

class AddClassScreen extends ConsumerStatefulWidget {
  final SchoolClass? existingClass;

  const AddClassScreen({super.key, this.existingClass});

  @override
  ConsumerState<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends ConsumerState<AddClassScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _teacherController = TextEditingController();
  final _roomController = TextEditingController();

  String selectedDay = "Lunes";
  int startHour = 7;
  int endHour = 8;
  int selectedColorValue = Colors.blue.value;

  final days = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes"];

  @override
  void initState() {
    super.initState();

    if (widget.existingClass != null) {
      final c = widget.existingClass!;
      _nameController.text = c.name;
      _teacherController.text = c.teacher;
      _roomController.text = c.room;
      selectedDay = c.day;
      startHour = c.startHour;
      endHour = c.endHour;
      selectedColorValue = c.colorValue;
    } else {
      selectedColorValue = Colors.primaries[
              Random().nextInt(Colors.primaries.length)]
          .value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingClass != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Editar Materia" : "Agregar Materia"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Campo obligatorio" : null,
              ),
              TextFormField(
                controller: _teacherController,
                decoration: const InputDecoration(labelText: "Maestro"),
              ),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(labelText: "Salón"),
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                initialValue: selectedDay,
                decoration: const InputDecoration(labelText: "Día"),
                onChanged: (v) => setState(() => selectedDay = v!),
                items: days
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<int>(
                initialValue: startHour,
                decoration: const InputDecoration(labelText: "Hora inicio"),
                onChanged: (v) => setState(() => startHour = v!),
                items: List.generate(18, (i) => 6 + i)
                    .map((h) => DropdownMenuItem(
                          value: h,
                          child: Text("$h:00"),
                        ))
                    .toList(),
              ),

              DropdownButtonFormField<int>(
                initialValue: endHour,
                decoration: const InputDecoration(labelText: "Hora fin"),
                onChanged: (v) => setState(() => endHour = v!),
                items: List.generate(18, (i) => 6 + i)
                    .map((h) => DropdownMenuItem(
                          value: h,
                          child: Text("$h:00"),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  final newClass = SchoolClass(
                    name: _nameController.text,
                    teacher: _teacherController.text,
                    room: _roomController.text,
                    day: selectedDay,
                    startHour: startHour,
                    endHour: endHour,
                    colorValue: selectedColorValue,
                  );

                  if (isEditing) {
                    ref.read(scheduleProvider.notifier).updateClass(
                        widget.existingClass!, newClass);
                  } else {
                    ref.read(scheduleProvider.notifier).addClass(newClass);
                  }

                  Navigator.pop(context);
                },
                child: Text(isEditing ? "Actualizar" : "Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}