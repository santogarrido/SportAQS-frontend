import 'package:flutter/cupertino.dart';
import 'package:sportaqs/models/court.dart';
import 'package:sportaqs/models/court_response.dart';
import 'package:sportaqs/services/court_service.dart';

class CourtProvider extends ChangeNotifier{

  final CourtService _courtService = CourtService();
  
  //TODO
  // final UserProvider userProvider;

  List<Court> courts = [];
  bool isLoading = false;
  String? errorMessage;

  //TODO 
  // CourtProvider(this.userProvider); 

  Future<void> getCourts(int id) async {

    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      //TODO
      final token = ''; //userProvider.activeUser?.rememberToken;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      CourtsResponse response = await _courtService.getCourts(id, token);

      if(response.success == true){
        courts = response.data;
      }else{
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();
    }

  }

  Future<void> getCourtById(int id) async {
        try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      //TODO
      final token = ''; //userProvider.activeUser?.rememberToken;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      CourtsResponse response = await _courtService.getCourtById(id, token);

      if(response.success == true){
        courts = response.data;
      }else{
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCourt(String name, String category, int bookingDuration, int facilityId) async {
        try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      //TODO
      final token = ''; //userProvider.activeUser?.rememberToken;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      CourtsResponse response = await _courtService.addCourt(name, category, bookingDuration, facilityId, token);

      if(response.success == true){
        courts = response.data;
      }else{
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCourt(int id, String name, String category, int bookingDuration, int facilityId) async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      //TODO
      final token = ''; //userProvider.activeUser?.rememberToken;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      CourtsResponse response = await _courtService.updateCourt(id, name, category, bookingDuration, facilityId, token)
      if(response.success == true){
        courts = response.data;
      }else{
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCourt(int id) async {
        try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      //TODO
      final token = ''; //userProvider.activeUser?.rememberToken;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      CourtsResponse response = await _courtService.deleteCourt(id, token);

      if(response.success == true){
        courts = response.data;
      }else{
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> activateCourt(int id) async {
        try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      //TODO
      final token = ''; //userProvider.activeUser?.rememberToken;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      CourtsResponse response = await _courtService.activateCourt(id, token);

      if(response.success == true){
        courts = response.data;
      }else{
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deactivateCourt(int id) async {
        try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      //TODO
      final token = ''; //userProvider.activeUser?.rememberToken;

      if(token == null){
        errorMessage = "No hay usuario autenticado";
        return;
      }

      CourtsResponse response = await _courtService.deactivateCourt(id, token);

      if(response.success == true){
        courts = response.data;
      }else{
        errorMessage = response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

}