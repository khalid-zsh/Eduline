import 'dart:io';
import 'package:eduline/features/product/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> createProduct(ProductModel product, {File? imageFile});
  Future<ProductModel> updateProduct(ProductModel product, {File? imageFile});
  Future<void> deleteProduct(String id);
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getCachedProducts();
  Future<bool> hasInternetConnection();
  Future<void> syncPendingOperations();
}