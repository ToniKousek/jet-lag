import 'package:flutter/material.dart';
import 'package:jet_lag/game_card.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.gameCard,
    required this.removeSelf,
  });

  final GameCard gameCard;
  final Function removeSelf;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(gameCard.title),
        leading: Icon(gameCard.icon),
        trailing: ElevatedButton(
          onPressed:
              () => {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Delete"),
                      content: Text(
                        "Are you sure you want to delete this card?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            debugPrint("Cancel");
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            debugPrint("Delete");
                            removeSelf(gameCard);
                            Navigator.of(context).pop();
                          },
                          child: Text("Delete"),
                        ),
                      ],
                    );
                  },
                ),
              },
          child: Icon(Icons.delete),
        ),
        subtitle: Column(
          children: [
            Text(gameCard.description),
            gameCard.castingCost != null
                ? Text("CASTING COST: ${gameCard.castingCost!}")
                : Container(),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
