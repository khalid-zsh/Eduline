import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduline/features/product/models/product_model.dart';
import 'package:eduline/features/auth/models/user_model.dart';
import 'package:eduline/core/constants/api_constants.dart';

class RemoteDataSource {

  Future<UserModel> getCurrentUser() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.currentUser}'),
      headers: await _getAuthHeaders(),
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UserModel.fromJson(json['data'] ?? json);
    }
    throw Exception(_parseError(response, 'Failed to load user'));
  }

  Future<void> completeProfile({
    required String aboutUs,
    required String dateOfBirth,
    required String gender,
    File? image,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.completeProfile}'),
    );
    if (token != null) request.headers['Authorization'] = 'Bearer $token';
    request.fields['data'] = jsonEncode({
      'aboutUs': aboutUs,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
    });
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final streamed = await request.send().timeout(const Duration(seconds: 60));
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode != 200) {
      throw Exception(_parseError(response, 'Failed to complete profile'));
    }
  }


  Future<UserModel> updateProfile({
    required String fullName,
    required String aboutUs,
    required String dateOfBirth,
    required String gender,
    File? image,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.updateProfile}'),
    );
    if (token != null) request.headers['Authorization'] = 'Bearer $token';
    request.fields['data'] = jsonEncode({
      'fullName': fullName,
      'aboutUs': aboutUs,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
    });
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final streamed = await request.send().timeout(const Duration(seconds: 60));
    final response = await http.Response.fromStream(streamed);
    final decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return UserModel.fromJson(decoded['data'] ?? decoded);
    }
    throw Exception(decoded['message'] ?? 'Failed to update profile');
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  String _parseError(http.Response response, String fallback) {
    try {
      final body = jsonDecode(response.body);
      return body['message'] ?? body['error'] ?? fallback;
    } catch (_) {
      return fallback;
    }
  }

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    ).timeout(const Duration(seconds: 30));

    print("LOGIN STATUS: ${response.statusCode}");
    print("LOGIN BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final token = data['token'] ?? data['data']?['token'];
      if (token == null || token.toString().isEmpty) {
        throw Exception("Token missing in response");
      }
      return token.toString();
    }
    final message = data['message'] ??
        data['error'] ??
        data['errorSources']?[0]?['details'] ??
        'Login failed';
    throw Exception(message);
  }

  Future<void> register(String fullName, String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fullName': fullName, 'email': email, 'password': password}),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return;
    }
    throw Exception(_parseError(response, 'Registration failed'));
  }

  Future<void> forgotPassword(String email) async {
    final response = await http
        .post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.forgotPassword}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception(_parseError(response, 'Failed to send OTP'));
    }
  }

  Future<String> verifyOtp(String email, int otp) async {
    final response = await http
        .post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.verifyOtp}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
      }),
    )
        .timeout(const Duration(seconds: 30));
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['data']['token'];
      if (token == null || token.toString().isEmpty) {
        throw Exception('Verification token not found');
      }
      return token.toString();
    }
    throw Exception(
      _parseError(response, 'OTP verification failed'),
    );
  }

  Future<void> resendOtp(String email) async {
    final response = await http
        .post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.resendOtp}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      print(response);
      throw Exception(_parseError(response, 'Failed to resend OTP'));
    }
  }

  Future<void> resetPassword(String email, String newPassword, String verificationToken,) async {
    final response = await http
        .post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.resetPassword}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $verificationToken',
      },
      body: jsonEncode({'email': email, 'password': newPassword}),
    )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception(_parseError(response, 'Password reset failed'));
    }
  }

  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.products}'),
      headers: await _getAuthHeaders(),
    ).timeout(const Duration(seconds: 20));

    print('Products status: ${response.statusCode}');
    print('Products body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];
      return data.map((item) => ProductModel.fromJson(item)).toList();
    }
    throw Exception(_parseError(response, 'Failed to load products'));
  }

  Future<ProductModel> createProduct(ProductModel product, {File? imageFile}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.products}'),
    );
    if (token != null) request.headers['Authorization'] = 'Bearer $token';
    request.fields['data'] = jsonEncode(product.toJson());
    if (imageFile != null) {
      request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path));
    }

    final streamed = await request.send().timeout(const Duration(seconds: 60));
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ProductModel.fromJson((data['data'] ?? data) as Map<String, dynamic>);
    }
    throw Exception(_parseError(response, 'Failed to create product'));
  }

  Future<ProductModel> updateProduct(ProductModel product, {File? imageFile}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final request = http.MultipartRequest(
      'PUT',
      Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.products}/${product.id}'),
    );
    if (token != null) request.headers['Authorization'] = 'Bearer $token';
    request.fields['data'] = jsonEncode(product.toJson());
    if (imageFile != null) {
      request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path));
    }

    final streamed = await request.send().timeout(const Duration(seconds: 60));
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ProductModel.fromJson((data['data'] ?? data) as Map<String, dynamic>);
    }
    throw Exception(_parseError(response, 'Failed to update product'));
  }

  Future<void> deleteProduct(String productId) async {
    final response = await http
        .delete(
      Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.products}/$productId'),
      headers: await _getAuthHeaders(),
    )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(_parseError(response, 'Failed to delete product'));
    }
  }
}