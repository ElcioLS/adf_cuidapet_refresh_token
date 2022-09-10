// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adf_cuidapet/app/core/exceptions/failure.dart';
import 'package:adf_cuidapet/app/core/exceptions/user_not_exists_exception.dart';
import 'package:adf_cuidapet/app/core/logger/app_logger.dart';
import 'package:adf_cuidapet/app/core/ui/widgets/loader.dart';
import 'package:adf_cuidapet/app/core/ui/widgets/messages.dart';
import 'package:adf_cuidapet/app/services/user/user_service.dart';
import 'package:mobx/mobx.dart';

part 'login_controller.g.dart';

class LoginController = LoginControllerBase with _$LoginController;

abstract class LoginControllerBase with Store {
  final UserService _userService;
  final AppLogger _log;

  LoginControllerBase({
    required UserService userService,
    required AppLogger log,
  })  : _userService = userService,
        _log = log;

  Future<void> login(String login, String password) async {
    try {
      Loader.show();
      await _userService.login(login, password);
      Loader.hide();
    } on Failure catch (e) {
      final errorMessage = e.message ?? 'Erro ao relizar login';
      _log.error(errorMessage);
      Loader.hide();
      Messages.alert(errorMessage);
    } on UserNotExistsException {
      const errorMessage = 'Usuário não cadastrado';
      _log.error(errorMessage);
      Loader.hide();
      Messages.alert(errorMessage);
    }
  }
}
