// ignore_for_file: unused_field

import 'package:com610/home_page.dart';
import 'package:com610/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _user = FirebaseAuth.instance.currentUser;

  final auth = FirebaseAuth.instance;

  Future<void> _CerrarSesion(BuildContext context) async {
    await auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            // Text('Bienvenido ${_user}'),
            if (_user != null)
            Text('Bienvenido ${_user.displayName != null ? _user.displayName : 'Anónimo'}'),
            Text('Correo: ${_user?.email}'),
            Image.network(
              '${_user?.photoURL != null ? _user!.photoURL : 'https://logowik.com/content/uploads/images/flutter5786.jpg'}',
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                _CerrarSesion(context);
                print('Cerrar sesión');
              },
              child: const Text(
                "Cerrar sesión",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            MenuBar(
              style: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
              ),
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: const Text(
                    "HOME",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PerfilPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "PERFIL",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
