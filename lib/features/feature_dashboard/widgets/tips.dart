import 'package:agrichapp/features/feature_authentication/providers/auth_provider.dart';
import 'package:agrichapp/features/feature_tips/models/card_info.dart';
import 'package:agrichapp/features/feature_tips/widgets/tip_card_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tips extends StatefulWidget {
  const Tips({super.key});

  @override
  State<Tips> createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  List<CardInfo> cards = [];
  List<String> stringCards = [];
  final List<CardInfo> searchedList = [];
  late AuthProvider authProvider;

  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    authProvider.getSavedTips().then((value) {
      setState(() {
        stringCards = value;
        for (String tip in stringCards) {
          cards.add(authProvider.getTip(tip));
        }
        cards = cards.reversed.toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return cards.isNotEmpty
        ? Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30, top: 40),
                alignment: Alignment.center,
                child: Text(
                  'Previous Tips',
                  style: Theme.of(context).textTheme.titleLarge,
                  textScaleFactor: 0.8,
                ),
              ),
              Container(
                height: MediaQuery.sizeOf(context).height * 0.8,
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                child: ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      return TipCardDisplay(
                        cards: cards,
                        index: index,
                      );
                    }),
              ),
            ],
          )
        : Container(
            alignment: Alignment.center,
            margin:
                EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.3),
            child:
                Text("No Tips", style: Theme.of(context).textTheme.titleMedium),
          );
  }
}
