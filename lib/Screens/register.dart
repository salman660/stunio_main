import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:login_page/Screens/login.dart';
import 'package:motion_toast/motion_toast.dart';

import '../Components/rounded_container.dart';
import '../Components/rounded_input.dart';
import '../constant.dart';
import 'ForgetPassword.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final email = TextEditingController();
  final password = TextEditingController();
  Future createUserEmailAndPassword() async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email.text, password: password.text);
    print('Created object successfully');
    MotionToast.success(
      title: Text("Success"),
      description: Text("Account Created Successfully"),
    ).show(context);
    Navigator.push(context, MaterialPageRoute(builder: ((context) => LoginPage())));
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      MotionToast.error(
        title: Text("Error"),
        description: Text("The password provided is too weak."),
      ).show(context);
    } else if (e.code == 'email-already-in-use') {
      MotionToast.error(
        title: Text("Error"),
        barrierColor: Colors.white,
        description: Text("The account already exists for that email."),
      ).show(context);
    }
  } catch (e) {
    print(e);
    MotionToast.error(
      title: Text("Error"),
      description: Text("An unexpected error occurred."),
      barrierColor: Colors.white,
    ).show(context);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'Welcome',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(height: 40),
              SvgPicture.asset('asset/image/register.svg'),
              SizedBox(height: 30),
              RoundedInput(
                  icon: Icons.email,
                  hint: 'Enter Email',
                  controller: email,
                  obscuretext: false),
              SizedBox(
                height: 10,
              ),
              RoundedInput(
                icon: Icons.password,
                hint: 'Password',
                controller: password,
                obscuretext: true,
              ),
              SizedBox(
                height: 10,
              ),
              RoundedButton(title: 'SignUp', onTap: createUserEmailAndPassword),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text(
                  "Already have an account? Login",
                  style: TextStyle(color: kPrimaryColor, fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
