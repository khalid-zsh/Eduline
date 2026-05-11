import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/repository/product_repository.dart';
import '../data/data_source/remote_data_source.dart';
import '../data/services/local_storage_service.dart';
import '../data/repository/product_repository_impl.dart';
import '../model/product_model.dart';

class ProductController extends GetxController {
  late final ProductRepository _repository;

  final products = <ProductModel>[].obs;
  final isLoading = false.obs;
  final isOffline = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final isSyncing = false.obs;

  StreamSubscription? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _repository = ProductRepositoryImpl(
      remoteDataSource: RemoteDataSource(),
      localDataSource: LocalDataSource(),
    );
    fetchProducts();
    _listenToConnectivity();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  void _listenToConnectivity() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) async {
          final online = results.any((r) => r != ConnectivityResult.none);
          if (online && isOffline.value) {
            isOffline.value = false;
            await _syncAndRefresh();
          } else if (!online) {
            isOffline.value = true;
          }
        });
  }

  Future<void> _syncAndRefresh() async {
    try {
      isSyncing.value = true;
      await _repository.syncPendingOperations();
      await fetchProducts();
      Get.snackbar(
        'Back Online',
        'Your offline changes have been synced.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green[100],
      );
    } catch (e) {
      debugPrint('Sync error: $e');
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final productList = await _repository.getProducts();
      products.assignAll(productList);

      isOffline.value = !(await _repository.hasInternetConnection());

      if (isOffline.value && products.isEmpty) {
        errorMessage.value =
        'No internet connection and no cached data available.';
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load products: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProduct(ProductModel product, {File? imageFile}) async {
    try {
      isLoading.value = true;
      final newProduct =
      await _repository.createProduct(product, imageFile: imageFile);
      products.insert(0, newProduct);
      Get.back(result: true);
      Get.snackbar(
        isOffline.value ? 'Saved Offline' : 'Success',
        isOffline.value
            ? 'Product saved locally. Will sync when online.'
            : 'Product added successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add product: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(ProductModel product, {File? imageFile}) async {
    try {
      isLoading.value = true;
      final updatedProduct =
      await _repository.updateProduct(product, imageFile: imageFile);
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) products[index] = updatedProduct;
      Get.back(result: true);
      Get.snackbar(
        isOffline.value ? 'Saved Offline' : 'Success',
        isOffline.value
            ? 'Changes saved locally. Will sync when online.'
            : 'Product updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update product: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String id, String name) async {
    try {
      isLoading.value = true;
      await _repository.deleteProduct(id);
      products.removeWhere((p) => p.id == id);
      Get.snackbar(
        isOffline.value ? 'Deleted Offline' : 'Success',
        isOffline.value
            ? '$name removed locally. Will sync when online.'
            : '$name deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete product: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void refreshProducts() => fetchProducts();

  ProductModel? getProductById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}