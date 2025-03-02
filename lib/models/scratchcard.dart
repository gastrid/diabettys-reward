import 'package:hive_ce/hive.dart';


part 'scratchcard.g.dart';


@HiveType(typeId: 1)
class ScratchcardModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;


  @HiveField(2)
  final String rewardId;

  @HiveField(3)
  final String date;

  @HiveField(4)
  bool isWon;

  @HiveField(5)
  bool isScratched;

  @HiveField(6)
  String? imagePath;

  List<String> exclusions = [];

  ScratchcardModel({
    required this.id,
    required this.name,
    required this.rewardId,
    required this.date,
    required this.isWon,
    this.isScratched = false,
    this.exclusions = const [],
    this.imagePath,
  });
}
