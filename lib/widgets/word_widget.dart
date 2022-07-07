import 'package:flutter/material.dart';
import 'package:akon/models/word.dart';

class WordWidget extends StatelessWidget {
  final Word word;

  const WordWidget({required this.word});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: word.taboos.length + 2,
      itemBuilder: (ctx, i) {
        if (i == 0) {
          return Center(
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(word.word),
              ),
            ),
          );
        } else if (i == 1) {
          return SizedBox(height: 20);
        } else {
          return Padding(
            padding: const EdgeInsets.all(2),
            child: Center(
              child: Text(
                word.taboos[i - 2],
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 22),
              ),
            ),
          );
        }
      },
    );
  }
}
