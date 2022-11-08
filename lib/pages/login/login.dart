import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybook/pages/home/home.dart';
import 'package:mybook/pages/provider/username.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static String routesName = '/login';
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with ChangeNotifier {
  final _loginKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();

  Future login() async {
    var url = "http://10.0.2.2:3400/getusers";

    try {
      var response = await http.post(Uri.parse(url),
          body: jsonEncode({"email": username.text, "password": password.text}),
          headers: {"content-type": "application/json"});

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(
          context,
          Home.routesName,
          arguments: {'username': username.text},
        );
        notifyListeners();
      } else {
        return Future.error("Server error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Center(
          child: loginForm(),
        ),
      ),
    );
  }

  loginForm() {
    return Form(
      key: _loginKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          inputUsername(),
          const SizedBox(
            height: 20,
          ),
          inputPassword(),
          const SizedBox(
            height: 20,
          ),
          submitButton(),
        ],
      ),
    );
  }

  SizedBox inputUsername() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      child: TextFormField(
        controller: username,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),
          filled: true,
          fillColor: const Color(0XFFF4F7F8),
          hintText: "Username",
          prefixIcon: const Icon(
            IconData(
              0xf018,
              fontFamily: "MaterialIcons",
            ),
            color: Color(0xFF808080),
          ),
          hintStyle: GoogleFonts.montserrat(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  SizedBox inputPassword() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      child: TextFormField(
        controller: password,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),
          filled: true,
          fillColor: const Color(0XFFF4F7F8),
          hintText: "Password",
          prefixIcon: const Icon(
            IconData(
              0xf4aa,
              fontFamily: "MaterialIcons",
            ),
            color: Color(0xFF808080),
          ),
          hintStyle: GoogleFonts.montserrat(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  ElevatedButton submitButton() {
    return ElevatedButton(
      onPressed: () {
        login();
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0XFF432C7A),
          fixedSize: const Size(80, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              15,
            ),
          )),
      child: Text(
        "Login",
        style: GoogleFonts.montserrat(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
