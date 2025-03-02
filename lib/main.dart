import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'screens/scratchcard_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/history_screen.dart';
import 'package:diabettys_reward/providers/reward_provider.dart';
import 'package:diabettys_reward/providers/scratchcard_provider.dart';
import 'package:diabettys_reward/providers/history_provider.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:diabettys_reward/models/scratchcard.dart';
import 'package:diabettys_reward/models/reward.dart';
import 'package:path_provider/path_provider.dart';
import 'package:diabettys_reward/theme/app_theme.dart';
import 'package:diabettys_reward/screens/reset_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(RewardModelAdapter());
  Hive.registerAdapter(ScratchcardModelAdapter());
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox<RewardModel>('rewards');
  await Hive.openBox<List>('scratchcards');

  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RewardProvider()),
        ChangeNotifierProvider(create: (_) => ScratchcardProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: MaterialApp(
        title: "Diabetty's reward",
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

@override
  void initState() {
    super.initState();
    injectHistory();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    ScratchcardScreen(),
    HistoryScreen(),
    SettingsScreen(),
    ResetScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    final noGoColour = Theme.of(context).colorScheme.outlineVariant;
    final selectedIconColour = Theme.of(context).primaryColor;
    final unselectedIconTheme = Theme.of(context).iconTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Diabetty's Reward"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Scratch Cards',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon
            (Icons.block,
            color: noGoColour,
            ),
            label: "no go zone",

          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: selectedIconColour,
        unselectedIconTheme: unselectedIconTheme,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> injectHistory() async {
    final dates = [
      "2025/02/24",
      "2025/02/23",
      "2025/02/22",
      "2025/02/21",
      "2025/02/18",
      "2025/02/17",
      "2025/01/12",
      "2024/12/29",
      "2024/12/25",
      "2024/12/01",
      "2024/11/29",
      "2024/11/25",
      "2024/11/01",
      "2024/10/29",
      "2024/10/25",
      "2024/10/01",
      "2024/09/29",
      "2024/09/25",
      "2024/09/01",
      "2024/08/29",
      "2024/08/25",
      "2024/08/01",
    ];
    final scratchcardProvider =
        Provider.of<ScratchcardProvider>(context, listen: false);
    final rewardProvider = Provider.of<RewardProvider>(context, listen: false);

    final rewards = rewardProvider.getAllrewards();

    for (var date in dates) {
      final scratchcards = <ScratchcardModel>[];
      for (var reward in rewards) {
      final random = Random().nextDouble();
        scratchcards.add(ScratchcardModel(
            id: const Uuid().v4(),
            rewardId: reward.id,
            name: reward.name,
            isWon: random < reward.winProbability,
            isScratched: Random().nextBool(),
            date: date));
      }
      await scratchcardProvider.addScratchcards(date, scratchcards);
    }
  }
}
