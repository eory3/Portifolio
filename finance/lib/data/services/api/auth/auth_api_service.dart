import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/config/environment.dart';
import 'package:finance/data/services/api/auth/auth_service.dart';
import 'package:finance/data/services/config/firebase_translate_errors.dart';
import 'package:finance/data/services/models/user.dart';
import 'package:finance/domain/models/user.dart';
import 'package:finance/utils/result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

class AuthApiService extends IAuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final _log = Logger('AuthApiService');

  AuthApiService({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore,
       _firebaseAuth = firebaseAuth;

  @override
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  Future<Result<IUser>> _getUser() async {
    final currentUser = _firebaseAuth.currentUser;

    if (currentUser == null) {
      _log.warning('Usuário não autenticado');
      return Result.error('Dados do usuário não encontrados.');
    }

    final userInfo = await _firebaseFirestore
        .collection(Environment.collectionsKeys.users)
        .doc(currentUser.uid)
        .get()
        .then((value) => value.data());

    if (userInfo == null) {
      _log.warning('Informações do usuário não encontradas no Firestore');
      return Result.error(
        'Informações do usuário não encontradas no Firestore',
      );
    }

    userInfo['id'] = currentUser.uid;

    final user = UserModel.fromMap(userInfo);

    return Result.ok(user);
  }

  @override
  Future<Result<IUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = await _getUser();

      switch (user) {
        case Ok<IUser>():
          return Result.ok(user.value);
        case Error<IUser>():
          return Result.error(user.error);
      }
    } on FirebaseAuthException catch (error) {
      _log.warning(error.code);
      return Result.error(
        FirebaseTranslateErrors.errors[error.code] ??
            'Error para autenticar na api',
      );
    } catch (error) {
      return Result.error('Erro inesperado tente novamente em instantes');
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return Result.ok(null);
    } on FirebaseAuthException catch (error) {
      _log.warning(error);
      return Result.error(
        FirebaseTranslateErrors.errors[error.code] ??
            'Error para fazer o logout na api',
      );
    } catch (error) {
      _log.warning(error.toString());
      return Result.error('Erro inesperado tente novamente em instantes');
    }
  }

  @override
  Future<Result<void>> recovery({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return Result.ok(null);
    } on FirebaseAuthException catch (error) {
      _log.warning(error);
      return Result.error(
        FirebaseTranslateErrors.errors[error.code] ??
            'Error para enviar email de redefinição de senha na api',
      );
    } catch (error) {
      _log.warning(error.toString());
      return Result.error('Erro inesperado tente novamente em instantes');
    }
  }
}
