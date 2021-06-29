class HttpExeption implements Exception {
  final String message;
  HttpExeption(this.message);

  @override
  String toString() {
    // ignore: todo
    // TODO: implement toString
    return message;
    //return super.toString();
  }
}
