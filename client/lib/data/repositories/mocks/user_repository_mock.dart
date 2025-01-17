import 'dart:convert';

import 'package:hsc_timesheet/data/models/user.dart';
import 'package:hsc_timesheet/data/repositories/server/api_connection.dart';
import 'package:hsc_timesheet/data/repositories/user_repository.dart';
import 'package:flutter/services.dart';

class UserRepositoryMock extends UserRepository {
  UserRepositoryMock({required ApiConnection connection});

  @override
  Future<User> getUserById(int timeSheetId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final data = await rootBundle.loadString('assets/mocks/user.json');
    return User.fromJson(json.decode(data));
  }

  @override
  Future<List<User>> getAllUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final data = await rootBundle.loadString('assets/mocks/all_user.json');

    // logger.d('Response: $data');

    final List<User> user = await json
        .decode(data)
        .map<User>((item) => User.fromJson(item))
        .toList();
    return user;
  }
}
