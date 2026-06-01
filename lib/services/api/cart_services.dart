import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurants_system/constants.dart';

class CartServices {

  Future<http.Response> addToCart({
    required String restaurantId,
    required String itemId, 
    String? variantId, 
    String? description,
    required int quantity,
    required List<Map<String,dynamic>> modifierSelections, 
    required String token
  })async{
    final url = Uri.parse("${Constants.baseUrl}/cart");

    return http.post(
      url, 
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        "restaurant_id": restaurantId, 
        "item_id": itemId, 
        "variant_id": variantId,
        "description": description, 
        "quantity" : quantity, 
        "modifier_selections": modifierSelections,
      })
    );
  }
}