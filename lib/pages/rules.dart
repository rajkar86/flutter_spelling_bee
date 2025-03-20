import 'package:flutter/material.dart';

class Rules extends StatelessWidget {
  const Rules({Key? key}) : super(key: key);

  Widget _card(String text, [bool heading = false]) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          text,
          style: TextStyle(
              fontSize: heading ? 20 : 14,
              fontWeight: heading ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = [];

    void addToList(List<String> l, bool header) =>
        cards.addAll(l.map((w) => _card(w, header)).toList());

    addToList(["Rules"], true);
    addToList([
      "Words must contain at least 4 letters.",
      "Words must include the center letter.",
      "Letters can be used more than once.",
      "Word must be in ENABLE2k word list",
    ], false);

    addToList(["Scoring"], true);

    addToList([
      "4-letter words are worth 1 point each.",
      "Longer words earn 1 point per letter.",
      "A pangram is a word that uses every letter",
      "Pangrams are worth 7 extra points.",
      "Each puzzle includes at least one pangram."
    ], false);

    return _build(cards);
  }

  Widget _build(List<Widget> cards) {
    return Scaffold(
        appBar: AppBar(title: const Text("Rules")),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Expanded(child: ListView(children: cards))]));
  }
}
