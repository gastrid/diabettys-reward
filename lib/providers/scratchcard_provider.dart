import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:diabettys_reward/models/scratchcard.dart';


class ScratchcardProvider extends ChangeNotifier {
  late Box<List> _scratchcards;

  ScratchcardProvider() {
      _scratchcards = Hive.box("scratchcards");

  }



  List<ScratchcardModel>? getScratchcards(String date) {
    final scrc = _scratchcards.get(date);
    final List<ScratchcardModel>? scratchcardList = scrc?.cast<ScratchcardModel>();
    return scratchcardList;
        
  }


  Future<void> addScratchcards(String date, List<ScratchcardModel> scratchcards) async {
    await _scratchcards.put(date, scratchcards);
    notifyListeners();
  }


  // Future<void> updateScratchcard(int index, ScratchcardModel scratchcard) async {
  //   await _scratchcards.putAt(index, scratchcard);
  //   notifyListeners();
  // }

  // Future<void> deleteScratchcard(int index) async {
  //   await _scratchcards.deleteAt(index);
  //   notifyListeners();
  // }
}
