import 'package:user_repository/src/models/user.dart';

abstract class UserService {
  Future<void> addUser(String id, {Map<String, dynamic>? data});

  Future<User> getUser(String id);
}