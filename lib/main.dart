import 'package:flutter/material.dart';

import 'models/screen_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Splash Screen',
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
      appBar: AppBar(
        title: Text(_screens.firstWhere((element) => element.isSelected).title),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
    onTap: (index) => setState(() {
      for (ScreenModel screenModel in _screens) {
        screenModel.isSelected = false;
      }
      _screens[index].isSelected = true;
    }),
  );
}
