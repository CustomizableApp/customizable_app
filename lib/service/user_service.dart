import 'package:dio/dio.dart';

class UserService {
  final apiUrl = "http://ec2-18-185-69-34.eu-central-1.compute.amazonaws.com:8080/api/rest";

  static final UserService _instance = UserService._init();
  UserService._init();

  static UserService get instance {
    return _instance;
  }

  factory UserService() {
    return _instance;
  }

  Future<Response> getUsers() {
    Future<Response> response = Dio().get(apiUrl + "/getUser");
    return response;
  }

  Future<Response> editCanChange(String userID, String foodName) {
    Map<String, dynamic> data = {"userid": userID, "name": foodName};
    Future<Response> response = Dio().put(apiUrl + "/editCanChangePut", data: data);
    return response;
  }

  Future<Response> deleteUser(String name) {
    Map<String, dynamic> data = {"name": name};
    Future<Response> response =
        Dio().delete(apiUrl + "/deleteUserByName", data: data);
    return response;
  }

  Future<Response> updateUser(String name, String newName) {
    Map<String, dynamic> data = {"name": name, "newName": newName};
    Future<Response> response =
        Dio().put(apiUrl + "/updateNameByName", data: data);
    return response;
  }
}