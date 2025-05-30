import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/services/storage_service.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AuthProvider extends ChangeNotifier {
  var loginController = TextEditingController();
  var passwordController = TextEditingController();

  bool isLoading = false;

  Future<bool> authLogin(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    var res = await HttpService.post(
        login,
        {
          'username': loginController.text,
          'password': passwordController.text,
        },
        isAuth: true);

    if (res['status'] == Result.success) {
      await StorageService.write('token', res['data']['token']);
      await StorageService.write('user', res['data']['user']);

      CustomSnackbars(context)
          .success('Tizimga kirish muvaffaqiyatli amalga oshirildi');

      isLoading = false;
      notifyListeners();

      return true;
    } else {
      CustomSnackbars(context).error('Login yoki parol noto\'g\'ri');

      isLoading = false;
      notifyListeners();

      return false;
    }
  }
}
