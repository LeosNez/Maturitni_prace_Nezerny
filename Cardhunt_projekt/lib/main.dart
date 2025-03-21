import 'package:flutter/material.dart'; //Vývoj uživatelského rozhraní
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    home: FirstPage(), // Výchozí stránka aplikace
    debugShowCheckedModeBanner: false,
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
            child: SingleChildScrollView(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Zarovnání ve středu
              crossAxisAlignment: CrossAxisAlignment.stretch, // Tlačítka na celou šířku
              children: [
                Text(
                  "Přihlásit nebo Registrovat", // Úvodní text
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
      ),
    );
  }
}

class LogInScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscured = true;

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
      body: SingleChildScrollView( // Přidáme scrollování
        child: Container(
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
                    Text("Přihlášení", style: TextStyle(color: Colors.white, fontSize: 40)),
                    SizedBox(height: 10),
                    Text("Vítejte zpět! Přihlaste se níže.", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
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
                      Container(
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
                            buildTextField("Uživatelské jméno", usernameController),
                            buildTextField("Email", emailController),
                            buildPasswordField("Heslo", passwordController, _isObscured, () {
                              _isObscured = !_isObscured;
                            }),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      MaterialButton(
                        onPressed: () => logIn(context),
                        height: 50,
                        color: Colors.blue[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text("Přihlásit se", style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpScreen()),
                          );
                        },
                        child: Text("Nemáte účet? Zaregistrujte se.", style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildPasswordField(String hintText, TextEditingController controller, bool obscureText, VoidCallback toggleVisibility) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

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

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'username': usernameController.text,
        'email': emailController.text,
      });

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
      body: SingleChildScrollView( // Přidáme scrollování
        child: Container(
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
                    Text("Registrace", style: TextStyle(color: Colors.white, fontSize: 40)),
                    SizedBox(height: 10),
                    Text("Vítejte! Zaregistrujte se níže.", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
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
                      Container(
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
                            buildTextField("Uživatelské jméno", usernameController),
                            buildTextField("Email", emailController),
                            buildPasswordField("Heslo", passwordController, obscurePassword, () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            }),
                            buildPasswordField("Potvrdit heslo", confirmPasswordController, obscureConfirmPassword, () {
                              setState(() {
                                obscureConfirmPassword = !obscureConfirmPassword;
                              });
                            }),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      MaterialButton(
                        onPressed: () => registerUser(context),
                        height: 50,
                        color: Colors.blue[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text("Zaregistrovat se", style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildPasswordField(String hintText, TextEditingController controller, bool obscureText, VoidCallback toggleVisibility) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  final TextEditingController friendEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Hlavní menu", style: TextStyle(fontWeight: FontWeight.bold)),
            if (user != null)
              Text(
                user.email ?? "",
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FirstPage()));
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.blue[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Vítejte v Card Hunt!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.blueGrey,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                _buildMenuButton(context, " Všechny kartičky ", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AllCardsPage()));
                }),
                _buildMenuButton(context, " Souboj kartiček ", () async {
                  if (user == null) return;
                  final snapshot = await FirebaseFirestore.instance
                      .collection('opened_cards')
                      .where('userId', isEqualTo: user.uid)
                      .get();
                  final playerCards = snapshot.docs.map((doc) => doc.data()).toList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardBattlePage(allPlayerCards: playerCards),
                    ),
                  );
                }),
                _buildMenuButton(context, " Víc nebo Míň ", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HigherOrLowerGame()));
                }),
                _buildMenuButton(context, " Nový balíček ", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EnterCodePage()));
                }),
                _buildMenuButton(context, " Moje kartičky ", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AllOpenedCardsPage()));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.blueAccent,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
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
    {"name": "drax", "attack": 78, "defense": 62},
    {"name": "diddz", "attack": 55, "defense": 53},
    {"name": "karel", "attack": 92, "defense": 80},
    {"name": "Max", "attack": 43, "defense": 61},
    {"name": "Yaden", "attack": 67, "defense": 74},
  ];

  List<Map<String, dynamic>> generatedCards = [];
  List<Map<String, dynamic>> filteredCards = [];
  String searchQuery = "";
  String sortBy = "name";
  bool ascending = true;

  @override
  void initState() {
    super.initState();
    generateCardVariants();
    filterCards(); // Ujistíme se, že se provede správné filtrování ihned
  }

  void generateCardVariants() {
    for (var background in backgrounds) {
      for (var hero in heroes) {
        for (var card in allCards) {
          generatedCards.add({
            "name": card["name"],
            "attack": card["attack"],
            "defense": card["defense"],
            "background": background,
            "hero": hero,
          });
        }
      }
    }
  }

  void filterCards() {
    setState(() {
      filteredCards = generatedCards
          .where((card) =>
          card["name"].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
      sortCards();
    });
  }

  void sortCards() {
    setState(() {
      filteredCards.sort((a, b) {
        dynamic valueA = a[sortBy];
        dynamic valueB = b[sortBy];

        if (valueA is String && valueB is String) {
          return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
        } else if (valueA is int && valueB is int) {
          return ascending ? valueA - valueB : valueB - valueA;
        }
        return 0;
      });
    });
  }

  Widget buildFilterControls() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: "Hledat podle jména"),
              onChanged: (value) {
                searchQuery = value;
                filterCards(); // Automaticky provede filtrování a řazení
              },
            )
          ),
          DropdownButton<String>(
            value: sortBy,
            items: [
              DropdownMenuItem(value: "name", child: Text("Jméno")),
              DropdownMenuItem(value: "attack", child: Text("Útok")),
              DropdownMenuItem(value: "defense", child: Text("Obrana")),
            ],
            onChanged: (value) {
              setState(() {
                sortBy = value!;
                sortCards();
              });
            },
          ),
          IconButton(
            icon: Icon(ascending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() {
                ascending = !ascending;
                sortCards();
              });
            },
          ),
        ],
      ),
    );
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
            Positioned(
              top: 5,
              child: Text(
                card["name"],
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: 99,
              left: 15,
              child: Text(
                card["attack"].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: 99,
              left: 68,
              child: Text(
                card["defense"].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCardGrid(List<Map<String, dynamic>> cards) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 120 / 160,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return buildCardTile(cards[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text("Všechny kartičky", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          buildFilterControls(),
          Expanded(
            child: buildCardGrid(filteredCards),
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

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _randomCards = getRandomCards();
        saveCardsToFirestore(_randomCards); // Uložení do Firestore
      });
    });
  }

  void saveCardsToFirestore(List<Map<String, dynamic>> cards) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("Uživatel není přihlášen.");
      return;
    }

    final CollectionReference cardsCollection = FirebaseFirestore.instance.collection('opened_cards');

    for (var card in cards) {
      cardsCollection.add({
        ...card,
        "userId": user.uid, // Přidáme UID uživatele
        "email": user.email, // Volitelně e-mail
        "timestamp": FieldValue.serverTimestamp(),
      }).then((docRef) {
        print("Kartička uložena s ID: ${docRef.id}");
      }).catchError((error) {
        print("Chyba při ukládání: $error");
      });
    }
  }

  List<Map<String, dynamic>> getRandomCards() {
    final random = Random();
    List<Map<String, dynamic>> shuffled = List.from(widget.generatedCards)..shuffle(random);
    return shuffled.take(3).toList(); // Vrátí 3 náhodné kartičky
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text("Otevření balíčku", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
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
              SizedBox(
                height: 180, // Nastavení výšky pro kartičky
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Posouvání horizontálně
                  itemCount: _randomCards.length,
                  itemBuilder: (context, index) {
                    return buildCardTile(_randomCards[index]);
                  },
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllOpenedCardsPage(),
                    ),
                  );
                },
                child: Text("Zobrazit všechny kartičky"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainMenu(),
                    ),
                  );
                },
                child: Text("Hlavní Menu"),
              ),
            ],
          ),
        )
            : GestureDetector(
          onTap: openPack,
          child: Image.asset('Assets/Obrazky/Balicek.png', width: 350, height: 350),
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
          Positioned(
            top: 134,
            left: 23,
            child: Text(
              card["attack"].toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 134,
            left: 94,
            child: Text(
              card["defense"].toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text("Detaily o kartičce", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
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
            Text(
              "Útok: ${card["attack"]}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Obrana: ${card["defense"]}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class AllOpenedCardsPage extends StatefulWidget {
  @override
  _AllOpenedCardsPageState createState() => _AllOpenedCardsPageState();
}

class _AllOpenedCardsPageState extends State<AllOpenedCardsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _searchQuery = "";
  String _sortBy = "name";
  bool _ascending = true;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Všechny získané kartičky")),
        body: Center(child: Text("Musíš se přihlásit, aby sis mohl zobrazit kartičky.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text("Všechny získané kartičky", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          buildFilterControls(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('opened_cards')
                  .where('userId', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Zatím nemáš žádnou kartičku 😢."),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EnterCodePage()),
                            );
                          },
                          child: Text("Přidat kartičku"),
                        ),
                      ],
                    ),
                  );
                }

                // Filtrace a počítání duplikátů
                Map<String, Map<String, dynamic>> uniqueCards = {};
                Map<String, int> cardCounts = {};

                for (var doc in snapshot.data!.docs) {
                  var data = doc.data() as Map<String, dynamic>;
                  String cardName = data["name"];

                  if (uniqueCards.containsKey(cardName)) {
                    cardCounts[cardName] = (cardCounts[cardName] ?? 1) + 1;
                  } else {
                    uniqueCards[cardName] = data;
                    cardCounts[cardName] = 1;
                  }
                }

                var cards = uniqueCards.values.toList();

                // Filtrace podle názvu karty
                cards = cards.where((card) {
                  return card["name"].toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();

                // Aplikování filtru podle času získání
                if (_startDate != null || _endDate != null) {
                  cards = cards.where((card) {
                    Timestamp timestamp = card["timestamp"];
                    DateTime date = timestamp.toDate();
                    bool withinDateRange = true;
                    if (_startDate != null) {
                      withinDateRange = withinDateRange && date.isAfter(_startDate!);
                    }
                    if (_endDate != null) {
                      withinDateRange = withinDateRange && date.isBefore(_endDate!);
                    }
                    return withinDateRange;
                  }).toList();
                }

                // Seřazení podle vybraného kritéria
                cards.sort((a, b) {
                  var aValue = a[_sortBy];
                  var bValue = b[_sortBy];

                  if (_sortBy == "timestamp") {
                    aValue = (aValue as Timestamp).toDate();
                    bValue = (bValue as Timestamp).toDate();
                  }

                  return _ascending
                      ? Comparable.compare(aValue, bValue)
                      : Comparable.compare(bValue, aValue);
                });

                return buildCardGrid(cards, cardCounts);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFilterControls() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: "Hledat podle jména"),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          DropdownButton<String>(
            value: _sortBy,
            items: [
              DropdownMenuItem(value: "name", child: Text("Jméno")),
              DropdownMenuItem(value: "attack", child: Text("Útok")),
              DropdownMenuItem(value: "defense", child: Text("Obrana")),
              DropdownMenuItem(value: "timestamp", child: Text("Čas získání")),
            ],
            onChanged: (value) {
              setState(() {
                _sortBy = value!;
                _ascending = true; // Po změně filtru nastavíme výchozí řazení vzestupně
              });
            },
          ),
          IconButton(
            icon: Icon(_ascending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() {
                _ascending = !_ascending;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildCardTile(Map<String, dynamic> card, int count) {
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
            Positioned(
              top: 5,
              child: Text(
                card["name"],
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: 99,
              left: 15,
              child: Text(
                card["attack"].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: 99,
              left: 68,
              child: Text(
                card["defense"].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            if (count > 1)
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "x$count",
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildCardGrid(List<Map<String, dynamic>> cards, Map<String, int> cardCounts) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 120 / 160,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        String cardName = cards[index]["name"];
        return buildCardTile(cards[index], cardCounts[cardName] ?? 1);
      },
    );
  }
}

class EnterCodePage extends StatefulWidget {
  @override
  _EnterCodePageState createState() => _EnterCodePageState();
}

class _EnterCodePageState extends State<EnterCodePage> {
  final TextEditingController _codeController = TextEditingController(); //final proměnné můžu nastavit hodnotu pouze jednou
  List<int> packCodes = [1111111111111, 2222222222222];
  // Funkce pro generování kartiček
  List<Map<String, dynamic>> generateCards(String code) {
    final List<String> backgrounds = ["pozadi.png", "Pozadi2.png", "Pozadi3.png"];
    final List<String> heroes = ["Hrdina1.png", "Hrdina2.png", "Hrdina3.png"];
    final List<Map<String, dynamic>> allCards = [
      {"name": "drax", "attack": 78, "defense": 62},
      {"name": "diddz", "attack": 55, "defense": 53},
      {"name": "karel", "attack": 92, "defense": 80},
      {"name": "Max", "attack": 43, "defense": 61},
      {"name": "Yaden", "attack": 67, "defense": 74},
    ];


    final random = Random(code.hashCode); // Seedujeme random na základě kódu
    List<Map<String, dynamic>> selectedCards = [];

    for (int i = 0; i < 3; i++) {
      var randomCard = allCards[random.nextInt(allCards.length)];
      var background = backgrounds[random.nextInt(backgrounds.length)];
      var hero = heroes[random.nextInt(heroes.length)];

      selectedCards.add({
        "name": randomCard["name"],
        "attack": randomCard["attack"],
        "defense": randomCard["defense"],
        "value": randomCard["value"],
        "background": background,
        "hero": hero,
      });
    }
    return selectedCards;
  }

  void _submitCode() {
    String code = _codeController.text.trim();
    if (code.length == 13) {
      List<Map<String, dynamic>> generatedCards = generateCards(code); // Generujeme kartičky

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PackOpeningPage(generatedCards: generatedCards),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kód musí mít 13 znaků!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text("Zadejte kód", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _codeController,
              maxLength: 13,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Zadejte 13místný kód",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitCode,
              child: Text("Potvrdit"),
            ),
          ],
        ),
      ),
    );
  }
}

class HigherOrLowerGame extends StatefulWidget {
  @override
  _HigherOrLowerGameState createState() => _HigherOrLowerGameState();
}

class _HigherOrLowerGameState extends State<HigherOrLowerGame> {
  final List<Map<String, dynamic>> allCards = [
    {"name": "drax", "attack": 78, "defense": 62},
    {"name": "diddz", "attack": 55, "defense": 53},
    {"name": "karel", "attack": 92, "defense": 80},
    {"name": "Max", "attack": 43, "defense": 61},
    {"name": "Yaden", "attack": 67, "defense": 74},
  ];

  final List<String> backgrounds = ["pozadi.png", "Pozadi2.png", "Pozadi3.png"];
  final List<String> heroes = ["Hrdina1.png", "Hrdina2.png", "Hrdina3.png"];

  late Map<String, dynamic> currentCard;
  late Map<String, dynamic> nextCard;
  int score = 0;
  String selectedStat = "attack";
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    allCards.shuffle();
    currentCard = addGraphicsToCard(allCards[0]);
    nextCard = getUniqueCard(currentCard);
  }

  Map<String, dynamic> addGraphicsToCard(Map<String, dynamic> card) {
    return {
      ...card,
      "background": backgrounds[random.nextInt(backgrounds.length)],
      "hero": heroes[random.nextInt(heroes.length)],
    };
  }

  Map<String, dynamic> getUniqueCard(Map<String, dynamic> excludeCard) {
    Map<String, dynamic> newCard;
    do {
      newCard = addGraphicsToCard(allCards[random.nextInt(allCards.length)]);
    } while (newCard["name"] == excludeCard["name"]); // Zajišťuje, že karta není stejná
    return newCard;
  }

  void guess(bool higher) {
    bool isCorrect = higher
        ? nextCard[selectedStat] > currentCard[selectedStat]
        : nextCard[selectedStat] < currentCard[selectedStat];

    if (isCorrect) {
      setState(() {
        score++;
        currentCard = nextCard;
        nextCard = getUniqueCard(currentCard);
      });
    } else {
      // Uložení skóre při prohře
      ScoreService().saveScore("HigherOrLower", score);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Konec hry!"),
          content: Text("Dosáhl jsi skóre: $score"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetGame();
              },
              child: Text("Hrát znovu"),
            ),
          ],
        ),
      );
    }
  }

  void resetGame() {
    setState(() {
      allCards.shuffle();
      currentCard = addGraphicsToCard(allCards[0]);
      nextCard = getUniqueCard(currentCard);
      score = 0;
    });
  }

  Widget buildCard(Map<String, dynamic> card, {bool showStats = true}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('Assets/Obrazky/${card["background"]}', width: 120, height: 160, fit: BoxFit.cover),
        Image.asset('Assets/Obrazky/${card["hero"]}', width: 100, height: 140, fit: BoxFit.cover),
        Image.asset('Assets/Obrazky/Ramecek.png', width: 120, height: 160, fit: BoxFit.cover),
        Positioned(top: 5, child: Text(card["name"], style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
        // Pokud showStats je false, nebudou se zobrazovat hodnoty 'attack' a 'defense'
        if (showStats) ...[
          Positioned(top: 134, left: 23, child: Text(card["attack"].toString(), style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          Positioned(top: 134, left: 95, child: Text(card["defense"].toString(), style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text("Víc nebo Míň", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Skóre: $score", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
            SizedBox(height: 20),
            Text("Aktuální karta:", style: TextStyle(fontSize: 22)),
            buildCard(currentCard), // Ukazujeme aktuální kartu s atributy
            SizedBox(height: 20),
            Text("Bude další karta mít vyšší nebo nižší ${selectedStat == "attack" ? "útok" : "obranu"}?", textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
            SizedBox(height: 20),
            buildCard(nextCard, showStats: false), // Skryjeme atributy na spodní kartě
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => guess(true),
                  icon: Icon(Icons.arrow_upward, size: 20),
                  label: Text("Víc"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () => guess(false),
                  icon: Icon(Icons.arrow_downward, size: 20),
                  label: Text("Míň"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedStat = "attack";
                    });
                  },
                  child: Text("Útok", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedStat == "attack" ? Colors.blue : Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedStat = "defense";
                    });
                  },
                  child: Text("Obrana", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedStat == "defense" ? Colors.blue : Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

class CardBattlePage extends StatefulWidget {
  final List<Map<String, dynamic>> allPlayerCards;

  CardBattlePage({required this.allPlayerCards});

  @override
  _CardBattlePageState createState() => _CardBattlePageState();
}

class _CardBattlePageState extends State<CardBattlePage> {
  late List<Map<String, dynamic>> allPlayerCards;
  late List<Map<String, dynamic>> playerCards;
  List<Map<String, dynamic>> enemyCards = [];
  String gameResult = "";
  int playerHP = 100;
  int enemyHP = 100;
  bool isPlayerTurn = true;
  Map<String, dynamic>? selectedCard;
  Map<String, dynamic>? selectedEnemyCard;
  Map<String, dynamic>? blinkingCard;

  // Nová proměnná pro sledování, zda došlo k poškození
  bool damageDealtThisTurn = false;

  final List<String> backgrounds = ["pozadi.png", "Pozadi2.png", "Pozadi3.png"];
  final List<String> heroes = ["Hrdina1.png", "Hrdina2.png", "Hrdina3.png"];

  @override
  void initState() {
    super.initState();
    allPlayerCards = widget.allPlayerCards;
    restartGame();
  }

  void restartGame() {
    setState(() {
      playerCards = (List<Map<String, dynamic>>.from(allPlayerCards)..shuffle())
          .take(2)
          .map((card) => addGraphicsToCard(card))
          .toList();

      generateEnemyCards();
      playerHP = 100;
      enemyHP = 100;
      isPlayerTurn = true;
      selectedCard = null;
      gameResult = "";
      damageDealtThisTurn = false; // Reset damage tracking
    });
  }

  void generateEnemyCards() {
    final List<Map<String, dynamic>> allCards = [
      {"name": "drax", "attack": 78, "defense": 62},
      {"name": "diddz", "attack": 55, "defense": 53},
      {"name": "karel", "attack": 92, "defense": 80},
      {"name": "Max", "attack": 43, "defense": 61},
      {"name": "Yaden", "attack": 67, "defense": 74},
    ];
    allCards.shuffle();
    enemyCards = allCards.take(2).map((card) => addGraphicsToCard(card)).toList();
  }

  Map<String, dynamic> addGraphicsToCard(Map<String, dynamic> card) {
    final random = Random();
    return {
      ...card,
      "background": backgrounds[random.nextInt(backgrounds.length)],
      "hero": heroes[random.nextInt(heroes.length)],
    };
  }

  void playerAttack() async {
    if (selectedCard == null || selectedEnemyCard == null || !isPlayerTurn) return;
    setState(() => isPlayerTurn = false);

    var target = selectedEnemyCard!;
    setState(() => blinkingCard = selectedCard);
    await Future.delayed(Duration(milliseconds: 300));
    setState(() => blinkingCard = target);
    await Future.delayed(Duration(milliseconds: 300));
    setState(() => blinkingCard = null);

    int damage = (selectedCard!["attack"] - target["defense"]).clamp(0, 100);
    setState(() => enemyHP = (enemyHP - damage).clamp(0, 100));

    // Pokud došlo k poškození, označíme, že damage bylo způsobeno
    if (damage > 0) {
      damageDealtThisTurn = true;
    }

    await Future.delayed(Duration(seconds: 1));

    if (enemyHP <= 0) {
      enemyCards.remove(target);
      setState(() => enemyHP = enemyCards.isNotEmpty ? 100 : 0);
      selectedEnemyCard = enemyCards.isNotEmpty ? enemyCards.first : null;
      if (enemyCards.isEmpty) {
        endGame("🏆 Vyhrál jsi!");
        return;
      }
    }

    botAttack();
  }

  void botAttack() async {
    await Future.delayed(Duration(seconds: 1));
    if (playerCards.isEmpty) return;

    var botCard = enemyCards.first;
    var target = playerCards.first;
    setState(() => blinkingCard = botCard);
    await Future.delayed(Duration(milliseconds: 300));
    setState(() => blinkingCard = target);
    await Future.delayed(Duration(milliseconds: 300));
    setState(() => blinkingCard = null);

    int damage = (botCard["attack"] - target["defense"]).clamp(0, 100);
    setState(() => playerHP = (playerHP - damage).clamp(0, 100));

    // Pokud došlo k poškození, označíme, že damage bylo způsobeno
    if (damage > 0) {
      damageDealtThisTurn = true;
    }

    await Future.delayed(Duration(seconds: 1));

    if (playerHP <= 0) {
      playerCards.removeAt(0);
      setState(() => playerHP = playerCards.isNotEmpty ? 100 : 0);
      selectedCard = playerCards.isNotEmpty ? playerCards.first : null;
      if (playerCards.isEmpty) {
        endGame("💀 Prohrál jsi!");
        return;
      }
    }

    // Pokud během tohoto kola nikdo neudělal žádné poškození, je to remíza
    if (!damageDealtThisTurn) {
      setState(() {
        gameResult = "💥 Remíza! Nikdo neudělal žádné poškození!";
      });
    }

    setState(() => isPlayerTurn = true);
    damageDealtThisTurn = false; // Reset damage tracking after turn
  }

  void endGame(String message) {
    if (message.contains("Vyhrál")) {
      ScoreService().saveScore("CardBattle", playerHP);
    } else {
      ScoreService().saveScore("CardBattle", 0);
    }

    setState(() {
      gameResult = message;
    });
  }

  Widget buildHealthBar(int hp, Color color) {
    return Container(
      width: 150,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black),
      ),
      child: Stack(
        children: [
          Container(
            width: (hp / 100) * 150,
            height: 20,
            decoration: BoxDecoration(
              color: hp > 0 ? color : Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Center(
            child: Text(
              "$hp HP",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(Map<String, dynamic> card, {bool isSelectable = false, bool isEnemyCard = false}) {
    bool isSelected = isEnemyCard ? selectedEnemyCard == card : selectedCard == card;
    bool isBlinking = blinkingCard == card;
    return AnimatedOpacity(
      opacity: isBlinking ? 0.3 : 1.0,
      duration: Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: isSelectable
            ? () => setState(() {
          if (isEnemyCard) {
            selectedEnemyCard = card;
          } else {
            selectedCard = card;
          }
        })
            : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'Assets/Obrazky/${card["background"]}',
              width: 120,
              height: 160,
              fit: BoxFit.cover,
              color: isSelected ? Colors.blue.withOpacity(0.3) : null,
              colorBlendMode: isSelected ? BlendMode.colorBurn : null,
            ),
            Image.asset('Assets/Obrazky/${card["hero"]}', width: 100, height: 140, fit: BoxFit.cover),
            Image.asset('Assets/Obrazky/Ramecek.png', width: 120, height: 160, fit: BoxFit.cover),
            Positioned(
              top: 5,
              child: Text(
                card["name"],
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: 134,
              left: 23,
              child: Text(
                card["attack"].toString(),
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: 134,
              left: 95,
              child: Text(
                card["defense"].toString(),
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            if (isSelected)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: isEnemyCard ? Colors.red : Colors.yellow, width: 4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text("Souboj kartiček", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: allPlayerCards.isEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Zatím nemáš žádné kartičky 😢."),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EnterCodePage()),
                );
              },
              child: Text("Přidat kartičku"),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isPlayerTurn ? "🔹 Tvoje kolo" : "🔻 Kolo soupeře",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            buildHealthBar(playerHP, Colors.green),
            SizedBox(height: 10),
            Wrap(
              spacing: 10, // Mezera mezi kartičkami
              children: playerCards.map((card) =>
                  buildCard(card, isSelectable: isPlayerTurn)
              ).toList(),
            ),
            SizedBox(height: 20),
            Text("⚔️ VS ⚔️", style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
            SizedBox(height: 20),
            buildHealthBar(enemyHP, Colors.red),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: enemyCards.map((card) =>
                  buildCard(card, isSelectable: isPlayerTurn, isEnemyCard: true)
              ).toList(),
            ),
            SizedBox(height: 20),
            gameResult.isNotEmpty
                ? Column(
              children: [
                Text(gameResult, style: TextStyle(fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
                ElevatedButton(
                    onPressed: restartGame, child: Text("🔄 Restartovat hru")),
                SizedBox(height: 10),
                ElevatedButton(onPressed: () => Navigator.pop(context),
                    child: Text("🏠 Hlavní menu")),
              ],
            )
                : ElevatedButton(
              onPressed: isPlayerTurn && selectedCard != null
                  ? playerAttack
                  : null,
              child: Text("👊 Útok!"),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveScore(String gameName, int score) async {
    try {
      // Získání aktuálního uživatele
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("Uživatel není přihlášen!");
        return;
      }

      // Získání jména uživatele (pokud není nastavené, použije "UnknownUser")
      String playerName = user.displayName ?? "UnknownUser";

      // Uložení skóre do Firestore
      await _db.collection('scores').add({
        'game': gameName,
        'player': playerName, // Automaticky získané jméno uživatele
        'score': score,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,  // Uložení ID uživatele pro lepší správu dat
      });

      print("Score saved successfully!");
    } catch (e) {
      print("Error saving score: $e");
    }
  }
}