import 'package:customizable_app/core/app_contants.dart';
import 'package:customizable_app/service/auth_service.dart';
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
    Future<Response> response = Dio().get(AppConstants.apiUrl + "/getUsers");
    return response;
  }
  Future<Response> getAllUsers() {
    Map<String, dynamic> data = {"UserID": AuthenticationService.instance.getUserId()};
    Future<Response> response = Dio().post(AppConstants.apiUrl + "/GetAllUsers",data:data);
    return response;
  }

  Future<Response> getFoodNameByCanChangeID(String userID) {
    Map<String, dynamic> data = {"userid": userID};
    Future<Response> response = Dio().put(AppConstants.apiUrl + "/getFoodNameByCanChangeID", data:data);
    return response;
  }

  Future<Response> getFoodByUserID(String userID) {
    Map<String, dynamic> data = {"userid": userID};
    Future<Response> response = Dio().put(AppConstants.apiUrl + "/getFoodByUserID", data:data);
    return response;
  }

  Future<Response> editCanChange(String userID, String foodName) {
    Map<String, dynamic> data = {"userid": userID, "name": foodName};
    Future<Response> response =
        Dio().put(AppConstants.apiUrl + "/editCanChangePut", data: data);
    return response;
  }

   Future<Response> assignCourrier(String userID, int cargoID) {
    Map<String, dynamic> data = {"CourrierID": userID, "CargoID": cargoID,"AssignerID":AuthenticationService.instance.getUserId()};
    Future<Response> response =
        Dio().put(AppConstants.apiUrl + "/AssignCourrier", data: data);
    return response;
  }
  Future<Response> removeCourrier(int cargoID) {
    Map<String, dynamic> data = {"CargoID": cargoID};
    Future<Response> response =
        Dio().put(AppConstants.apiUrl + "/RemoveCourrier", data: data);
    return response;
  }

  Future<Response> editFoodUserID(String userID, String foodName) {
    Map<String, dynamic> data = {"userid": userID, "foodName": foodName};
    Future<Response> response =
        Dio().post(AppConstants.apiUrl + "/editFoodUserID", data: data);
    return response;
  }

  Future<Response> getFoodNames() {
    Future<Response> response =
        Dio().get(AppConstants.apiUrl + "/getFoodNames");
    return response;
  }

  Future<Response> getNonAssignedCargo() {
    Future<Response> response =
        Dio().get(AppConstants.apiUrl + "/GetNonAssignedCargo");
    return response;
  }

  Future<Response> deleteAssigner(String assignerID) {
    Map<String, dynamic> data = {"AssignerID": assignerID};
    Future<Response> response =
        Dio().delete(AppConstants.apiUrl + "/DeleteAssigner", data: data);
    return response;
  }

  Future<Response> updateUser(String name, String newName) {
    Map<String, dynamic> data = {"name": name, "newName": newName};
    Future<Response> response =
        Dio().put(AppConstants.apiUrl + "/updateNameByName", data: data);
    return response;
  }

  createNewCargo(String? address, String? content, String receiverID) {
    Map<String, dynamic> data = {
      "Address": address,
      "Content": content,
      "ReceiverID": receiverID,
      "SenderID": AuthenticationService.instance.getUserId(),
    };
    try {
      Dio().post(AppConstants.apiUrl + "/InsertCargo", data: data);
    } catch (e) {
      print(e);
    }
  }
  createNewUser(String? name, String? surname, String id) {
    Map<String, dynamic> data = {
      "Name": name,
      "Surname": surname,
      "UserID": id,
    };
    try {
      Dio().post(AppConstants.apiUrl + "/CreateNewUser", data: data);
    } catch (e) {
      print(e);
    }
  }
  createNewAssigner(String id) {
    Map<String, dynamic> data = {
      "AssignerID": id,
    };
    try {
      Dio().post(AppConstants.apiUrl + "/InsertAssigner", data: data);
    } catch (e) {
      print(e);
    }
  }
}
