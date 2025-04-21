//! Code style for Decks
// [
//   {
//     title: string
//     description: string
//     castingCost: string? | int?  // string for challenges, int for coins
//     discarding: {
//                   types: ["curse","time","special","*"] // list with types of cards needed for discarding. * is for all.
//                   number: int | "*" // "*" is for all cards in hand
//                   photoAttached: bool // does the curse need a photo attached
//                   other: string // text "Are you sure you " + this text +"?" (ex. are more than a kilometer away)
//     },
//     icon: {codePoint: string, fontFamily: string} | int // int is codePoint in MaterialIcon icons, Map for non MaterialIcon icons
//     type: "curse" | "time" | "special"
//     repeat: int? //
//   }
//   ...
// ]

final List<Map<String, Object?>> hideSeekDeck = [
  {
    "title": "Vremenski bonus",
    "description": "+10 min",
    "icon": {"codePoint": 57459, "fontFamily": null},
    "type": "timeBonus",
  },
];
