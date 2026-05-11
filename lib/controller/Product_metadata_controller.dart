import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'product_controller.dart';


class ProductMetadataController extends GetxController {
  static ProductMetadataController get instance => Get.find();

  final categories = <String>[].obs;
  final brands = <String>[].obs;
  final tags = <String>[].obs;
  final colors = <String>[].obs;


  static const _defaultCategories = [
    'Electronics', 'Clothing', 'Books', 'Food & Beverage',
    'Sports', 'Home & Living', 'Toys', 'Beauty', 'Other',
  ];
  static const _defaultBrands = [
    'Apple', 'Samsung', 'Nike', 'Adidas', 'Sony',
    'LG', 'HP', 'Dell', 'Unbranded', 'Other',
  ];
  static const _defaultTags = [
    'New', 'Sale', 'Popular', 'Featured', 'Limited',
    'Trending', 'Best Seller', 'Clearance',
  ];
  static const _defaultColors = [
    'Red', 'Blue', 'Green', 'Black', 'White',
    'Yellow', 'Orange', 'Purple', 'Pink', 'Grey',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadFromPrefs();
    _syncFromProducts();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> _merge(String key, List<String> defaults) {
      final stored = prefs.getString(key);
      final custom = stored != null
          ? List<String>.from(jsonDecode(stored))
          : <String>[];
      return {...defaults, ...custom}.toList();
    }

    categories.value = _merge('custom_categories', _defaultCategories);
    brands.value = _merge('custom_brands', _defaultBrands);
    tags.value = _merge('custom_tags', _defaultTags);
    colors.value = _merge('custom_colors', _defaultColors);
  }


  void _syncFromProducts() {
    try {
      final pc = Get.find<ProductController>();
      ever(pc.products, (_) => _extractFromProducts(pc));
      if (pc.products.isNotEmpty) _extractFromProducts(pc);
    } catch (_) {
    }
  }

  void _extractFromProducts(ProductController pc) {
    final serverCats = pc.products
        .map((p) => p.category.trim())
        .where((c) => c.isNotEmpty)
        .toSet();
    final serverBrands = pc.products
        .map((p) => p.brand.trim())
        .where((b) => b.isNotEmpty)
        .toSet();
    final serverTags = pc.products
        .expand((p) => p.tags)
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toSet();
    final serverColors = pc.products
        .expand((p) => p.colors)
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .toSet();

    categories.value = {...categories, ...serverCats}.toList();
    brands.value = {...brands, ...serverBrands}.toList();
    tags.value = {...tags, ...serverTags}.toList();
    colors.value = {...colors, ...serverColors}.toList();
  }


  Future<void> addCategory(String value) => _addCustom(
      value, categories, 'custom_categories', _defaultCategories);

  Future<void> addBrand(String value) => _addCustom(
      value, brands, 'custom_brands', _defaultBrands);

  Future<void> addTag(String value) => _addCustom(
      value, tags, 'custom_tags', _defaultTags);

  Future<void> addColor(String value) => _addCustom(
      value, colors, 'custom_colors', _defaultColors);

  Future<void> _addCustom(
      String value,
      RxList<String> list,
      String prefKey,
      List<String> defaults,
      ) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    if (list.contains(trimmed)) return;

    list.add(trimmed);


    final custom = list.where((e) => !defaults.contains(e)).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefKey, jsonEncode(custom));
  }
}