import 'package:flutter/material.dart';
import 'package:sportaqs/models/response_api.dart';
import 'package:sportaqs/models/user.dart';
import 'package:sportaqs/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService userService;
  User? activeUser;
  String? errorMessage;
  bool loading = false;
  List<User> userList = [];

  UserProvider(this.userService);

  //login
  Future<void> login(String username, String password) async {
    errorMessage = null;
    loading = true;
    notifyListeners();

    try{
      ResponseApi response = await userService.login(username, password);
      if (response.success && response.data!= null){
        activeUser = User.fromLoginJson(response.data);
      } else{
        errorMessage = response.message;
      }
    } catch (e){
      errorMessage = e.toString();
    } finally{
      loading = false;
      notifyListeners();
    }
  }

  //logout
  Future<void> logout() async {
    activeUser = null;
    errorMessage = null;
    notifyListeners();
  }

}