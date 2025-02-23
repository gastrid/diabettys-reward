import 'dart:math';
import 'package:flutter/material.dart';
import 'package:diabettys_reward/models/reward.dart';
import 'package:diabettys_reward/models/scratchcard.dart';
import 'package:diabettys_reward/providers/scratchcard_provider.dart';
import 'package:diabettys_reward/providers/history_provider.dart';
import 'package:diabettys_reward/providers/reward_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:diabettys_reward/utils/constants.dart';
import 'package:uuid/uuid.dart';
import 'package:scratcher/scratcher.dart';


class ScratchCardScreen extends StatefulWidget {
  const ScratchCardScreen({super.key});

  @override
  State<ScratchCardScreen> createState() => _ScratchCardScreenState();
}

class _ScratchCardScreenState extends State<ScratchCardScreen> {
  late List<ScratchcardModel> _scratchcards;
  var _isLoading = false;


  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _getScratchcards().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scratch Card'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
          itemCount: _scratchcards.length,
          itemBuilder: (ctx, index) {
            final scratchcard = _scratchcards[index];
            return ListTile(
          title: Text(scratchcard.name),
          subtitle: Text(scratchcard.isWon ? 'Won' : 'Not Won'),
            );
          },
        ),
    );
  }
  
  Future<void> _getScratchcards() async {
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    final scratchcardProvider = Provider.of<ScratchcardProvider>(context, listen: false);
    final rewardProvider = Provider.of<RewardProvider>(context, listen: false);
    String latestActiveDate =
        await historyProvider
            .getLatestActiveDate();
    print(latestActiveDate);

    DateTime today = DateTime.now();
    String todayString = DateFormat(dateFormat).format(today);
    List<ScratchcardModel>? scratchcards;
    if (todayString == latestActiveDate) {
      print("today is the same as latest active date");
       scratchcards = scratchcardProvider.getScratchcards(todayString);
       if (scratchcards != null) {
        _scratchcards = scratchcards;
        print("they arelady exist");
        return;
       }
    }
    if (scratchcards == null) {
      final rewards = rewardProvider.getRewards();
      print("reward length: ${rewards.length}");
      _generateScratchcards(rewards, todayString);
      scratchcardProvider.addScratchcards(todayString, _scratchcards);
      print("Scratchcards generated");
      historyProvider.setLatestActiveDate(todayString);
    }
  }

  void _generateScratchcards(List<RewardModel> rewards, String date) {
    List<ScratchcardModel> scratchcards = [];
    for (var r in rewards) {
      final random = Random().nextDouble();
      final scratchCard = ScratchcardModel(
        id: Uuid().v4(),
        rewardId: r.id,
        name: r.name,
        date: date,
        isWon: random < r.winProbability,
        exclusions: r.exclusions
      );
      scratchcards.add(scratchCard);
    }

    // Exclusions
    for (var s in scratchcards) {
      for (var e in s.exclusions) {
        if (scratchcards.any((element) => element.rewardId == e && element.isWon)) {
          s.isWon = false;
        }
      }
      print(s);
    }
    _scratchcards = scratchcards;
  }

}
