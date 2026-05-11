import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../model/product_model.dart';

class LocalDataSource {
  static Database? _database;
  static const String tableName = 'products';
  static const String pendingOpsTable = 'pending_operations';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'product_app.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _createProductsTable(db);
        await _createPendingOpsTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createPendingOpsTable(db);
        }
      },
    );
  }

  Future<void> _createProductsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        stock INTEGER NOT NULL,
        category TEXT,
        brand TEXT,
        isDiscounted INTEGER,
        discountPercent REAL,
        tags TEXT,
        isActive INTEGER,
        weight REAL,
        colors TEXT,
        dimensions TEXT,
        imageUrl TEXT,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');
  }

  Future<void> _createPendingOpsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $pendingOpsTable (
        localId TEXT PRIMARY KEY,
        operation TEXT NOT NULL,
        productData TEXT NOT NULL,
        imageFilePath TEXT,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  Future<void> cacheProducts(List<ProductModel> products) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(tableName);
      for (var product in products) {
        await txn.insert(tableName, _productToMap(product));
      }
    });
  }

  Future<List<ProductModel>> getCachedProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map(_mapToProduct).toList();
  }

  Future<void> cacheProduct(ProductModel product) async {
    final db = await database;
    await db.insert(
      tableName,
      _productToMap(product),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCachedProduct(String id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearCache() async {
    final db = await database;
    await db.delete(tableName);
  }

  Future<void> addPendingOperation(
      String localId,
      String operation,
      ProductModel product, {
        String? imageFilePath,
      }) async {
    final db = await database;
    final data = product.toJson();
    if (product.id != null) data['id'] = product.id;

    await db.insert(
      pendingOpsTable,
      {
        'localId': localId,
        'operation': operation,
        'productData': jsonEncode(data),
        'imageFilePath': imageFilePath,
        'timestamp': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getPendingOperations() async {
    final db = await database;
    return db.query(pendingOpsTable, orderBy: 'timestamp ASC');
  }

  Future<void> removePendingOperation(String localId) async {
    final db = await database;
    await db.delete(pendingOpsTable, where: 'localId = ?', whereArgs: [localId]);
  }

  Future<void> clearPendingOperations() async {
    final db = await database;
    await db.delete(pendingOpsTable);
  }

  Map<String, dynamic> _productToMap(ProductModel product) {
    return {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'stock': product.stock,
      'category': product.category,
      'brand': product.brand,
      'isDiscounted': product.isDiscounted ? 1 : 0,
      'discountPercent': product.discountPercent,
      'tags': product.tags.join(','),
      'isActive': product.isActive ? 1 : 0,
      'weight': product.weight,
      'colors': product.colors.join(','),
      'dimensions': product.dimensions,
      'imageUrl': product.imageUrl,
      'createdAt': product.createdAt?.toIso8601String(),
      'updatedAt': product.updatedAt?.toIso8601String(),
    };
  }

  ProductModel _mapToProduct(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
      price: map['price'],
      stock: map['stock'],
      category: map['category'] ?? '',
      brand: map['brand'] ?? '',
      isDiscounted: map['isDiscounted'] == 1,
      discountPercent: map['discountPercent'] ?? 0.0,
      tags: _splitSafe(map['tags']),
      isActive: map['isActive'] == 1,
      weight: map['weight'] ?? 0.0,
      colors: _splitSafe(map['colors']),
      dimensions: map['dimensions'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt']) : null,
    );
  }

  List<String> _splitSafe(dynamic value) {
    if (value == null || value.toString().isEmpty) return [];
    return value.toString().split(',').where((e) => e.isNotEmpty).toList();
  }
}