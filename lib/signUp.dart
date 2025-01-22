/*import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializace databázového factory pro web nebo mobil
  if (kIsWeb) {
    DatabaseHelper.factory = databaseFactoryFfiWeb;
    print('Web database factory initialized');
  } else {
    sqfliteFfiInit();
    DatabaseHelper.factory = databaseFactoryFfi;
    print('Mobile/desktop database factory initialized');
  }

  // Otevření databáze PŘED spuštěním aplikace
  try {
    print('Opening database...');
    await DatabaseHelper.instance.openMyDatabase();
    print('Database initialized successfully');
  } catch (e) {
    print('Error initializing database: $e');
    rethrow;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Registrovat(),
    );
  }
}

class Registrovat extends StatefulWidget {
  @override
  _RegistrovatState createState() => _RegistrovatState();
}

class _RegistrovatState extends State<Registrovat> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _registerUser(BuildContext context) async {
    try {
      // Ujistíme se, že je databáze inicializována
      await openDatabase(join(await getDatabasesPath(), "databaze_maturitni_prace.db"));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Database not initialized: $e')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text;

      try {
        int result = await DatabaseHelper.instance.addUser(username, email, password);
        if (result > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User registered successfully')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registration")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: "Username"),
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _registerUser(context),
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DatabaseHelper {
  static DatabaseFactory? _factory;

  static set factory(DatabaseFactory databaseFactory) {
    _factory = databaseFactory;
  }

  static DatabaseFactory get factory {
    if (_factory == null) {
      throw Exception(
        'DatabaseHelper.factory has not been initialized. '
            'Ensure it is initialized in main() before accessing the database.',
      );
    }
    return _factory!;
  }

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<void> openMyDatabase() async {
    if (_database != null) {
      print('Database is already initialized');
      return;
    }

    try {
      print('Initializing database...');
      _database = await _initDatabase();
      print('Database initialized successfully');
    } catch (e) {
      print('Error in openMyDatabase: ${e.toString()}');
      throw Exception('Failed to initialize the database: ${e.toString()}');
    }
  }

  Future<Database> get database async {
    if (_database == null) {
      throw Exception('Database has not been initialized. Call openMyDatabase() first.');
    }
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (_factory == null) {
      print('Database factory is not initialized');
      throw Exception(
        'DatabaseHelper.factory has not been initialized. '
            'Ensure it is initialized in main() before accessing the database.',
      );
    }
    
    String path = join(await getDatabasesPath(), "databaze_maturitni_prace.db");
    print('Database path: $path');

    try {
      return await _factory!.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _onCreate,
        ),
      );
    } catch (e) {
      print('Error in _initDatabase: ${e.toString()}');
      throw Exception('Failed to open database: ${e.toString()}');
    }
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS Uzivatel (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      Jmeno TEXT NOT NULL,
      Email TEXT NOT NULL UNIQUE,
      Heslo TEXT NOT NULL
    )''');
    print("Table Uzivatel created successfully");
  }

  Future<int> addUser(String username, String email, String password) async {
    Database db = await instance.database;
    return await db.insert(
      "Uzivatel",
      {
        'Jmeno': username,
        'Email': email,
        'Heslo': password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // PRO ERRORY
  String? _errorMessage;
  Future<void> registerUser() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match.";
      });
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // SPRAVNA REGISTRACE
      print("User registered: ${userCredential.user?.email}");
      setState(() {
        _errorMessage = null; // VYCISTI ERROR
      });
      // PO SPRAVNE REGISTRACI DEJ UZIVATELE DO MENU
      //Navigator.pushReplacementNamed(context, '/karticky');  // NEVIM CO POUZIVAS, MUSIS ZMENIT!!!
    } catch (e) {
      // ERROR (napr.: slabe heslo, spatny email, email alr in use)
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'email',
                errorText: _errorMessage?.contains('email') == true ? _errorMessage : null,
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'heslo',
                errorText: _errorMessage?.contains('password') == true ? _errorMessage : null,
              ),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'heslo 2',
                errorText: _errorMessage?.contains('password') == true ? _errorMessage : null,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerUser,
              child: Text('Registrovat'),
            ),
            if (_errorMessage != null) ...[
              SizedBox(height: 20),
              Text(
                _errorMessage ?? '',
                style: TextStyle(color: Colors.red),
              ),
            ]
          ],
        ),
      ),
    );
  }
}