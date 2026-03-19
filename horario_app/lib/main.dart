import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/schedule_screen.dart';
import 'services/notification_service.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFDFDFD),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFF6B00),
          secondary: Color(0xFF0066FF),
          surfaceContainerHighest: Color(0xFFECECEC),
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF272727),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 156, 96, 0),
          secondary: Color.fromARGB(255, 108, 0, 175),
          surfaceContainerHighest: Color(0xFF222222),
        ),
      ),

      home: const ScheduleScreen(),
    );
  }
}