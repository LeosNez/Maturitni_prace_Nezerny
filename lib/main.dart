import 'package:flutter/material.dart'; //Vývoj uživatelského rozhraní
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math'; //random

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
    theme: ThemeData(primarySwatch: Colors.red), // Nastavení barevného tématu
    home: MainMenu(), // Výchozí stránka aplikace
  ));
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> logIn(BuildContext context) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      print("User signed in: ${userCredential.user?.email}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenu()),
      );
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  void showErrorDialog(BuildContext context, String message) {
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
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              // Upravený widget pro heslo
                              PasswordField(controller: passwordController),
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

// Vytvořený widget PasswordField
class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({Key? key, required this.controller}) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscured,
        decoration: InputDecoration(
          hintText: "Heslo",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> registerUser(BuildContext context) async {
    if (passwordController.text != confirmPasswordController.text) {
      showErrorDialog(context, "Hesla se neshodují.");
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      print("User registered: ${userCredential.user?.email}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenu()),
      );
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  void showErrorDialog(BuildContext context, String message) {
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
                                  controller: emailController,
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
                                  controller: passwordController,
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
                                  controller: confirmPasswordController,
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
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.blue,
                          offset: Offset(5, 5),
                        )
                      ]
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
                    style: TextStyle(
                      color: Colors.black,
                    ),
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
                    "Nový balíček",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                /*ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShopPage()),
                    );
                  },
                  child: Text("Obchod"),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AllCardsPage extends StatefulWidget {
  @override
  AllCardsPageState createState() => AllCardsPageState();
}

class AllCardsPageState extends State<AllCardsPage> {
  final List<String> backgrounds = ["pozadi.png", "Pozadi2.png", "Pozadi3.png"];
  final List<String> heroes = ["Hrdina1.png", "Hrdina2.png", "Hrdina3.png"];
  final List<Map<String, dynamic>> allCards = [
    {"name": "drax", "attack": 57, "defense": 46, "value": 100},
    {"name": "diddz", "attack": 32, "defense": 15, "value": 100},
    {"name": "karel", "attack": 20, "defense": 15, "value": 100},
  ];

  List<Map<String, dynamic>> generatedCards = [];

  @override
  void initState() {
    super.initState();
    generateCardVariants();
  }

  void generateCardVariants() {
    for (var background in backgrounds) {
      for (var hero in heroes) {
        for (var card in allCards) {
          generatedCards.add({
            "name": card["name"],
            "attack": card["attack"],
            "defense": card["defense"],
            "value": card["value"],
            "background": background,
            "hero": hero,
          });
        }
      }
    }
  }

  Widget buildCardTile(Map<String, dynamic> card) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardDetailPage(card: card),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('Assets/Obrazky/${card["background"]}', width: 120, height: 160, fit: BoxFit.cover),
            Image.asset('Assets/Obrazky/${card["hero"]}', width: 100, height: 140, fit: BoxFit.cover),
            Image.asset('Assets/Obrazky/Ramecek.png', width: 120, height: 160, fit: BoxFit.cover),
            Align(
              alignment: Alignment(-0.067, 0.9),
              child: Padding(
                padding: EdgeInsets.only(top: 125),
                child: Text(
                  card["attack"].toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.08, 0.9),
              child: Padding(
                padding: EdgeInsets.only(top: 125),
                child: Text(
                  card["defense"].toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 7,
              child: Text(
                card["name"],
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openPack() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PackOpeningPage(generatedCards: generatedCards)),
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
          ElevatedButton(
            onPressed: openPack,
            child: Text("Otevřít balíček"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: generatedCards.length,
              itemBuilder: (context, index) {
                return buildCardTile(generatedCards[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PackOpeningPage extends StatefulWidget {
  final List<Map<String, dynamic>> generatedCards;

  PackOpeningPage({required this.generatedCards});

  @override
  _PackOpeningPageState createState() => _PackOpeningPageState();
}

class _PackOpeningPageState extends State<PackOpeningPage> {
  bool _packOpened = false;
  List<Map<String, dynamic>> _randomCards = [];

  void openPack() {
    setState(() {
      _packOpened = true;
    });

    // Po krátkém zpoždění zobrazíme kartičky
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _randomCards = getRandomCards();
      });
    });
  }

  List<Map<String, dynamic>> getRandomCards() {
    final random = Random();
    List<Map<String, dynamic>> shuffled = List.from(widget.generatedCards)..shuffle(random);
    return shuffled.take(3).toList(); // Vrátí 3 náhodné kartičky
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Otevření balíčku")),
      body: Center(
        child: _packOpened
            ? AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(seconds: 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Získal jsi tyto kartičky!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _randomCards.map((card) {
                  return buildCardTile(card);
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Zpět"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllOpenedCardsPage(cards: _randomCards),
                    ),
                  );
                },
                child: Text("Zobrazit všechny kartičky"),
              ),
            ],
          ),
        )
            : GestureDetector(
          onTap: openPack,
          child: Image.asset('Assets/Obrazky/Balicek.png', width: 200, height: 200),
        ),
      ),
    );
  }

  Widget buildCardTile(Map<String, dynamic> card) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('Assets/Obrazky/${card["background"]}', width: 120, height: 160, fit: BoxFit.cover),
          Image.asset('Assets/Obrazky/${card["hero"]}', width: 100, height: 140, fit: BoxFit.cover),
          Image.asset('Assets/Obrazky/Ramecek.png', width: 120, height: 160, fit: BoxFit.cover),
          Align(
            alignment: Alignment(-0.067, 0.9),
            child: Padding(
              padding: EdgeInsets.only(top: 125),
              child: Text(
                card["attack"].toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.08, 0.9),
            child: Padding(
              padding: EdgeInsets.only(top: 125),
              child: Text(
                card["defense"].toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 7,
            child: Text(
              card["name"],
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class CardDetailPage extends StatelessWidget {
  final Map<String, dynamic> card;

  CardDetailPage({required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card["name"]),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${card["name"]}",
              style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Image.asset('Assets/Obrazky/${card["hero"]}', width: 180, height: 230, fit: BoxFit.cover),
            SizedBox(height: 10),
            Image.asset('Assets/Obrazky/Balicek.png', width: 180, height: 230, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text(
              "Útok: ${card["attack"]}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Obrana: ${card["defense"]}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Hodnota: ${card["value"]}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class AllOpenedCardsPage extends StatelessWidget {
  final List<Map<String, dynamic>> cards;

  AllOpenedCardsPage({required this.cards});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Všechny získané kartičky")),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return buildCardTile(cards[index]);
        },
      ),
    );
  }

  Widget buildCardTile(Map<String, dynamic> card) {
    return Card(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('Assets/Obrazky/${card["background"]}', width: 120, height: 160, fit: BoxFit.cover),
          Image.asset('Assets/Obrazky/${card["hero"]}', width: 100, height: 140, fit: BoxFit.cover),
          Image.asset('Assets/Obrazky/Ramecek.png', width: 120, height: 160, fit: BoxFit.cover),
          Align(
            alignment: Alignment(-0.067, 0.9),
            child: Padding(
              padding: EdgeInsets.only(top: 125),
              child: Text(
                card["attack"].toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.08, 0.9),
            child: Padding(
              padding: EdgeInsets.only(top: 125),
              child: Text(
                card["defense"].toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 7,
            child: Text(
              card["name"],
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}