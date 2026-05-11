import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import '../../model/product_model.dart';
import '../data_source/remote_data_source.dart';
import '../services/local_storage_service.dart';
import 'product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });


  @override
  Future<List<ProductModel>> getProducts() async {
    if (await hasInternetConnection()) {
      try {
        final products = await remoteDataSource.getProducts();
        await localDataSource.cacheProducts(products);
        return products;
      } catch (e) {
        return localDataSource.getCachedProducts();
      }
    }
    return localDataSource.getCachedProducts();
  }


  @override
  Future<ProductModel> createProduct(ProductModel product, {File? imageFile}) async {
    if (await hasInternetConnection()) {
      final newProduct =
      await remoteDataSource.createProduct(product, imageFile: imageFile);
      await localDataSource.cacheProduct(newProduct);
      return newProduct;
    }

    // One time ID for local
    final tempId = 'local_${DateTime.now().millisecondsSinceEpoch}';
    final localProduct = product.copyWith(id: tempId);
    await localDataSource.cacheProduct(localProduct);
    await localDataSource.addPendingOperation(
      tempId,
      'create',
      localProduct,
      imageFilePath: imageFile?.path,
    );
    return localProduct;
  }


  @override
  Future<ProductModel> updateProduct(ProductModel product, {File? imageFile}) async {
    if (await hasInternetConnection()) {
      final updatedProduct =
      await remoteDataSource.updateProduct(product, imageFile: imageFile);
      await localDataSource.cacheProduct(updatedProduct);
      return updatedProduct;
    }

    //Ofline Update
    await localDataSource.cacheProduct(product);
    final opId = 'update_${product.id}_${DateTime.now().millisecondsSinceEpoch}';
    await localDataSource.addPendingOperation(
      opId,
      'update',
      product,
      imageFilePath: imageFile?.path,
    );
    return product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    if (await hasInternetConnection()) {
      await remoteDataSource.deleteProduct(id);
      await localDataSource.deleteCachedProduct(id);
      return;
    }

    //Delete form local
    await localDataSource.deleteCachedProduct(id);

    // Delete form server
    if (!id.startsWith('local_')) {
      final opId = 'delete_${id}_${DateTime.now().millisecondsSinceEpoch}';
      final placeholder = ProductModel(
        id: id,
        name: '',
        description: '',
        price: 0,
        stock: 0,
        category: '',
        brand: '',
        isDiscounted: false,
        discountPercent: 0,
        tags: [],
        isActive: false,
        weight: 0,
        colors: [],
        dimensions: '',
        imageUrl: '',
      );
      await localDataSource.addPendingOperation(opId, 'delete', placeholder);
    }
  }

  //Pending data
  @override
  Future<void> syncPendingOperations() async {
    if (!await hasInternetConnection()) return;

    final pending = await localDataSource.getPendingOperations();
    if (pending.isEmpty) return;
    debugPrint('Syncing ${pending.length} pending operation(s)…');
    for (final op in pending) {
      try {
        final operation = op['operation'] as String;
        final localId = op['localId'] as String;
        final productData =
        jsonDecode(op['productData'] as String) as Map<String, dynamic>;
        final imageFilePath = op['imageFilePath'] as String?;
        final imageFile =
        (imageFilePath != null && File(imageFilePath).existsSync()) ? File(imageFilePath) : null;
        final product = ProductModel.fromJson(productData);
        switch (operation) {
          case 'create':
            final serverProduct = await remoteDataSource.createProduct(
              product,
              imageFile: imageFile,
            );
            await localDataSource.deleteCachedProduct(localId);
            await localDataSource.cacheProduct(serverProduct);
          case 'update':
            final serverProduct = await remoteDataSource.updateProduct(
              product,
              imageFile: imageFile,
            );
            await localDataSource.cacheProduct(serverProduct);
          case 'delete':
            final productId = product.id;
            if (productId != null && productId.isNotEmpty) {
              await remoteDataSource.deleteProduct(productId);
            }
        }
        await localDataSource.removePendingOperation(localId);
        debugPrint('Synced op "$operation" (localId: $localId)');
      } catch (e) {
        debugPrint('Sync failed for op ${op['localId']}: $e');
      }
    }
  }

  @override
  Future<List<ProductModel>> getCachedProducts() =>
      localDataSource.getCachedProducts();

  @override
  Future<void> cacheProducts(List<ProductModel> products) =>
      localDataSource.cacheProducts(products);

//Internet
  @override
  Future<bool> hasInternetConnection() async {
    final result = await Connectivity().checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }
}