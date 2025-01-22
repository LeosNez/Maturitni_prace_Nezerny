//import firebase
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math';

// FirebaseOptions pro konfiguraci Firebase pro webové aplikace
final FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyBWNRQjiAXuOe3E71bvcIs_lNTdwyiqhOo", // Klíč API pro autentizaci požadavků
    authDomain: "projektdb.firebaseapp.com", // Doména pro autentizaci
    messagingSenderId: "728406461367", // ID pro Firebase Cloud Messaging
    projectId: "projektdb", // ID projektu ve Firebase
    storageBucket: "projektdb.firebasestorage.app", // Úložiště Firebase
    appId: "1:728406461367:web:73d006f451e1c696927632", // ID aplikace
    measurementId: "G-XVNTMN11BT" // ID měření pro Google Analytics
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ujistí se, že widgety jsou připravené pro inicializaci
  await Firebase.initializeApp(options: firebaseOptions); // Inicializace Firebase pomocí dané konfigurace
  runApp(MaterialApp(
    title: "Card Hunt", // Titulek aplikace
    theme: ThemeData(primarySwatch: Colors.blue), // Nastavení barevného tématu
    home: FirstPage(), // Výchozí stránka aplikace
  ));
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Card Hunt",
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.blue[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Vítejte v Card Hunt!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllCardsPage()),
                    );
                  },
                  child: Text(
                    "Zobrazit všechny kartičky",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Hlavní úvodní stránka aplikace
class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Card Hunt"), // Titulek na AppBaru
        centerTitle: true, // Zarovnání textu do středu
        backgroundColor: Colors.blueAccent, // Barva pozadí AppBaru
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.blue[100]!], // Přechod mezi barvami
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Okraje obsahu
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Zarovnání ve středu
              crossAxisAlignment: CrossAxisAlignment.stretch, // Tlačítka na celou šířku
              children: [
                Text(
                  "Vítejte v Card Hunt!", // Úvodní text
                  textAlign: TextAlign.center, // Zarovnání textu na střed
                  style: TextStyle(fontSize: 24, color: Colors.blueAccent), // Styl textu
                ),
                SizedBox(height: 20), // Mezera mezi prvky
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16), // Vertikální padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Zaoblené rohy tlačítek
                    ),
                    backgroundColor: Colors.lightBlue, // Barva tlačítka
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()), // Navigace na registrační obrazovku
                    );
                  },
                  child: Text("Registrovat"), // Text na tlačítku
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.lightBlue,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogInScreen()), // Navigace na přihlašovací obrazovku
                    );
                  },
                  child: Text("Přihlásit"), // Text na tlačítku
                ),
                SizedBox(height: 100,),
                Image.asset(
                  'Assets/Logo.png',
                  width: 150,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image_not_supported, size: 50);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogInScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> logIn(BuildContext context) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print("User signed in: ${userCredential.user?.email}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenu()),
      );
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Chyba"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Zavřít"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade500,
              Colors.blue.shade100,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      "Přihlášení",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  SizedBox(height: 10),
                  FadeInUp(
                    duration: Duration(milliseconds: 1300),
                    child: Text(
                      "Vítejte zpět! Přihlaste se níže.",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 60),
                      FadeInUp(
                        duration: Duration(milliseconds: 1400),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 245, 255, 0.5),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: "Heslo",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      FadeInUp(
                        duration: Duration(milliseconds: 1600),
                        child: MaterialButton(
                          onPressed: () => logIn(context),
                          height: 50,
                          color: Colors.blue[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              "Přihlásit se",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      FadeInUp(
                        duration: Duration(milliseconds: 1800),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpScreen()),
                            );
                          },
                          child: Text(
                            "Nemáte účet? Zaregistrujte se.",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
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

class SignUpScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> registerUser(BuildContext context) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog(context, "Hesla se neshodují.");
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print("User registered: ${userCredential.user?.email}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenu()),
      );
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Chyba"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Zavřít"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade500,
              Colors.blue.shade100,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      "Registrace",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  SizedBox(height: 10),
                  FadeInUp(
                    duration: Duration(milliseconds: 1300),
                    child: Text(
                      "Vítejte! Zaregistrujte se níže.",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 60),
                      FadeInUp(
                        duration: Duration(milliseconds: 1400),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 245, 255, 0.5),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: "Heslo",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: "Potvrdit heslo",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      FadeInUp(
                        duration: Duration(milliseconds: 1600),
                        child: MaterialButton(
                          onPressed: () => registerUser(context),
                          height: 50,
                          color: Colors.blue[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              "Zaregistrovat se",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
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

class AllCardsPage extends StatefulWidget {
  @override
  _AllCardsPageState createState() => _AllCardsPageState();
}

class _AllCardsPageState extends State<AllCardsPage> {
  final List<Map<String, dynamic>> allCards = [
    {"name": "blue", "image": "kocicka.jpg", "attack": 6, "defense": 7, "health": 5000, "skills": 3},
    {"name": "matyz", "image": "Obrazek1.png", "attack": 20, "defense": 15, "health": 100, "skills": 3},
    {"name": "grisik", "image": "kocicka.jpg", "attack": -50, "defense": 15, "health": 100, "skills": 3},
    {"name": "kanye", "image": "Obrazek1.png", "attack": 20, "defense": 15, "health": 100, "skills": 3},
    {"name": "diddz", "image": "Astra.png", "attack": 20, "defense": 15, "health": 100, "skills": 3},
    {"name": "karel", "image": "Obrazek1.png", "attack": 20, "defense": 15, "health": 100, "skills": 3},
    {"name": "Henry", "image": "Astra.png", "attack": 20, "defense": 15, "health": 100, "skills": 3},
    {"name": "Kael", "image": "Obrazek1.png", "attack": 20, "defense": 15, "health": 100, "skills": 3},
    {"name": "martin", "image": "Astra.png", "attack": 20, "defense": 15, "health": 100, "skills": 3},
    {"name": "zahradnuk", "image": "Obrazek1.png", "attack": 20, "defense": 15, "health": 100, "skills": 3},
    {"name": "mys", "image": "Astra.png", "attack": 20, "defense": 15, "health": 100, "skills": 3},
    {"name": "152", "image": "Obrazek1.png", "attack": 20, "defense": 15, "health": 100, "skills": 3},
  ];

  List<Map<String, dynamic>> filteredCards = [];
  String searchQuery = "";
  String? _sortOrder; // může být null
  double _minValue = 10;
  double _maxValue = 50;

  @override
  void initState() {
    super.initState();
    filteredCards = allCards.map((card) {
      card["value"] = Random().nextInt(41) + 10;
      return card;
    }).toList();
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      if (searchQuery.isEmpty) {
        // Pokud není zadán vyhledávací dotaz, zobraz všechny kartičky
        filteredCards = allCards.where((card) {
          return card["value"] >= _minValue && card["value"] <= _maxValue;
        }).toList();
      } else {
        // Filtrování podle vyhledávacího dotazu (bez ohledu na velikost písmen)
        filteredCards = allCards.where((card) {
          final name = card["name"]!.toLowerCase();
          return name.startsWith(searchQuery.toLowerCase()) ||
              name.contains(searchQuery.toLowerCase());
        }).where((card) {
          // Filtrování podle hodnoty
          return card["value"] >= _minValue && card["value"] <= _maxValue;
        }).toList();
      }

      _sortCards(); // Aplikace řazení
    });
  }

  void _sortCards() {
    if (_sortOrder == null) {
      filteredCards.shuffle(); // Zamíchání seznamu
      return;
    }

    if (_sortOrder == 'A-Z') {
      filteredCards.sort((a, b) => a["name"]!.toLowerCase().compareTo(b["name"]!.toLowerCase()));
    } else {
      filteredCards.sort((a, b) => b["name"]!.toLowerCase().compareTo(a["name"]!.toLowerCase()));
    }
  }

  void _changeSortOrder(String? newSortOrder) {
    setState(() {
      _sortOrder = newSortOrder;
      _sortCards();
    });
  }

  void _updateValueRange(RangeValues values) {
    setState(() {
      _minValue = values.start;
      _maxValue = values.end;
      _applyFilters();
    });
  }

  Widget _buildCardTile(Map<String, dynamic> card) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.asset(
          'Assets/Obrazky/${card["image"]}',
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.image_not_supported, size: 50);
          },
        ),
        title: Text(card["name"]!),
        subtitle: Text("Hodnota: ${card["value"]}"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardDetailPage(card: card),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Všechny kartičky"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Vyhledávání",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: updateSearchQuery,
                      ),
                    ),
                    SizedBox(width: 10),
                    DropdownButton<String>(
                      value: _sortOrder,
                      items: [
                        DropdownMenuItem(
                          value: null, // Hodnota pro žádné řazení
                          child: Text('Žádné řazení'),
                        ),
                        DropdownMenuItem(
                          value: 'A-Z',
                          child: Text('A-Z'),
                        ),
                        DropdownMenuItem(
                          value: 'Z-A',
                          child: Text('Z-A'),
                        ),
                      ],
                      onChanged: (newSortOrder) {
                        _changeSortOrder(newSortOrder);
                      },
                      icon: Icon(Icons.sort),
                      underline: SizedBox(),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Hodnota:"),
                    Expanded(
                      child: RangeSlider(
                        values: RangeValues(_minValue, _maxValue),
                        min: 10,
                        max: 50,
                        divisions: 40,
                        labels: RangeLabels(
                          _minValue.round().toString(),
                          _maxValue.round().toString(),
                        ),
                        onChanged: _updateValueRange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredCards.isEmpty
                ? Center(
              child: Text("Žádné výsledky nenalezeny"),
            )
                : ListView.builder(
              itemCount: filteredCards.length,
              itemBuilder: (context, index) {
                final card = filteredCards[index];
                return _buildCardTile(card);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Detailní stránka kartičky
class CardDetailPage extends StatelessWidget {
  final Map<String, dynamic> card;

  CardDetailPage({required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card["name"]!),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'Assets/Obrazky/${card["image"]}',
              width: 300,
              height: 300,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.image_not_supported, size: 200);
              },
            ),
            SizedBox(height: 20),
            Text("Hodnota: ${card["value"]}"),
            Text("Útok: ${card["attack"]}"),
            Text("Obrana: ${card["defense"]}"),
            Text("Životy: ${card["health"]}"),
            Text("Dovednosti: ${card["skills"]}"),
          ],
        ),
      ),
    );
  }
}