import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'Screens/login.dart';
import 'Screens/register.dart';
import 'Components/rounded_container.dart';
import 'Components/rounded_input.dart';
import 'constant.dart';
import 'themes.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      systemNavigationBarColor: Colors.transparent, // Transparent navigation bar
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark, // Adjust status bar icon brightness
      systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark, // Adjust navigation bar icon brightness
    ));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme, // Use light theme
      darkTheme: darkTheme, // Use dark theme
      themeMode: ThemeMode.system, // Automatically switch based on system settings
      home: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              isDarkMode ? Colors.grey[900]! : Colors.grey[300]!,
              isDarkMode ? Colors.grey[900]! : Colors.white,
            ],
          ),
        ),
        child: MainOptionsPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const Spacer(),
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.topLeft,
              child: SvgPicture.asset(
                'asset/image/mainscreen_top_element.svg',
                height: 180, // Adjust height as needed
              ),
            ),
            const Spacer(),
            SizedBox(height: 50),
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UK’s first online Job portal',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' for Students by Students',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 50,
              width: 250,
              child: SignInButton(
              Buttons.google,
              text: "Continue with Google",
              onPressed: () async {
                User? user = await signInWithGoogle();
                if (user != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FirstPage()));
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              ),
            ),
            SizedBox(
              height: 50,
              width: 250,
              child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: ElevatedButton(
                onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                },
                style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: const Color(0xFFD7D7D7), // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                  side: const BorderSide(color: Color(0xFF898989)), // Stroke color
                ),
                ),
                child: Center(
                child: Text(
                  'Signin',
                  style: GoogleFonts.kanit(), // Kanit font
                ),
                ),
              ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp())); // Assuming RegisterPage exists
              },
              child: const Text('SignUp'),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }


  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class FirstPage extends StatefulWidget {
  FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        this.user = user;
      });
    });
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: user != null ? _userInfo() : _signInPrompt(),
    );
  }

  Widget _userInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(user!.photoURL ?? 'https://via.placeholder.com/100'),
              ),
            ),
          ),
          Text(user!.email ?? 'No Email'),
          Text(user!.displayName ?? 'No Name'),
          MaterialButton(
            color: Colors.red,
            child: const Text("Sign Out"),
            onPressed: signOut,
          ),
        ],
      ),
    );
  }


  Widget _signInPrompt() {
    return const Center(
      child: Text("Please sign in."),
    );
  }
}
