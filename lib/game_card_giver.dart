import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jet_lag/database/database.dart';
import 'package:jet_lag/game_card.dart';

class GameCardGiver {
  final int? _seed;
  List<GameCard> _cards = List.empty(growable: true);
  final List<GameCard> _timeCards = List.empty(growable: true);
  final List<GameCard> _specialCards = List.empty(growable: true);
  final List<GameCard> _curseCards = List.empty(growable: true);

  GameCardGiver({seed}) : _seed = seed;

  factory GameCardGiver.get() {
    _gameCardGiver ??= GameCardGiver();

    return _gameCardGiver!;
  }

  void addCard(GameCard card, bool addToDb, int id) {
    card.id = id;

    switch (card.type) {
      case GameCardType.specialCard:
        _specialCards.add(card);
        break;
      case GameCardType.timeBonus:
        _timeCards.add(card);
        break;
      case GameCardType.curse:
        _curseCards.add(card);
        break;
      default:
        debugPrint("Found card without type: $card has type:${card.type}");
    }

    _cards.add(card);

    if (addToDb) DatabaseHandler().createCard(card);
  }

  void addCards(List<GameCard> cards) async {
    var filled = !(await DatabaseHandler().deckIsFilled);

    for (int i = 0; i < cards.length; i++) {
      addCard(cards[i], filled, i);
    }
    //_cards.addAll(cards);
  }

  @override
  String toString() {
    return "GameCardGiver: $_cards";
  }

  Future<GameCard?> getCard() async {
    _cards = await DatabaseHandler().getCardsFromDeck();
    if (_cards.isEmpty) {
      return null;
    }

    /*int chosen = Random(_seed).nextInt(100);
    if(chosen)*/

    int chosenIndex = Random(_seed).nextInt(_cards.length);
    debugPrint("Removed card at index $chosenIndex from list $_cards");

    var chosenCard = _cards[chosenIndex];
    return chosenCard;
  }
}

GameCardGiver? _gameCardGiver;

