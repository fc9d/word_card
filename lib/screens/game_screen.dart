import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_card/models/card_game_model.dart';
import 'package:word_card/utils/constants.dart';
import 'package:word_card/widgets/score_card.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<CardGameModel> wordList = [];
  List<CardGameModel> matchChecked = [];
  String emptyWord = "";
  int tries = 0;
  int score = 0;
  late SharedPreferences prefs;
  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final words = prefs.getStringList('words');

    if (words != null) {
      if (words.length > 8) {
        words.shuffle();
        words.removeRange(8, words.length);
      }
      for (int i = 0; i < 2; i++) {
        for (String value in words) {
          CardGameModel model = CardGameModel(value, false, false);
          wordList.add(model);
        }
      }

      wordList.shuffle();
    } else {
      emptyWord = "단어카드를 등록해주세요.";
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void restartGame() {
    score = 0;
    tries = 0;
    matchChecked = [];
    wordList.shuffle();
    for (CardGameModel model in wordList) {
      model.isOpen = false;
      model.isComplete = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (wordList.isEmpty) {
      return Center(
        child: Text(
          emptyWord,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      );
    }
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 25,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [ScoreCard("시도", '$tries'), ScoreCard("점수", "$score")],
        // ),
        Expanded(
          child: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: wordList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (wordList[index].isOpen ||
                          wordList[index].isComplete) {
                        return;
                      }
                      wordList[index].isOpen = true;
                      matchChecked.add(wordList[index]);
                      if (matchChecked.length == 2) {
                        if (matchChecked[0].name == matchChecked[1].name) {
                          score += 100;
                          matchChecked.clear();
                          tries += 1;
                          setState(() {
                            if (score >= wordList.length / 2 * 100) {
                              Future.delayed(
                                const Duration(milliseconds: 200),
                                () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        title: Text('대단해요'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              '그만',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              restartGame();
                                            },
                                            child: const Text(
                                              '다시시작',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFFE55870),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          });
                        } else {
                          setState(() {});
                          Future.delayed(const Duration(milliseconds: 500), () {
                            for (CardGameModel model in matchChecked) {
                              model.isOpen = false;
                            }
                            matchChecked.clear();
                            setState(() {
                              tries += 1;
                            });
                          });
                        }
                      } else {
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Center(
                        child: wordList[index].isOpen
                            ? Text(
                                wordList[index].name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              )
                            : const Icon(
                                Icons.star_outline,
                                color: kColorHotPint,
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
