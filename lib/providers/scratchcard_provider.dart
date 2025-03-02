import 'package:diabettys_reward/utils/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:diabettys_reward/models/scratchcard.dart';
import 'package:diabettys_reward/models/history_entry.dart';
import 'package:intl/intl.dart';
import 'package:diabettys_reward/utils/constants.dart';


class ScratchcardProvider extends ChangeNotifier {
  late Box<List> _scratchcards;
  late List<String> _orderedDates;

  ScratchcardProvider() {
      _scratchcards = Hive.box("scratchcards");

      _orderedDates = _scratchcards.keys.toList().cast<String>();
      _orderedDates.sort((a, b) => b.compareTo(a));
  }

  List<ScratchcardModel>? getScratchcards(String date) {
    final scrc = _scratchcards.get(date);
    final List<ScratchcardModel>? scratchcardList = scrc?.cast<ScratchcardModel>();
    return scratchcardList;
        
  }

  int getEntryCount() {
    return _orderedDates.length;
  }


  Future<void> addScratchcards(String date, List<ScratchcardModel> scratchcards) async {
    await _scratchcards.put(date, scratchcards);
    notifyListeners();
  }

  Future<void> updateScratched(String today, String scratchcardId) async {
    final scratchcards = getScratchcards(today);
    if (scratchcards != null) {
      scratchcards.where((s) => s.id == scratchcardId).first.isScratched = true;
      await addScratchcards(today, scratchcards);
    } 
  }

  List<HistoryEntry> getHistory(int offset, int limit) {
    List<HistoryEntry> history = [];
    List<String> selectedDates = [];
    if (offset > _orderedDates.length) {
      throw OffsetOverListLengthException(listName: "orderedDates");
    } else if ((offset + limit) > _orderedDates.length) {
      selectedDates = _orderedDates.sublist(offset);
    } else {
      selectedDates = _orderedDates.sublist(offset, offset + limit);
    }
    for (var date in selectedDates) {
      final scratchcards = getScratchcards(date);
      if (scratchcards != null) {
      history.add(HistoryEntry(
        date: DateFormat(dateFormat).parse(date),
        scratchcards: scratchcards));
      }
    }
    return history;
  }

  Future<void> deleteAllEntries() async {
    await _scratchcards.clear();
    _orderedDates.clear();
    notifyListeners();
  }

  Future<void> deleteScratchcards(String date) async {
    await _scratchcards.delete(date);
    notifyListeners();
  }

}
