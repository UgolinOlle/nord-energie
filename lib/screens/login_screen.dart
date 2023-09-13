import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/screens/admin_screen.dart';
import 'package:mobile/services/intervention_service.dart';
import 'package:mobile/utils/functions.dart';
import 'package:provider/provider.dart';

import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storage = FlutterSecureStorage();
  final AuthService _authService = AuthService();
  final InterventionService _interventionService = InterventionService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  String? _errorInternet;

  Future<void> _autoLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final jwtToken = await storage.read(key: 'accessToken');

    if (jwtToken != null) {
      final decodedJwt = await _authService.loginWithToken(jwtToken);
      log('$decodedJwt');
    }
  }

  Future<void> _login(BuildContext context) async {
    // Reset all error message
    _errorInternet = '';
    _errorMessage = '';

    // Check if device is connected
    final bool isConnected = await Functions.checkInternetConnectivity();
    if (!isConnected) {
      setState(() {
        _errorInternet = 'Veuillez vous connecter à internet pour continuer.';
      });
      return;
    }

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dynamic loggedIn = await _authService.login(email, password);

    if (loggedIn != null) {
      if (loggedIn['accessToken'] != null) {
        final user = UserModel.fromJson(loggedIn['user']);
        final interventions =
            await _interventionService.getInterventionsByUserId(user.id!);
        user.interventions.addAll(interventions);
        authProvider.setUser(user);

        if (user.role == 'Employé') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (user.role == 'Admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminScreen()),
          );
        }
      }
    } else {
      setState(() {
        _errorMessage = 'Mot de passe ou Adresse mail invalide.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color(0xFFff6b35),
          Color(0xFFf7c59f),
          Color(0xFFefefd0)
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 80,
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Connection",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Bon retour",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 60,
                        ),
                        Column(
                          children: <Widget>[
                            if (_errorInternet != null) Text('$_errorInternet', style: const TextStyle(fontSize: 25, color: Colors.red,),),
                            if (_errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(225, 95, 27, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10),
                                    )
                                  ]),
                              child: TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (_errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color.fromRGBO(225, 95, 27, .3),
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ]),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    hintText: "Mot de passe",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () => _login(context),
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xFFff6b35),
                            ),
                            child: const Center(
                              child: Text(
                                "Connection",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
