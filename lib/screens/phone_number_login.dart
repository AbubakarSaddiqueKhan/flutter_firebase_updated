import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_youtube/screens/home_page_design.dart';

class PhoneNumberLoginPage extends StatefulWidget {
  const PhoneNumberLoginPage({super.key});

  @override
  State<PhoneNumberLoginPage> createState() => _PhoneNumberLoginPageState();
}

class _PhoneNumberLoginPageState extends State<PhoneNumberLoginPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late TextEditingController phoneNumberTextEditingController;
  late TextEditingController passwordTextEditingController;
  String sms_code = '';
  @override
  void initState() {
    super.initState();
    phoneNumberTextEditingController = TextEditingController();
    passwordTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    phoneNumberTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login with Mobile Number"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: phoneNumberTextEditingController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "+92 3029863667",
                  hintStyle: TextStyle(color: Colors.pink)),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    await firebaseAuth.verifyPhoneNumber(
                      phoneNumber: phoneNumberTextEditingController.text,
                      verificationCompleted:
                          (PhoneAuthCredential credential) async {
                        await firebaseAuth.signInWithCredential(credential);
                      },
                      verificationFailed: (FirebaseException e) {
                        if (e.code == 'invalid-phone-number') {
                          print('The provided phone number is not valid.');
                        } else {
                          print(e);
                        }
                      },
                      codeSent: (verificationId, forceResendingToken) async {
                        sms_code = verificationId;
                      },
                      codeAutoRetrievalTimeout: (verificationId) {},
                      timeout: Duration(seconds: 60),
                    );
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(
                  "Send OTP",
                  style: TextStyle(color: Colors.deepOrange, fontSize: 20),
                )),
            SizedBox(
              height: 50,
            ),
            TextField(
              controller: passwordTextEditingController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "XXXX",
                  hintStyle: TextStyle(color: Colors.pink)),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () async {
                  PhoneAuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(
                          smsCode: passwordTextEditingController.text,
                          verificationId: sms_code);
                  await firebaseAuth
                      .signInWithCredential(phoneAuthCredential)
                      .then((value) {
                    if (value.user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("User Added Succesfully")));

                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return HomePageDesign();
                        },
                      ));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("error")));
                    }
                  });
                },
                child: Text("Submit"))
          ],
        ),
      ),
    );
  }
}
