// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adf_cuidapet/app/core/logger/app_logger.dart';
import 'package:adf_cuidapet/app/core/ui/widgets/loader.dart';
import 'package:adf_cuidapet/app/services/user/user_service.dart';
import 'package:mobx/mobx.dart';

part 'register_controller.g.dart';

class RegisterController = _RegisterControllerBase with _$RegisterController;

abstract class _RegisterControllerBase with Store {
  final UserService _userService;
  final AppLogger _log;

  _RegisterControllerBase({
    required UserService userService,
    required AppLogger log,
  })  : _userService = userService,
        _log = log;

  Future<void> register(
      {required String email, required String password}) async {
    Loader.show();
    await Future.delayed(const Duration(seconds: 2));
    Loader.hide();
  }
}
