import 'package:hive/hive.dart';

part 'users.g.dart';

@HiveType(typeId: 0)
class Users extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String password;

  Users({
    required this.username,
    this.email,
    required this.password,
  });
}
