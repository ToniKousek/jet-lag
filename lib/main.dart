import 'package:flutter/material.dart';
import 'package:jet_lag/card_widget.dart';
import 'package:jet_lag/database/database.dart';
import 'package:jet_lag/game_card.dart';
import 'package:jet_lag/game_card_giver.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Jet Lag: The Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<GameCard> cards = [];
  //GameCardGiver gameCardGiver = GameCardGiver();
  GameCardGiver gameCardGiver = GameCardGiver.get();

  void deleteCard(GameCard card) async {
    /*if (!cards.remove(card)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No card found")));
    } else {
      gameCardGiver.addCard(card, false);*/

    DatabaseHandler().deleteCardFromHand(card);
    cards = await DatabaseHandler().getCardsFromHand();
    setState(() {
      cards = [...cards];
    });
    //}
    debugPrint(cards.toString());
  }

  void addCard() async {
    var card = await gameCardGiver.getCard();
    debugPrint("main:60 got card $card");
    if (card == null) {
      if (!mounted) throw TypeError();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No more cards available")));
      return;
    }

    DatabaseHandler().putCardInHand(card);

    //cards.add(card);
    cards = await DatabaseHandler().getCardsFromHand();

    setState(() {
      cards = [...cards];
    });
  }

  @override
  void initState() {
    super.initState();

    DatabaseHandler().getCardsFromHand().then((e) {
      setState(() {
        cards = e;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child:
            cards.isEmpty
                ? Text(
                  "You currently have no cards,\nAdd more by clicking the plus button",
                )
                : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    return CardWidget(
                      gameCard: cards[index],
                      removeSelf: deleteCard,
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addCard,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
