import 'package:expensease/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/auth/auth_page.dart'; // ✅ use AuthPage instead of login/register directly
import 'splash/splash_screen.dart';
import 'screens/main_screen.dart';
import 'pages/add_bill_page.dart';
import 'pages/add_meal_page.dart';
import 'pages/reports_page.dart';
import 'pages/members_page.dart';
import 'pages/notifications_page.dart';
import 'pages/settings_page.dart';
import 'pages/meals_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await NotificationService.init();
  await Firebase.initializeApp();
  runApp(const ExpenseaseApp());
}

class ExpenseaseApp extends StatelessWidget {
  const ExpenseaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expensease',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/auth', page: () => const AuthPage()), // ✅ Use AuthPage
        GetPage(name: '/dashboard', page: () => const MainScreen()),
        GetPage(name: '/add-bill', page: () => const AddBillPage()),
        GetPage(name: '/add-meal', page: () => const AddMealPage()),
        GetPage(name: '/reports', page: () => const ReportsPage()),
        GetPage(name: '/members', page: () => const MembersPage()),
        GetPage(name: '/notifications', page: () => const NotificationsPage()),
        GetPage(name: '/settings', page: () => const SettingsPage()),
        GetPage(name: '/meals', page: () => const MealsPage()),
      ],
    );
  }
}
