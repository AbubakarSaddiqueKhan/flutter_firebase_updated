import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_youtube/screens/home_page_design.dart';
import 'package:flutter_firebase_youtube/screens/login_screen_design.dart';
import 'package:flutter_firebase_youtube/screens/phone_number_login.dart';
import 'package:flutter_firebase_youtube/services/auth_service.dart';

class RegisterScreenDesign extends StatefulWidget {
  const RegisterScreenDesign({super.key});

  @override
  State<RegisterScreenDesign> createState() => _RegisterScreenDesignState();
}

class _RegisterScreenDesignState extends State<RegisterScreenDesign> {
  late TextEditingController _emailTextEditingController;
  late TextEditingController _passwordTextEditingController;
  late TextEditingController _confirmPasswordTextEditingController;

  @override
  void initState() {
    super.initState();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
    _confirmPasswordTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _confirmPasswordTextEditingController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  bool isGoogleLoading = false;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;
    var clientHeight = screenHeight - kToolbarHeight;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: clientHeight * 0.02,
          ),
          TextFormField(
            controller: _emailTextEditingController,
            decoration: InputDecoration(
                label: Text("Email"), border: OutlineInputBorder()),
          ),
          SizedBox(
            height: clientHeight * 0.02,
          ),
          TextFormField(
            obscureText: true,
            controller: _passwordTextEditingController,
            decoration: InputDecoration(
                label: Text("Password"), border: OutlineInputBorder()),
          ),
          SizedBox(
            height: clientHeight * 0.02,
          ),
          TextFormField(
            obscureText: true,
            controller: _confirmPasswordTextEditingController,
            decoration: InputDecoration(
                label: Text("Comfirm Password"), border: OutlineInputBorder()),
          ),
          SizedBox(
            height: clientHeight * 0.02,
          ),
          //  if the user clicks on the button then it will change to the  circular progress bar
          isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (_emailTextEditingController.text == "" ||
                        _passwordTextEditingController.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("All field's  are requiered",
                            style: TextStyle(color: Colors.red)),
                        backgroundColor: Colors.transparent,
                      ));
                    } else if (_passwordTextEditingController.text !=
                        _confirmPasswordTextEditingController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Password don't matched",
                            style: TextStyle(color: Colors.red)),
                        backgroundColor: Colors.transparent,
                      ));
                    } else {
                      User? userResult = await AuthService().registerUser(
                          _emailTextEditingController.text,
                          _confirmPasswordTextEditingController.text,
                          context);

                      if (userResult != null) {
                        print("Added Succfully ");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("User Added Succesfully",
                              style: TextStyle(color: Colors.red)),
                          backgroundColor: Colors.transparent,
                        ));

                        print("User added email is : ${userResult.email}");

                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return HomePageDesign();
                          },
                        ));
                      } else {}
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: const Text("Register")),
          SizedBox(
            height: clientHeight * 0.02,
          ),
          TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return LoginScreenDesign();
                  },
                ));
              },
              child: Text("Do you already have an account ??")),
          SizedBox(
            height: clientHeight * 0.02,
          ),
          isGoogleLoading
              ? CircularProgressIndicator()
              : InkWell(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/google_logo.png"),
                            fit: BoxFit.fill)),
                  ),
                  onTap: () async {
                    setState(() {
                      isGoogleLoading = true;
                    });
                    await AuthService().signInWithGoogle();
                    setState(() {
                      isGoogleLoading = false;
                    });
                  },
                ),

          SizedBox(
            height: 50,
          ),

          ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return PhoneNumberLoginPage();
                  },
                ));
              },
              child: Text(
                "Login with mobile Number",
                style: TextStyle(color: Colors.red, fontSize: 20),
              ))
        ],
      ),
    );
  }
}
