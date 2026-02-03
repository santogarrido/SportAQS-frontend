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

  List<Court> getCourts() async {

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

}