import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'services/ad_service.dart';
import 'services/purchase_service.dart';
import 'services/resume_storage_service.dart';
import 'services/resume_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService.initialize();

  final storageService = ResumeStorageService();
  final purchaseService = PurchaseService();
  await purchaseService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ResumeProvider(
            storageService: storageService,
            purchaseService: purchaseService,
          )..loadResumes(),
        ),
        Provider<PurchaseService>.value(value: purchaseService),
      ],
      child: const ResumeBuilderApp(),
    ),
  );
}

class ResumeBuilderApp extends StatelessWidget {
  const ResumeBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resume Builder for Freshers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
