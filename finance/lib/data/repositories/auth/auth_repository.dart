import 'package:finance/domain/models/user.dart';
import 'package:finance/utils/result.dart';
import 'package:flutter/material.dart';

abstract class IAuthRepository extends ChangeNotifier {
  bool get isAuthenticated;
  Future<Result<IUser>> getUser();
  Future<Result<void>> login({required String email, required String password});
  Future<Result<void>> logout();
  Future<Result<void>> recovery({required String email});
}