final List<GameCard> mainJetLagHideSeekGameCards = [
  GameCard(
    icon: Icons.alarm_add,
    description: "+10 min",
    title: "Vremenski bonus",
    type: GameCardType.timeBonus,
  ),
  GameCard(
    icon: Icons.alarm_add,
    description: "+5 min",
    title: "Vremenski bonus",
    type: GameCardType.timeBonus,
  ),
  GameCard(
    icon: Icons.alarm_add,
    description: "+5 min",
    title: "Vremenski bonus",
    type: GameCardType.timeBonus,
  ),
  GameCard(
    icon: Icons.alarm_add,
    description: "+3 min",
    title: "Vremenski bonus",
    type: GameCardType.timeBonus,
  ),
  GameCard(
    icon: Icons.alarm_add,
    description: "+3 min",
    title: "Vremenski bonus",
    type: GameCardType.timeBonus,
  ),
  GameCard(
    icon: Icons.alarm_add,
    description: "+3 min",
    title: "Vremenski bonus",
    type: GameCardType.timeBonus,
  ),
  GameCard(
    icon: Icons.block,
    description: "Izglasaj veto na postavljeno pitanje",
    title: "Veto",
    type: GameCardType.specialCard,
  ),
  //GameCard(title: "Dupliciraj karticu", icon: Icons.copy, description: "Dupliciraj ", type: type)
  GameCard(
    title: "Discard 1 Draw 2",
    icon: Icons.delete,
    description: "Izbaci jednu, izaberi dvije",
    type: GameCardType.curse,
  ),
  GameCard(
    title: "Izazov kockara",
    icon: Icons.star,
    description: "bacaj kockice za svaki korak 10 min",
    castingCost: " (Skrivači trebaju maknuti 2 karte)",
    type: GameCardType.curse,
  ),
  GameCard(
    title: "Izazov socijalizacije",
    icon: Icons.star,
    description: "Trebaš slikati 5 ljudi u istoj slici ",
    castingCost: "(sljedeće pitanje je besplatno)",
    type: GameCardType.curse,
  ),
  GameCard(
    title: "Izazov točne publike",
    icon: Icons.star,
    description:
        "Prije nego što postavite sljedeće pitanje, morate pljeskati 15 sekundi nakon što vaš drugi član tima pokrene štopericu, (sa svake strane vrijeme može odstupati 0,5 sekundi). Ako ne uspijete, morate pričekati najmanje 5 minuta prije ponovnog pokušaja. ",
    type: GameCardType.curse,
  ),
  GameCard(
    title: "Čarolija nesigurnog izabiranja",
    icon: Icons.star,
    description:
        "Odaberite tri pitanja u različitim kategorijama. Tragatelji ne mogu postavljati ta pitanja do kraja vašeg trčanja.",
    castingCost: "(Odbaci sve karte u ruci.)",
    type: GameCardType.curse,
  ),
  GameCard(
    title: "Izazov slučajnog turista",
    icon: Icons.star,
    description:
        "Postavite točku na kartu najmanje 300 metara od mjesta na kojem tragači trenutno stoje. Ako su za točno 15 minuta unutar 50m od te točke, zaleđeni su na mjestu sljedećih 15 minuta.",
    castingCost: "(Tragači moraju biti udaljeni najmanje 1km)",
    type: GameCardType.curse,
  ),
  GameCard(
    title: "Izazov zoologa",
    icon: Icons.star,
    description:
        "Snimite fotografiju divlje ribe, ptice, sisavca, gmaza, vodozemca ili bube. Tražitelji moraju fotografirati divlje životinje u istoj kategoriji prije postavljanja drugog pitanja.",

    type: GameCardType.curse,
  ),
  GameCard(
    title: "Izazov skupog automobila",
    icon: Icons.star,
    description:
        "Fotografirajte automobil. Tražitelji moraju fotografirati skuplji automobil prije postavljanja novog pitanja.",
    type: GameCardType.curse,
  ),
  GameCard(
    title: "Izazov nevođenog turista",
    icon: Icons.star,
    description:
        "Pošaljite tražiteljima nezumiranu Google Street View sliku s ulice unutar 50m od mjesta gdje se sada nalaze. Snimka mora biti paralelna s horizontom i uključivati ​​barem jednu građevinu koju je izgradio čovjek osim ceste. Bez korištenja interneta za istraživanje, moraju pronaći ono što ste im poslali u stvarnom životu prije nego što mogu koristiti prijevoz ili postaviti drugo pitanje. Moraju poslati sliku skrivaču na provjeru.",
    castingCost: "(Odbaci vremensku bonusnu karticu)",
    type: GameCardType.curse,
  ),
  GameCard(
    title: "Izazov misionara",
    icon: Icons.star,
    description:
        "Sljedeće pitanje mora biti postavljeno iz crkve/dok tragači diraju crkvu.",
    castingCost: "(Odbaci 1 kartu)",
    type: GameCardType.curse,
  ),
  GameCard(
    title: "Izazov preumjerenog skupljača",
    icon: Icons.star,
    description:
        "Skrivači odabiru jednu lokaciju udaljenu maksimalno 250m od trenutne lokacije tragača. Tragači trebaju tamo otići i provesti 5min i uzeti suvenir s te lokacije. Ako na kraju traganja ne daju skrivačima taj suvenir, dodaje se 15min na vrijeme skrivača.",
    castingCost: "(Odbaci jednu karticu izazova.)",
    type: GameCardType.curse,
  ),
  GameCard(
    title: "Izazov kockarskog promatrača ptica",
    icon: Icons.star,
    description:
        "Baci kockicu, onoliko koliko dobiješ na kockici, toliko moraš ptica uslikati.",
    type: GameCardType.curse,
  ),
];
