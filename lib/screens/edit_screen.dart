import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_card/utils/constants.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late Set<String> wordSet = {};
  late SharedPreferences prefs;
  final teController = TextEditingController();

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final words = prefs.getStringList('words');
    if (words != null) {
      wordSet = words.toSet();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void _onDelete(int index) async {
    final element = wordSet.toList()[index];
    wordSet.remove(element);
    await prefs.setStringList('words', wordSet.toList());
    setState(() {});
  }

  void _onAddWord() async {
    final element = teController.text;
    wordSet.add(element);
    await prefs.setStringList('words', wordSet.toList());
    teController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: ListView.builder(
              itemCount: wordSet.toList().length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    title: Text(wordSet.toList()[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: kColorHotPint),
                      onPressed: () => _onDelete(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 25),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  cursorColor: kColorHotPint,
                  controller: teController,
                  decoration: const InputDecoration(
                    hintText: '단어를 입력해주세요.',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color: kColorHotPint),
                    ),
                  ),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: const BorderSide(color: Color(0xFFE55870)),
                    ),
                  ),
                  backgroundColor: const MaterialStatePropertyAll<Color>(
                    Color(0xFFE55870),
                  ),
                ),
                onPressed: () {
                  if (teController.text.isNotEmpty) {
                    _onAddWord();
                  }
                  teController.clear();
                },
                child: const Text(
                  '추가',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
