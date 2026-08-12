import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurants_system/constants.dart';

class CartRemoteDataSource {

  Map<String, String> _headers(String token) => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    "Authorization": "Bearer $token",
  };


  Future<http.Response> addToCart({
    required String restaurantId,
    required String itemId,
    String? variantId,
    String? description,
    required int quantity,
    required List<Map<String, dynamic>> modifierSelections,
    required String token,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/cart");

    return http.post(
      url,
      headers:_headers(token),
      body: json.encode({
        "restaurant_id": restaurantId,
        "item_id": itemId,
        "variant_id": variantId,
        "description": description,
        "quantity": quantity,
        "modifier_selections": modifierSelections,
      }),
    );
  }

  // عند تعديل عنصر في السلة
  Future<http.Response> editAndAddToCart({
    required String restaurantId,
    required String itemId,
    required int cartId,
    String? variantId,
    String? description,
    required int quantity,
    required List<Map<String, dynamic>> modifierSelections,
    required String token,
  }) async {
    final url = Uri.parse(
      "${Constants.baseUrl}/cart/restaurant/edite_item/$cartId",
    );

    return http.post(
      url,
      headers:_headers(token),
      body: json.encode({
        "restaurant_id": restaurantId,
        "item_id": itemId,
        "variant_id": variantId,
        "description": description,
        "quantity": quantity,
        "modifier_selections": modifierSelections,
      }),
    );
  }

  Future<http.Response> index({required String token}) async {
    final url = Uri.parse("${Constants.baseUrl}/cart");
    return await http.get(
      url,
      headers:_headers(token),
    );
  }

  Future<http.Response> deleteCart({
    required String token,
    required int id,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/cart/$id");
    return await http.delete(
      url,
      headers:_headers(token),
    );
  }

  Future<http.Response> getRestaurantCart({
    required int restaurantId,
    required String token,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/cart/restaurant/$restaurantId");
    return await http.get(
      url,
      headers:_headers(token),
    );
  }

  Future<http.Response> deleteItem({
    required String token,
    required int itemId,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/cart/restaurant/$itemId");

    return await http.delete(
      url,
      headers: _headers(token),
    );
  }

  Future<http.Response> editeItemQuantity({
    required String token,
    required List<Map<String, dynamic>> items,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/cart/restaurant/edite_item_quantity");
    return await http.post(
      url,
      headers:_headers(token),
      body: json.encode({"items": items}),
    );
  }
}
