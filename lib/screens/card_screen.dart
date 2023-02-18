import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:word_card/utils/constants.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({Key? key}) : super(key: key);

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  late List<String> wordList = [];
  late SharedPreferences prefs;
  String randomWord = "";
  String emptyWord = "";
  bool isLoading = false;
  late FlutterTts flutterTts;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final words = prefs.getStringList('words');
    if (words != null) {
      wordList = words;
      randomWord = getRandomWord(wordList);
    } else {
      emptyWord = "단어카드를 등록해주세요.";
    }
    setState(() {});
  }

  Future initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    await flutterTts.setLanguage('kr');
    _setAwaitOptions();

    flutterTts.setCompletionHandler(() {
      setState(() {
        isLoading = false;
        randomWord = getRandomWord(wordList);
      });
    });
  }

  Future _speak() async {
    await flutterTts.speak(randomWord);
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    initTts();
  }

  void onTapWordCard() {
    if (isLoading) return;
    print("tap tap");
    isLoading = true;
    _speak();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (wordList.isEmpty) {
      return Center(
        child: Text(emptyWord,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            )),
      );
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.all(50),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                  )),
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  randomWord,
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: onTapWordCard,
              child: Container(),
              style: const ButtonStyle(
                animationDuration: Duration(milliseconds: 15),
                overlayColor:
                    MaterialStatePropertyAll<Color>(kColorAccentAlpha),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getRandomWord(List<String> list) {
    final random = Random();
    var i = random.nextInt(list.length);
    return list[i];
  }
}
