import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/schedule_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/view_provider.dart';
import '../providers/profile_provider.dart';
import '../screens/add_class_screen.dart';
import '../screens/profile_screen.dart';
import '../models/class_model.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classes = ref.watch(scheduleProvider);
    final profile = ref.watch(profileProvider);
    final view = ref.watch(viewProvider);
    final isDark = ref.watch(themeProvider);

    final days = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes"];
    final hours = List.generate(18, (i) => 6 + i);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Horario"),
        actions: [
          IconButton(
            icon: Icon(
              view == ScheduleView.calendar
                  ? Icons.view_list
                  : Icons.calendar_month,
            ),
            onPressed: () {
              ref.read(viewProvider.notifier).toggle();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile.name,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                  Text(profile.career,
                      style: const TextStyle(color: Colors.white70)),
                  Text("Semestre ${profile.semester}",
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Editar Perfil"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
            SwitchListTile(
              title: const Text("Modo Oscuro"),
              value: isDark,
              onChanged: (value) {
                ref.read(themeProvider.notifier).toggle(value);
              },
            ),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: view == ScheduleView.calendar
            ? _calendar(context, ref, classes, days, hours)
            : _list(context, ref, classes, days),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddClassScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // ================= CALENDARIO =================

  Widget _calendar(BuildContext context, WidgetRef ref,
      List<SchoolClass> classes, List<String> days, List<int> hours) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 60),
            ...days.map(
              (d) => Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Theme.of(context).colorScheme.primary,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      d,
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        Expanded(
          child: ListView(
            children: hours.map((hour) {
              return Row(
                children: [
                  Container(
                    width: 60,
                    height: 70,
                    alignment: Alignment.center,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Text("$hour:00"),
                  ),
                  ...days.map((day) {
                    final block = classes.where((c) =>
                        c.day == day &&
                        hour >= c.startHour &&
                        hour < c.endHour);

                    if (block.isEmpty) {
                      return const Expanded(child: SizedBox(height: 70));
                    }

                    final c = block.first;
                    final isActive = c.isNowActive();

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _showDetails(context, ref, c),
                        child: Container(
                          height: 70,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: c.color,
                            borderRadius: BorderRadius.circular(16),
                            border: isActive
                                ? Border.all(
                                    color: const Color(0xFFFFFFFF), width: 1)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              isActive ? c.name : c.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList()
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ================= LISTA =================

  Widget _list(BuildContext context, WidgetRef ref,
      List<SchoolClass> classes, List<String> days) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: days.map((day) {
        final dayClasses =
            classes.where((c) => c.day == day).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(day,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (dayClasses.isEmpty)
              const Text("Hoy no tienes clases")
            else
              ...dayClasses.map((c) {
                final isActive = c.isNowActive();
                return Card(
                  color: c.color,
                  child: ListTile(
                    onTap: () => _showDetails(context, ref, c),
                    title: Text(
                      isActive ? c.name : c.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "${c.startHour}:00 - ${c.endHour}:00",
                      style:
                          const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              }),
            const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  // ================= DETALLES =================

  void _showDetails(
      BuildContext context, WidgetRef ref, SchoolClass c) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(c.name,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("👨‍🏫 ${c.teacher}"),
            Text("🏫 ${c.room}"),
            Text("⏰ ${c.startHour}:00 - ${c.endHour}:00"),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("Editar"),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddClassScreen(existingClass: c),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                    icon: const Icon(Icons.delete),
                    label: const Text("Eliminar"),
                    onPressed: () {
                      ref
                          .read(scheduleProvider.notifier)
                          .deleteClass(c);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}