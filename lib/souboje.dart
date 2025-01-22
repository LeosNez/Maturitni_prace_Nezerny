import 'package:flutter/material.dart';
import 'dart:math';

class BattlePage extends StatefulWidget {
  final List<Map<String, dynamic>> allCards;

  // Konstruktor pro přijetí seznamu kartiček
  BattlePage({required this.allCards});

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  Map<String, dynamic>? card1;
  Map<String, dynamic>? card2;
  String battleLog = "";

  // Funkce pro výběr náhodných kartiček
  void selectRandomCards() {
    final random = Random();
    setState(() {
      card1 = widget.allCards[random.nextInt(widget.allCards.length)];
      card2 = widget.allCards[random.nextInt(widget.allCards.length)];
      while (card1 == card2) {
        card2 = widget.allCards[random.nextInt(widget.allCards.length)];
      }
      battleLog = ""; // Vymažeme předchozí log
    });
  }

  // Simulace souboje
  void simulateBattle() {
    if (card1 == null || card2 == null) return;

    int health1 = card1!["health"];
    int health2 = card2!["health"];
    String log = "";

    while (health1 > 0 && health2 > 0) {
      // Kartička 1 útočí
      int damageTo2 = max(0, card1!["attack"] - card2!["defense"]);
      health2 -= damageTo2;
      log += "${card1!["name"]} způsobil ${damageTo2} poškození ${card2!["name"]}.\n";

      if (health2 <= 0) {
        log += "${card1!["name"]} vyhrál!\n";
        break;
      }

      // Kartička 2 útočí
      int damageTo1 = max(0, card2!["attack"] - card1!["defense"]);
      health1 -= damageTo1;
      log += "${card2!["name"]} způsobil ${damageTo1} poškození ${card1!["name"]}.\n";

      if (health1 <= 0) {
        log += "${card2!["name"]} vyhrál!\n";
        break;
      }
    }

    setState(() {
      battleLog = log;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Souboj kartiček"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (card1 != null && card2 != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCardDisplay(card1!),
                Text("VS", style: TextStyle(fontSize: 24)),
                _buildCardDisplay(card2!),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: simulateBattle,
              child: Text("Začít souboj"),
            ),
          ],
          if (battleLog.isNotEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Text(
                    battleLog,
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
              ),
            ),
          ElevatedButton(
            onPressed: selectRandomCards,
            child: Text("Vybrat náhodné kartičky"),
          ),
        ],
      ),
    );
  }

  Widget _buildCardDisplay(Map<String, dynamic> card) {
    return Column(
      children: [
        Image.asset(
          'Assets/Obrazky/${card["image"]}',
          width: 100,
          height: 100,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.image_not_supported, size: 50);
          },
        ),
        SizedBox(height: 10),
        Text(
          card["name"],
          style: TextStyle(fontSize: 18),
        ),
        Text("Útok: ${card["attack"]}"),
        Text("Obrana: ${card["defense"]}"),
        Text("Životy: ${card["health"]}"),
      ],
    );
  }
}
/*import 'package:flutter/material.dart';
import 'souboje.dart'; // Import souboru, kde je definována stránka BattlePage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Skryje debug banner
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  // Seznam všech kartiček
  final List<Map<String, dynamic>> allCards = [

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Domovská stránka"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Vítejte ve hře Souboj kartiček!",
              style: TextStyle(fontSize: 20,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Přechod na stránku BattlePage a předání seznamu kartiček
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BattlePage(allCards: allCards),
                  ),
                );
              },
              child: Text("Jít na souboj"),
            ),
          ],
        ),
      ),
    );
  }
}
*/