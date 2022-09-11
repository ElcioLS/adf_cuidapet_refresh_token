import 'package:adf_cuidapet/app/core/exceptions/failure.dart';
import 'package:adf_cuidapet/app/core/exceptions/user_exists_exception.dart';
import 'package:adf_cuidapet/app/core/exceptions/user_not_exists_exception.dart';
import 'package:adf_cuidapet/app/core/helpers/constants.dart';
import 'package:adf_cuidapet/app/core/local_storage/local_storage.dart';
import 'package:adf_cuidapet/app/core/logger/app_logger.dart';
import 'package:adf_cuidapet/app/models/social_login_type.dart';
import 'package:adf_cuidapet/app/models/social_network_model.dart';
import 'package:adf_cuidapet/app/repositories/social/social_repository.dart';
import 'package:adf_cuidapet/app/repositories/user/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final AppLogger _log;
  final LocalStorage _localStorage;
  final LocalSecureStorage _localSecureStorage;
  final SocialRepository _socialRepository;

  UserServiceImpl({
    required UserRepository userRepository,
    required AppLogger log,
    required LocalStorage localStorage,
    required LocalSecureStorage localSecureStorage,
    required SocialRepository socialRepository,
  })  : _userRepository = userRepository,
        _log = log,
        _localStorage = localStorage,
        _localSecureStorage = localSecureStorage,
        _socialRepository = socialRepository;

  @override
  Future<void> register(String email, String password) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;

      final userMethods = await firebaseAuth.fetchSignInMethodsForEmail(email);

      if (userMethods.isNotEmpty) {
        throw UserExistsException();
      }

      await _userRepository.register(email, password);
      final userRegisterCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userRegisterCredential.user?.sendEmailVerification();
    } on FirebaseException catch (e, s) {
      _log.error('Erro ao criar usuárop no Firebase', e, s);
      throw Failure(message: 'Erro ao criar usuário');
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;
      final loginMethods = await firebaseAuth.fetchSignInMethodsForEmail(email);

      if (loginMethods.isEmpty) {
        throw UserNotExistsException();
      }

      if (loginMethods.contains('password')) {
        // print('Achou o login por password');
        final userCredential = await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        final userVerified = userCredential.user?.emailVerified ?? false;
        if (!userVerified) {
          userCredential.user?.sendEmailVerification();
          throw Failure(
              message:
                  'E-mail não confirmado. Favor, verifique sua caxa de entrada ou spam e confirme');
        }
        final accessToken = await _userRepository.login(email, password);
        await _saveAccessToken(accessToken);
        await _confirmLogin();
        await _getUserData();
      } else {
        throw Failure(
            message:
                'Login não pode ser feito por e-mail e password, por favor utilize outro método');
      }
    } on FirebaseException catch (e, s) {
      _log.error(
          'Usuário ou senha inválidos!, FirebaseAuthError [${e.code}]', e, s);
      throw Failure(message: 'Usuário ou senha inválidos!');
    }
  }

  Future<void> _saveAccessToken(String accessToken) => _localStorage.write(
      Constants.LOCAL_STORAGE_ACCESS_TOKEN_KEY, accessToken);

  Future<void> _confirmLogin() async {
    final confirmLoginModel = await _userRepository.confirmLogin();
    await _saveAccessToken(confirmLoginModel.accessToken);
    await _localSecureStorage.write(Constants.LOCAL_STORAGE_REFRESH_TOKEN_KEY,
        confirmLoginModel.refreshToken);
  }

  Future<void> _getUserData() async {
    final userModel = await _userRepository.getUserLogged();
    await _localStorage.write<String>(
        Constants.LOCAL_STORAGE_USER_LOGGED_DATA_KEY, userModel.toJson());
  }

  @override
  Future<void> socialLogin(SocialLoginType socialLoginType) async {
    try {
      final SocialNetworkModel socialModel;
      final AuthCredential authCredencial;
      final firebaseAuth = FirebaseAuth.instance;

      switch (socialLoginType) {
        case SocialLoginType.facebook:
          throw Failure(message: 'Face not implemented');
        // break;
        case SocialLoginType.google:
          socialModel = await _socialRepository.googleLogin();
          authCredencial = GoogleAuthProvider.credential(
            accessToken: socialModel.accessToken,
            idToken: socialModel.id,
          );
          break;
      }

      final loginMethods =
          await firebaseAuth.fetchSignInMethodsForEmail(socialModel.email);

      final methodCheck = _getMethodToSocialLoginType(socialLoginType);

      if (loginMethods.isNotEmpty && !loginMethods.contains(methodCheck)) {
        throw Failure(
            message:
                'Login não pode ser feito por $methodCheck, favor utilizar outro método.');
      }

      await firebaseAuth.signInWithCredential(authCredencial);
      final accessToken = await _userRepository.loginSocial(socialModel);
      await _saveAccessToken(accessToken);
      await _confirmLogin();
      await _getUserData();
    } on FirebaseAuthException catch (e, s) {
      _log.error('Erro ao realizar login com $socialLoginType', e, s);
      throw Failure(message: 'Erro ao realizar login');
    }
  }

  String _getMethodToSocialLoginType(SocialLoginType socialLoginType) {
    switch (socialLoginType) {
      case SocialLoginType.facebook:
        return 'facebook.com';

      case SocialLoginType.google:
        return 'google.com';
    }
  }
}
