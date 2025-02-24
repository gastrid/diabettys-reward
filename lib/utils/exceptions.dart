class NameDuplicateException implements Exception {
  final String name;
  late String message;

  NameDuplicateException({required this.name}) {
    message = "Name '$name' already exists";
  }

  @override
  String toString() => "NameDuplicateException: $message";
}