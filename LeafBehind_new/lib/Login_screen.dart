import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'AuthService.dart';
import 'Main_Page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Taking the email and password from the user  
  TextEditingController emailController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController passwordController = TextEditingController();

  // Login function for email and password
  void handleLogin() async {
    var userdata = await AuthService().signInWithGoogle();
    if (userdata != null && mounted) {
      final username = FirebaseAuth.instance.currentUser?.displayName;
      // ignore: avoid_print
      print(username);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(),
        ),
      );
    }
  }

  // The text fields for the email and password
  Widget buildTextField(TextEditingController controller, String labelText) {
    // if the label is password, hide the text
    if (labelText == 'Password') {
      return TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[350],
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[350],
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // The screen of the login page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LeafBehind',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,           
            children: [
              Image.asset('assets/appstore.png', height: 200, width: 200),             
              const SizedBox(height: 50),
              buildTextField(emailController, 'Email'),
              const SizedBox(height: 10),
              buildTextField(passwordController, 'Password'),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                // to login with email and password
                onPressed: () {
                  String email = emailController.text;
                  String password = passwordController.text;
                  // ignore: avoid_print
                  print('Email: $email');
                  // ignore: avoid_print
                  print('Password: $password');
                  login(email, password, context);                
                },
                style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                ),
                label: const Text('Login'),
              ),
              const SizedBox(height: 5),
              ElevatedButton.icon(
                icon: const Icon(Icons.email),
                // to register with email and password
                onPressed: () {
                  String email = emailController.text;
                  String password = passwordController.text;
                  register(email, password, context);
                  // ignore: avoid_print
                  print('Register button pressed');
                },
                style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50), // Set the desired background color
                ),
                label: const Text('Register with Email'),
              ),
              const SizedBox(height: 5),
              //If you don't have an account, please sign up with a button
              ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF4CAF50),                       
                      ),
                      icon: Image.asset('assets/google.png', height: 25),
                      // to login with google
                      onPressed: () {
                        handleLogin();
                      },
                      label: const Text('Continue with Google'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

//login fucntion with email and password
Future<void> login(String email, String password, BuildContext context) async {
  // catch the error if there is no such a user with these username and password or unsupported format is used
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage(email:email)));
  } on FirebaseAuthException catch (e) {
    // ignore: avoid_print
    print('Failed with error code: ${e.code}');
    // ignore: avoid_print
    print(e.message);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('There is not such a user with these username and password or unsupported format is used.'),
        backgroundColor: Colors.red,
      ),
    );
  } 
}

//register function with email and password
Future<void> register(String email, String password, BuildContext context) async {
  // true if the user has already registered
  bool isRegistered = true;

  // catch the error if there is already a user with this email
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password);
  } on FirebaseAuthException catch (e) {
    isRegistered = false;
    // ignore: avoid_print
    print('Failed with error code: ${e.code}');
    // ignore: avoid_print
    print(e.message);    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('There is already a user with this email or unsupported is used!'),
        backgroundColor: Colors.red,
      ),
    );
  }
  // else, show a snackbar that the user is registered successfully
  if (isRegistered) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You are registered successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

}