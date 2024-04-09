import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Umbra\'s Labyrint',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Umbra\'s Labyrint'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistroScreen()),
            );
          },
          child: Text('Ver Mis Registros'),
        ),
      ),
    );
  }
}

class RegistroScreen extends StatefulWidget {
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  List<Registro> registros = [];

  @override
  void initState() {
    super.initState();
    _fetchRegistros();
  }

  Future<void> _fetchRegistros() async {
    final response =
        await http.get(Uri.parse('http://localhost:4000/getTimes'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        registros = data
            .cast<Map<String, dynamic>>()
            .map((json) => Registro.fromJson(json))
            .toList();
      });
    } else {
      // Manejo de errores
      throw Exception('Failed to load registros');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Registros'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: registros.length,
          itemBuilder: (context, index) {
            final registro = registros[index];
            return ListTile(
              title: Text(registro.time), // Muestra el tiempo del registro
            );
          },
        ),
      ),
    );
  }
}

class Registro {
  final String id;
  final String time;

  Registro(this.id, this.time);

  factory Registro.fromJson(Map<String, dynamic> json) {
    return Registro(json['_id'] as String, json['Time'] as String);
  }
}
