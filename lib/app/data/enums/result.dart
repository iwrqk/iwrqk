import '../models/account/conversations/message.dart';

class ApiResult<T> {
  final T? data;
  final bool success;
  final String? message;

  ApiResult({
    required this.data,
    required this.success,
    this.message,
  });
}

class GroupResult<T> {
  final List<T> results;
  final int count;

  GroupResult({
    required this.results,
    required this.count,
  });
}

class MessageResult {
  final String first;
  final String last;
  final int count;
  final List<MessageModel> results;

  MessageResult({
    required this.first,
    required this.last,
    required this.count,
    required this.results,
  });
}
