import 'package:flutter/widgets.dart';
import 'package:jet_lag/game_card.dart';
import 'package:jet_lag/game_card_giver.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  DatabaseHandler() {
    var _ = db;
  }

  Future<Database> get db async {
    WidgetsFlutterBinding.ensureInitialized();

    _db ??= openDatabase(
      join(await getDatabasesPath(), "game_cards_database.db"),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE cards (id INTEGER PRIMARY KEY, title TEXT, description TEXT, casting_cost TEXT, type INT)"
          "CREATE TABLE hand (id INTEGER PRIMARY KEY, card_id INTEGER, FOREIGN KEY(card_id) REFERENCES cards(id))",
        );
        GameCardGiver.get().addCards(mainJetLagHideSeekGameCards);
      },
      onUpgrade: (db, oldVersion, newVersion) {
        db.execute("DROP TABLE cards");
        db.execute(
          "CREATE TABLE IF NOT EXISTS cards (id INTEGER PRIMARY KEY, title TEXT, description TEXT, casting_cost TEXT, type INT)",
        );
        db.execute(
          "CREATE TABLE IF NOT EXISTS hand (id INTEGER PRIMARY KEY, card_id INTEGER, FOREIGN KEY(card_id) REFERENCES cards(id))",
        );
        db.execute("DELETE FROM hand;");
        db.execute("DELETE FROM cards;");
        GameCardGiver.get().addCards(mainJetLagHideSeekGameCards);
        debugPrint("Upgraded");
      },
      version: 7,
    );

    return _db!;
  }

  void createCard(GameCard card) async {
    (await db).insert("cards", card.toMap());
    debugPrint("Inserting card $card");
  }

  Future<bool> get deckIsFilled async {
    var response = await (await db).rawQuery(
      "SELECT COUNT(*) AS count FROM cards;",
    );
    debugPrint("Filled: $response");
    return int.parse(response[0]["count"].toString()) > 0;
  }

  Future<List<GameCard>> getCardsFromDeck() async {
    List<Map<String, Object?>> gottenCards = (await (await db).query("cards"));

    List<GameCard> parsedCards = List.empty(growable: true);

    for (var card in gottenCards) {
      parsedCards.add(GameCard.fromMap(card));
    }
    debugPrint("Got cards from deck: ${parsedCards.toString()}");
    return parsedCards;
  }

  Future<List<GameCard>> getCardsFromHand() async {
    List<Map<String, Object?>> gottenCards = (await (await db).query(
      "hand",
      columns: ["card_id"],
      where: "id = ?",
      whereArgs: [0],
    ));

    List<GameCard> parsedCards = List.empty(growable: true);

    for (var card in gottenCards) {
      //parsedCards.add(GameCard.fromMap(card));
      if (card["card_id"] is! int) {
        throw TypeError();
      }

      parsedCards.add(await getCard(int.parse(card["card_id"].toString())));
    }

    debugPrint("Got cards: $parsedCards");

    return parsedCards;
  }

  void putCardInHand(GameCard card) async {
    (await db).insert("hand", {"id": 0, "card_id": card.id});
  }

  void deleteCardFromHand(GameCard card) async {
    debugPrint("Deleting card: $card");
    (await db).delete('hand', where: 'card_id = ?', whereArgs: [card.id]);
  }

  Future<GameCard> getCard(int id) async {
    var card = await (await db).query(
      "cards",
      where: "id = ?",
      whereArgs: [id],
    );
    return GameCard.fromMap(card[0]);
  }
}

Future<Database>? _db;
