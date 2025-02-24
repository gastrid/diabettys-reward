import 'dart:math';
import 'dart:io';

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

class ScratchcardScreen extends StatefulWidget {
  const ScratchcardScreen({super.key});

  @override
  State<ScratchcardScreen> createState() => _ScratchcardScreenState();
}

class _ScratchcardScreenState extends State<ScratchcardScreen> {
  late List<ScratchcardModel> _scratchcards;
  var _isLoading = false;
  late String _todayString;

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

// TODO: just show result when isScratched is true
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
                final scratchKey = GlobalKey<ScratcherState>();

                print("${scratchcard.name} ${scratchcard.isScratched}");

                return Column(
                  children: [
                    Text(scratchcard.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    Container(
                      margin: const EdgeInsets.fromLTRB(30, 5, 30, 20),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: scratchcard.isScratched
                            ? Container(
                                height: 120,
                                color: scratchcard.isWon
                                    ? Colors.green
                                    : Colors.red,
                                child: Center(
                                  child: Text(
                                    scratchcard.isWon ? 'You won!' : 'No luck',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              )
                            : Scratcher(
                                key: scratchKey,
                                brushSize: 50,
                                image: _getImage(scratchcard.imagePath),
                                color: Colors.grey,
                                threshold: 50,
                                onThreshold: () {
                                  scratchcard.isScratched = true;
                                  // PICKUP: fix this reveal thing
                                  _updateScratched(
                                      _todayString, scratchcard.id);
                                },
                                child: Container(
                                  height: 120,
                                  color: scratchcard.isWon
                                      ? Colors.green
                                      : Colors.red,
                                  child: Center(
                                    child: Text(
                                      scratchcard.isWon
                                          ? 'You won!'
                                          : 'No luck',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                )),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Future<void> _updateScratched(String today, String scratchcardId) async {
    final scratchcardProvider =
        Provider.of<ScratchcardProvider>(context, listen: false);
    return scratchcardProvider.updateScratched(today, scratchcardId);
  }

  Future<void> _getScratchcards() async {
    final historyProvider =
        Provider.of<HistoryProvider>(context, listen: false);
    final scratchcardProvider =
        Provider.of<ScratchcardProvider>(context, listen: false);
    final rewardProvider = Provider.of<RewardProvider>(context, listen: false);
    String latestActiveDate = await historyProvider.getLatestActiveDate();

    DateTime today = DateTime.now();
    _todayString = DateFormat(dateFormat).format(today);
    List<ScratchcardModel>? scratchcards;
    if (_todayString == latestActiveDate) {
      scratchcards = scratchcardProvider.getScratchcards(_todayString);
      if (scratchcards != null) {
        _scratchcards = scratchcards;
        return;
      }
    }
    if (scratchcards == null || scratchcards.isEmpty) {
      final rewards = rewardProvider.getRewards();
      _generateScratchcards(rewards, _todayString);
      scratchcardProvider.addScratchcards(_todayString, _scratchcards);
      historyProvider.setLatestActiveDate(_todayString);
    }
  }

  void _generateScratchcards(List<RewardModel> rewards, String date) {
    List<ScratchcardModel> scratchcards = [];
    for (var r in rewards) {
      final random = Random().nextDouble();
      final scratchCard = ScratchcardModel(
        id: const Uuid().v4(),
        rewardId: r.id,
        name: r.name,
        date: date,
        isWon: random < r.winProbability,
        exclusions: r.exclusions,
        imagePath: r.imagePath,
      );
      scratchcards.add(scratchCard);
    }

    // Exclusions
    for (var s in scratchcards) {
      for (var e in s.exclusions) {
        if (scratchcards
            .any((element) => element.rewardId == e && element.isWon)) {
          s.isWon = false;
        }
      }
    }
    _scratchcards = scratchcards;
  }
}

Image _getImage(String? imagePath) {
  if (imagePath == null) {
    return Image.asset('assets/images/scratchcard.jpg');
  } else {
    var image = Image.file(
      File(imagePath),
      opacity: const AlwaysStoppedAnimation(0.5),
    );

    return image;
  }
}
