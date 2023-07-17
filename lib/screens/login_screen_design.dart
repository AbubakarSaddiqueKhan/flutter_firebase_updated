import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_youtube/screens/home_page_design.dart';
import 'package:flutter_firebase_youtube/services/auth_service.dart';

class LoginScreenDesign extends StatefulWidget {
  const LoginScreenDesign({super.key});

  @override
  State<LoginScreenDesign> createState() => _LoginScreenDesignState();
}

class _LoginScreenDesignState extends State<LoginScreenDesign> {
  late TextEditingController _emailTextEditingController;
  late TextEditingController _passwordTextEditingController;

  @override
  void initState() {
    super.initState();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();

    super.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;
    var clientHeight = screenHeight - kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
        centerTitle: true,
      ),
      body: Center(
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
                            content: Text("All Flields are requiered")));
                      } else {
                        User? userResult = await AuthService().loginUser(
                            _emailTextEditingController.text,
                            _passwordTextEditingController.text,
                            context);
                        if (userResult != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Login Successfully")));
                          print("Email : ${_emailTextEditingController.text}");

                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return HomePageDesign();
                            },
                          ));
                        }
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: const Text("Login")),
          ],
        ),
      ),
    );
  }
}
