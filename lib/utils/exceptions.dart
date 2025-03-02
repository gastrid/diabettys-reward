class NameDuplicateException implements Exception {
  final String name;
  late String message;

  NameDuplicateException({required this.name}) {
    message = "Name '$name' already exists";
  }

  @override
  String toString() => "NameDuplicateException: $message";
}

class OffsetOverListLengthException implements Exception {
  final String listName;
  late String message;

  OffsetOverListLengthException({required this.listName}) {
    message = "Offset went over length of'$listName'";
  }

  @override
  String toString() => "OffsetOverListLengthException: $message";
}