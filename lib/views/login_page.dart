import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pomotime/views/pomodoro_timer_screen.dart';
import 'package:pomotime/views/register_page.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background to white
      body: Stack(
        children: [
          // Gambar di background (index ke-0)
          Container(
            width: MediaQuery.of(context).size.width, // Full width
            height: MediaQuery.of(context).size.height * 0.4, // Full height
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image.png'), // Your image path
                fit: BoxFit.cover, // Cover entire screen
              ),
            ),
          ),
          // Konten di atas gambar (index ke-1)
          Column(
            children: [
              SizedBox(height: 10), // Adding space to the top
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo
                        Align(
                          alignment: Alignment.center, // Posisikan logo di tengah
                          child: Image.asset(
                            'assets/logo.png', // Path ke logo
                            height: 160, // Sesuaikan ukuran logo
                            width: 160,
                          ),
                        ),
                        SizedBox(height: 40),

                        // Welcome Text
                        Align(
                          alignment: Alignment(-0.3, 0.0), // Adjust alignment slightly to the right
                          child: Text(
                            'Welcome !',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400, // Make the text bold
                            ),
                          ),
                        ),
                        SizedBox(height: 40),

                        // Username Field
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Password Field
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: Icon(Icons.visibility),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text('Forgot password?',
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Sign in Button with Gradient
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF40A2F7),
                                Color(0xFF265F91)
                              ], // Use the new colors
                              begin: Alignment.topLeft, // Optional: adjust the gradient's direction
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              String email = emailController.text;
                              String password = passwordController.text;

                              // Validasi untuk memastikan email dan password tidak kosong
                              if (email.isEmpty || password.isEmpty) {
                                Get.snackbar(
                                  'Error',
                                  'Email dan Password tidak boleh kosong!',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              } else {
                                // Show loading dialog with blue color
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Blue color for loading
                                      ),
                                    );
                                  },
                                );

                                try {
                                  await _auth.signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );

                                  // Close the loading dialog
                                  Navigator.of(context).pop();

                                  // Navigate to PomodoroTimerScreen
                                  Get.to(PomodoroTimerScreen());

                                } catch (e) {
                                  // Close the loading dialog
                                  Navigator.of(context).pop();

                                  print('Error: $e');
                                  Get.snackbar('Login Failed', e.toString(),
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.transparent, // No color, we use gradient
                              shadowColor: Colors.transparent, // Remove shadow
                            ),
                            child: Text('Sign In',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
                        ),

                        // "Don't Have Account? Sign In" section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don`t Have Account?',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(RegisterScreen());
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(color: Color(0xFF3FA2F6)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // OR Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'OR',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Google Sign-In Button with Icon in Center using SizedBox
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7, // 70% of screen width
                          height: 48, // Height of the button
                          child: ElevatedButton(
                            onPressed: () async {
                              // Show loading dialog with blue color
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Blue color for loading
                                    ),
                                  );
                                },
                              );

                              try {
                                final GoogleSignInAccount? googleUser =
                                    await _googleSignIn.signIn();
                                if (googleUser == null) {
                                  // User cancelled the sign-in
                                  Navigator.of(context).pop();
                                  Get.snackbar(
                                      'Login Canceled', 'Login Google canceled',
                                      backgroundColor: Colors.orange,
                                      colorText: Colors.white);
                                  return;
                                }

                                final GoogleSignInAuthentication googleAuth =
                                    await googleUser.authentication;
                                final AuthCredential credential =
                                    GoogleAuthProvider.credential(
                                  accessToken: googleAuth.accessToken,
                                  idToken: googleAuth.idToken,
                                );

                                final UserCredential userCredential =
                                    await _auth.signInWithCredential(credential);

                                // Close the loading dialog
                                Navigator.of(context).pop();

                                if (userCredential.user != null) {
                                  Get.to(PomodoroTimerScreen());
                                }

                              } catch (e) {
                                // Close the loading dialog
                                Navigator.of(context).pop();

                                print('Error: $e');
                                Get.snackbar(
                                    'Google Login Failed', e.toString(),
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Image.asset(
                              'assets/google.png', // Path to the Google logo
                              height: 120, // Adjust icon size
                              width: 120,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
