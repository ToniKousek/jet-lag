import 'package:flutter/material.dart';

class GameCard {
  int? id;
  IconData icon;
  String title;
  String description;
  GameCardType? type;
  String? castingCost;

  GameCard({
    required this.title,
    required this.icon,
    required this.description,
    this.id,
    this.type,
    this.castingCost,
  });

  factory GameCard.fromMap(Map<String, Object?> mappedCard) {
    if (!(mappedCard["title"] is String ||
        mappedCard["description"] is String)) {
      throw TypeError();
    }

    IconData displayedIcon = switch (mappedCard["type"]) {
      GameCardType.timeBonus => Icons.alarm_add,
      GameCardType.curse => Icons.star,
      GameCardType.specialCard => Icons.block,
      _ => Icons.star,
    };

    GameCardType? gottenType =
        (mappedCard["type"] is int)
            ? GameCardType.values[int.parse(mappedCard["type"].toString())]
            : null;

    return GameCard(
      title: mappedCard["title"]!.toString(),
      icon: displayedIcon,
      description: mappedCard["description"]!.toString(),
      castingCost: mappedCard["castingCost"]?.toString(),
      id: int.parse(mappedCard["id"]!.toString()),
      type: gottenType,
    );
  }

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "casting_cost": castingCost,
      "type": type != null ? GameCardType.values.indexOf(type!) : null,
    };
  }

  @override
  String toString() {
    return "GameCard:($title,$id)";
  }
}

enum GameCardType { timeBonus, curse, specialCard }
