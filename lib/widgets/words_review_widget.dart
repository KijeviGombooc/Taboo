import 'package:flutter/material.dart';
import 'package:taboo/models/word.dart';

class WordsReviewWidget extends StatefulWidget {
  final List<Word> words;
  final String text;
  final Function onListChange;

  WordsReviewWidget({
    required this.words,
    required this.text,
    required this.onListChange,
  });

  @override
  _WordsReviewWidgetState createState() => _WordsReviewWidgetState(words);
}

class _WordsReviewWidgetState extends State<WordsReviewWidget> {
  final List<Word> wordsChanging;
  late List<Word> wordsConstant;
  _WordsReviewWidgetState(this.wordsChanging) {
    wordsConstant = List<Word>.from(wordsChanging);
  }

  @override
  void initState() {
    super.initState();
  }

  void _resetWords() {
    setState(() {
      wordsChanging.clear();
      wordsChanging.addAll(wordsConstant);
      widget.onListChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: _resetWords,
          child: Text(widget.text),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 20,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: wordsChanging.length,
              itemBuilder: (ctx, i) {
                return SizedBox(
                  height: 50,
                  child: Dismissible(
                    onDismissed: (direction) {
                      setState(() {
                        wordsChanging.removeAt(i);
                        widget.onListChange();
                      });
                    },
                    key: UniqueKey(),
                    child: Card(
                      child: Center(
                          child: Text(
                        wordsChanging[i].word,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 18),
                      )),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              wordsChanging.add(const Word(word: "EXTRA WORD", taboos: []));
              widget.onListChange();
            });
          },
          child: Text("Add extra"),
        ),
      ],
    );
  }
}
