import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/scratch_card_screen.dart';
import 'screens/settings_screen.dart';
import 'package:diabettys_reward/providers/reward_provider.dart';
import 'package:diabettys_reward/providers/reward_outcome_provider.dart';
import 'package:hive/hive.dart';
import 'package:diabettys_reward/models/reward_outcome.dart';
import 'package:diabettys_reward/models/reward.dart';
import 'package:path_provider/path_provider.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(RewardModelAdapter());
  Hive.registerAdapter(RewardOutcomeModelAdapter());
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox<RewardModel>('rewards');
  await Hive.openBox<RewardOutcomeModel>('rewardOutcomes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RewardProvider()),
        ChangeNotifierProvider(create: (_) => RewardOutcomeProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ScratchCardScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diabettys Reward'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Scratch Cards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
