import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; 
import 'utils/constants.dart';   
import 'package:project_crypto/utils/notification_helper.dart';   

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await NotificationHelper.initialize();     
  runApp(CryptoTrackerApp());
}

class CryptoTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoTracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kScaffoldBackgroundColor,
      
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
