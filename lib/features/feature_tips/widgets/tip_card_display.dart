import 'package:agrichapp/features/feature_tips/models/card_info.dart';
import 'package:flutter/material.dart';

class TipCardDisplay extends StatelessWidget {
  const TipCardDisplay({
    super.key,
    required this.cards,
    required this.index,

  });

  final List<CardInfo> cards;

  final int index ;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            blurStyle: BlurStyle.outer,
            color: Colors.grey.shade400,
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          cards[index].day,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tilePadding: const EdgeInsets.only(
          left: 20,
          right: 10,
        ),
        childrenPadding: const EdgeInsets.all(10),
        children: [
          Divider(
            color: Theme.of(context).primaryColorLight,
            height: 0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              cards[index].tip,
              style: Theme.of(context).textTheme.bodyMedium,
              // textScaleFactor: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
