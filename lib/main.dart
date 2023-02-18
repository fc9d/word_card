import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_card/utils/constants.dart';

import 'models/screen_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool isInit = false;

  Future initPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFinishAddWord = prefs.getBool('AddWord') ?? false;
    if (!isFinishAddWord) {
      List<String> wordList = [
        '기차',
        '거북이',
        '나비',
        '다람쥐',
        '바나나',
        '닭',
        '버스',
        '피아노',
        '부엉이',
        '토끼',
        '당근',
        '수박',
        '토마토',
        '복숭아',
        '딸기',
        '치즈',
        '돼지',
        '피자',
        '튤립',
        '호박',
      ];
      prefs.setStringList('words', wordList);
      prefs.setBool('AddWord', true);
    }
    Future.delayed(const Duration(seconds: 0), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    initPref();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<ScreenModel> _screens = ScreenModel.screens();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFFE55870),
      //   title: Text(_screens.firstWhere((element) => element.isSelected).title),
      // ),
      bottomNavigationBar: buildBottomNavigationBar(),
      backgroundColor: kColorAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: _screens.firstWhere((element) => element.isSelected).screen,
          ),
          // const BannerWidget(),
        ],
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() => BottomNavigationBar(
        items: _screens
            .map(
              (e) => BottomNavigationBarItem(
                icon: e.icon,
                label: e.title,
              ),
            )
            .toList(),
        currentIndex: _screens.indexWhere((element) => element.isSelected),
        elevation: 15,
        selectedItemColor: Color(0xFFE55870),
        onTap: (index) => setState(() {
          for (ScreenModel screenModel in _screens) {
            screenModel.isSelected = false;
          }
          _screens[index].isSelected = true;
        }),
      );
}
