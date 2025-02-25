import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/scratchcard_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/history_screen.dart';
import 'package:diabettys_reward/providers/reward_provider.dart';
import 'package:diabettys_reward/providers/scratchcard_provider.dart';
import 'package:diabettys_reward/providers/history_provider.dart';
import 'package:hive/hive.dart';
import 'package:diabettys_reward/models/scratchcard.dart';
import 'package:diabettys_reward/models/reward.dart';
import 'package:path_provider/path_provider.dart';
import 'package:diabettys_reward/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(RewardModelAdapter());
  Hive.registerAdapter(ScratchcardModelAdapter());
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  // TODO: delete
  Hive.deleteBoxFromDisk("scratchcards");
  // Hive.deleteBoxFromDisk("rewards");
  await Hive.openBox<RewardModel>('rewards');
  await Hive.openBox<List>('scratchcards');

  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RewardProvider()),
        ChangeNotifierProvider(create: (_) => ScratchcardProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.theme,
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ScratchcardScreen(),
    HistoryScreen(),
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
        title: const Text("'Diabetty's Reward"),
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
            icon: Icon(Icons.history),
            label: 'History',
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
