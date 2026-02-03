import 'package:flutter/cupertino.dart';
import 'package:sportaqs/models/facility.dart';
import 'package:sportaqs/models/facility_response.dart';
import 'package:sportaqs/services/facility_service.dart';

class FacilityProvider extends ChangeNotifier{

  final FacilityService _facilityService = FacilityService();
  //final UserProvider userProvider;

  List<Facility> facilities = [];
  bool isLoading = false;
  String? errorMessage;

  //FacilityResponse(this.userProvider);

  Future<void> getFacilities() async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      //TODO
      final token = ''; //userProvider.activeUser?.rememberToken;

      // if(token == null){
      //   errorMessage = "No hay usuario autenticado";
      //   return;
      // }

      FacilitiesResponse response = await _facilityService.getFacilities(token);

      if(response.success == true){
        facilities = response.data;
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

  Future<void> getFacilityById(int id) async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final token = ''; //userProvider.activeUser?.rememberToken;
      
      if(token == null){
        errorMessage == "Usuario no autenticado";
        return;
      } 

      FacilitiesResponse response = await _facilityService.getFacilityById(id, token);

      if(response.success == true){
        facilities = response.data;
      }else {
        errorMessage == response.message;
      }

    }catch(e){
      errorMessage = "Error inesperado $e";
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFacility(String name, String openTime, String closeTime, String location) async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

            final token = ''; //userProvider.activeUser?.rememberToken;
      
      if(token == null){
        errorMessage == "Usuario no autenticado";
        return;
      } 

      FacilitiesResponse response = await _facilityService.addFacility(name, openTime, closeTime, location, token);

      if(response.success == true){
        facilities = response.data;
      }else {
        errorMessage == response.message;
      }

    }catch(e){
      errorMessage == "Error inesperado $e";
    }finally{
      
    }

  }

  Future<void> deleteFacility(int id) async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

            final token = ''; //userProvider.activeUser?.rememberToken;
      
      if(token == null){
        errorMessage == "Usuario no autenticado";
        return;
      } 

      FacilitiesResponse response = await _facilityService.deleteFacility(id, token);
      if(response.success == true){
        facilities = response.data;
      }else {
        errorMessage == response.message;
      }

    }catch(e){
      errorMessage == "Error inesperado $e";
    }finally{
      
    }
  }

  Future<void> deactivateFacility(int id) async {
    try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

            final token = ''; //userProvider.activeUser?.rememberToken;
      
      if(token == null){
        errorMessage == "Usuario no autenticado";
        return;
      } 

      FacilitiesResponse response = await _facilityService.deactivateFacility(id, token);

      if(response.success == true){
        facilities = response.data;
      }else {
        errorMessage == response.message;
      }

    }catch(e){
      errorMessage == "Error inesperado $e";
    }finally{
      
    }
  }

  Future<void> updateFacility(int id, String name, String openTime, String closeTime, String location) async {
        try{
      isLoading = true;
      errorMessage = null;
      notifyListeners();

            final token = ''; //userProvider.activeUser?.rememberToken;
      
      if(token == null){
        errorMessage == "Usuario no autenticado";
        return;
      } 

      FacilitiesResponse response = await _facilityService.updateFacility(id,name, openTime, closeTime, location, token);

      if(response.success == true){
        facilities = response.data;
      }else {
        errorMessage == response.message;
      }

    }catch(e){
      errorMessage == "Error inesperado $e";
    }finally{
      
    }
  }

}