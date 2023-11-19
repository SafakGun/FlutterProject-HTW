import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:leafbehind/Previous_posts.dart';
import 'package:leafbehind/Main_Page.dart';
import 'firebase_options.dart';
import 'Login_screen.dart';
import 'Classify_image.dart';
void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

// This is the root widget of my application
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // Define the theme of the app
  // The theme is used by all the widgets in the app
  final ThemeData appTheme = ThemeData(
    primaryColor: Colors.lightGreen,
    scaffoldBackgroundColor: Colors.lightGreen,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF4CAF50),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
      ),
    ),
  );

  // It defines the routes of the app
  // The routes are used to navigate between the screens
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/LoginScreen', // The first screen to be displayed
      routes: {
        // All the things related to login such as email, password, etc.
        // and the login screen itself are in LoginScreen
        '/LoginScreen': (context) => const LoginScreen(), 
        // All the things related to previous posts such as the posts themselves
        // and the previous posts screen itself are in PreviousPosts
        // Also, getting the data from the firebase is in PreviousPosts
        '/PreviousPosts': (context) => const PreviousPosts(), 
        // All the things related to the main page such as the buttons,
        // the functions of the buttons and the main page itself are in MainPage
        '/MainPage': (context) => MainPage(),
        // All the things related to classifying the image such as classifying the image itself
        // and the classify image screen itself are in ClassifyImage
        // Also, sending the data to firebase is in ClassifyImage
        '/ClassifyImage': (context) {
          // Retrieve the string parameter from MainPage
          final String imagePath = ModalRoute.of(context)?.settings.arguments as String;
          
          // Pass the string parameter to ClassifyImage
          return ClassifyImage(imagePath: imagePath);
        }        
      },
    );
  }
}



