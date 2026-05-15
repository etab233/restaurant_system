import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/services/api/analyze_meal_services.dart';

class AnalyzeMealState {
  final String name;
  final String description;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String confidence;
  final bool success;
  final String message;

  const AnalyzeMealState({
    this.name = "",
    this.description = "",
    this.calories = 0.0,
    this.protein = 0.0,
    this.carbs = 0.0,
    this.fat = 0.0,
    this.confidence = "",
    this.success=false, 
    this.message= ""
  });

  AnalyzeMealState copyWith({
    String? name,
    String? description,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    String? confidence,
    bool? success, 
    String? message
  }) {
    return AnalyzeMealState(
      name: name ?? this.name,
      description: description ?? this.description,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      confidence: confidence ?? this.confidence,
      success: success ?? this.success, 
      message: message ?? this.message
    );
  }
}

class AnalyzeMealNotifier extends Notifier<AnalyzeMealState> {
  late final AnalyzeMealServices _analyzeMealServices;

  @override
  AnalyzeMealState build() {
    _analyzeMealServices = AnalyzeMealServices();
    return const AnalyzeMealState();
  }

  Future<void> analyze({
    required String imagePath,
    String? description,
    required String token,
  })async {
    try{
      final response = await _analyzeMealServices.analyze(imagePath: imagePath, token: token, description: description);

      if(response.containsKey("error")){
        // حالة خطأ 
        state = state.copyWith(success: false, message: response['error']);
      }
      else{
        // تم المسح بنجاح
        state = state.copyWith(
          name       : response["dish_name"], 
          description: response["description"], 
          calories   : (response["calories"] as num).toDouble(), 
          protein    : (response["protein"] as num).toDouble(), 
          carbs      : (response["carbs"] as num).toDouble(), 
          fat        : (response["fat"] as num).toDouble(), 
          confidence : response["confidence"], 
          success    : true, 
          message    : "Operation successful"
        );
      }
    } catch(e){
      state = state.copyWith(
        success: false, 
        message: "Something went wrong. Please try again.",
      );
    }
  }
}
