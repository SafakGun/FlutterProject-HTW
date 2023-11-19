import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'Classify_image.dart';
import 'Previous_posts.dart';
import 'Login_screen.dart';

class MainPage extends StatelessWidget {
  // name of the logged user from google
  final username = FirebaseAuth.instance.currentUser?.displayName;
  // email of the logged user from regular login (via email and password)
  final String? email;

  MainPage({super.key, this.email});

  // The buttons of the main page
  // Each button navigates to a different screen and has a different function
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print(email);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to LeafBehind!',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 89, 137, 90),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                // if the user logged in via google, show the username of the user
                // else if the user logged in via email and password, take the username from the email by splitting the email at the @ sign
                email != null ? email!.split('@')[0] : username!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 59, 59, 59),
                ),
              ),
              const SizedBox(height: 20),
              Image.asset('assets/appstore.png', height: 250, width: 250),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                style:ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
      const Size(250, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF4CAF50)), // Set the desired background color
                ),
                // Get image from gallery
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final PickedFile? image =
                      await _picker.getImage(source: ImageSource.gallery);
                  if (image != null) {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ClassifyImage(imagePath: image.path),
                      ),
                    );
                  }
                },           
              label: const Text('Upload Image From Gallery'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                style:ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
      const Size(250, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF4CAF50)),
                ),
                // Get image from camera
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final PickedFile? image =
                      await _picker.getImage(source: ImageSource.camera);
                  if (image != null) {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ClassifyImage(imagePath: image.path),
                      ),
                    );
                  }
                },
                label: const Text('Take a Picture'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.view_agenda),
                style:ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
      const Size(250, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF4CAF50)),
                ),
                // View previous posts
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PreviousPosts(),
                    ),
                  );
                },
                label: const Text('View My Previous Posts'),
              ),
              const SizedBox(height: 20),
            
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                style:ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
      const Size(250, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF4CAF50)),
                  // add icon to the button
                ),
                // Sign out from the app
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                label: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
