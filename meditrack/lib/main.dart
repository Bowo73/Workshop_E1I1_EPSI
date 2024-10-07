import 'package:flutter/material.dart';
import 'package:meditrack/modules/home/view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediTrack', // Titre de l'application
      theme: ThemeData(
        scaffoldBackgroundColor:
            const Color.fromRGBO(248, 248, 248, 1), // Couleur de fond
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
        // Personnalisation des TextFields
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors
                    .blue), // Couleur de la ligne lorsque le TextField est activés
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors.blue,
                width:
                    2.0), // Couleur de la ligne lorsque le TextField est focalisé
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Rendre l'AppBar transparente
          elevation: 0, // Enlever l'ombre
        ),
      ),
      home: const HomeView(),
    );
  }
}
