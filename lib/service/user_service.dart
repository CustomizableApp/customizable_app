import 'package:customizable_app/core/app_contants.dart';
import 'package:dio/dio.dart';

class UserService {
  static final UserService _instance = UserService._init();
  UserService._init();

  static UserService get instance {
    return _instance;
  }

  factory UserService() {
    return _instance;
  }

  Future<Response> getUsers() {
    Future<Response> response = Dio().get(AppConstants.apiUrl + "/getUser");
    return response;
  }

  Future<Response> editCanChange(String userID, String foodName) {
    Map<String, dynamic> data = {"userid": userID, "name": foodName};
    Future<Response> response =
        Dio().put(AppConstants.apiUrl + "/editCanChangePut", data: data);
    return response;
  }

  Future<Response> getFoodNames() {
    Future<Response> response =
        Dio().get(AppConstants.apiUrl + "/getFoodNames");
    return response;
  }

  Future<Response> deleteUser(String name) {
    Map<String, dynamic> data = {"name": name};
    Future<Response> response =
        Dio().delete(AppConstants.apiUrl + "/deleteUserByName", data: data);
    return response;
  }

  Future<Response> updateUser(String name, String newName) {
    Map<String, dynamic> data = {"name": name, "newName": newName};
    Future<Response> response =
        Dio().put(AppConstants.apiUrl + "/updateNameByName", data: data);
    return response;
  }
}
