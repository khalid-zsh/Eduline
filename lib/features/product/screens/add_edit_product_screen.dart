import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduline/core/theme/app_colors.dart';
import 'package:eduline/features/product/controllers/product_controller.dart';
import 'package:eduline/features/product/controllers/product_metadata_controller.dart';
import 'package:eduline/features/product/models/product_model.dart';
import 'package:eduline/features/product/widgets/product_dropdown_field.dart';
import 'package:eduline/shared/widgets/custom_text.dart';
import 'package:eduline/shared/widgets/custom_button.dart';
import 'package:eduline/shared/services/file_picker_service.dart';
import 'package:eduline/features/product/widgets/form_section.dart';
import 'package:eduline/features/product/widgets/product_form_text_field.dart';
import 'package:eduline/features/product/widgets/upload_photo_section.dart';
import 'package:eduline/core/extensions/context_extension.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductModel? product;
  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final ProductController _productController = Get.find();
  final ProductMetadataController _metaController = Get.find();

  late final bool _isEditMode;
  late final Map<String, TextEditingController> _controllers;
  String? _selectedFileName;
  String? _selectedFilePath;
  bool _isPickingFile = false;


  String? _selectedCategory;
  String? _selectedBrand;
  String? _selectedStockStatus;
  String? _selectedTag;
  String? _selectedStatus;
  String? _selectedColor;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.product != null;
    _controllers = {
      'productName': TextEditingController(),
      'description': TextEditingController(),
      'price': TextEditingController(),
      'discount': TextEditingController(),
      'weight': TextEditingController(),
      'dimensions': TextEditingController(),
    };
    if (_isEditMode) {
      _populateFieldsFromProduct(widget.product!);
    }
  }

  void _populateFieldsFromProduct(ProductModel product) {
    _controllers['productName']?.text = product.name;
    _controllers['description']?.text = product.description;
    _controllers['price']?.text = product.price.toString();
    _controllers['discount']?.text = product.discountPercent.toString();
    _controllers['weight']?.text = product.weight.toString();
    _controllers['dimensions']?.text = product.dimensions;

    _selectedCategory = product.category.isNotEmpty ? product.category : null;
    _selectedBrand = product.brand.isNotEmpty ? product.brand : null;
    _selectedStockStatus = product.stock > 0 ? 'In Stock' : 'Out of Stock';
    _selectedTag = product.tags.isNotEmpty ? product.tags.first : null;
    _selectedColor = product.colors.isNotEmpty ? product.colors.first : null;
    _selectedStatus = product.isActive ? 'Active' : 'Inactive';
  }

  @override
  void dispose() {
    for (var c in _controllers.values) c.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final name = _controllers['productName']!.text.trim();
    if (name.isEmpty) {
      _showSnackbar('Please enter product name', isError: true);
      return;
    }
    final priceText = _controllers['price']!.text.trim();
    final price = double.tryParse(priceText);
    if (price == null) {
      _showSnackbar('Invalid price', isError: true);
      return;
    }
    final discountText = _controllers['discount']!.text.trim();
    final discountPercent = double.tryParse(discountText) ?? 0.0;
    final weight = double.tryParse(_controllers['weight']!.text.trim()) ?? 0.0;
    final dimensions = _controllers['dimensions']!.text.trim();
    final description = _controllers['description']!.text.trim();


    int stock = 0;
    if (_selectedStockStatus == 'In Stock') {
      stock = 10;
    } else if (_selectedStockStatus == 'Limited') {
      stock = 3;
    }
    else {
      stock = 0;
    }

    final isActive = _selectedStatus == 'Active';
    final product = ProductModel(
      id: _isEditMode ? widget.product!.id : null,
      name: name,
      description: description,
      price: price,
      stock: stock,
      category: _selectedCategory ?? '',
      brand: _selectedBrand ?? '',
      isDiscounted: discountPercent > 0,
      discountPercent: discountPercent,
      tags: _selectedTag != null ? [_selectedTag!] : [],
      isActive: isActive,
      weight: weight,
      colors: _selectedColor != null ? [_selectedColor!] : [],
      dimensions: dimensions,
      imageUrl: _isEditMode ? widget.product!.imageUrl : '',
    );

    final imageFile = _selectedFilePath != null ? File(_selectedFilePath!) : null;

    if (_isEditMode) {
      await _productController.updateProduct(product, imageFile: imageFile);
    } else {
      await _productController.addProduct(product, imageFile: imageFile);
    }
  }

  void _showSnackbar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleChooseFile() async {
    setState(() => _isPickingFile = true);
    try {
      final result = await FilePickerService.pickFile();
      if (!mounted) return;
      if (result != null && result['isValid'] == true) {
        setState(() {
          _selectedFileName = result['fileName'];
          _selectedFilePath = result['filePath'];
          _isPickingFile = false;
        });
        _showSnackbar('File selected: ${result['fileName']}');
      } else {
        setState(() => _isPickingFile = false);
        _showSnackbar(result?['error'] ?? 'File pick failed', isError: true);
      }
    } catch (e) {
      setState(() => _isPickingFile = false);
      _showSnackbar('Error picking file: $e', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.titleText),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: CustomText(
          text: _isEditMode ? 'Edit Product' : 'Add New Product',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.titleText,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: context.w(5), vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UploadPhotoSection(onChooseFile: _handleChooseFile),
            SizedBox(height: 24),
            _buildProductForm(),
            SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: _buildFixedSubmitButton(),
    );
  }

  Widget _buildFixedSubmitButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: Colors.white,
      child: CustomButton(
        title: 'Submit',
        color: AppColors.primaryColor,
        width: double.infinity,
        height: 52,
        onTap: _handleSubmit,
      ),
    );
  }

  Widget _buildProductForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSection(
          label: 'Product Name',
          child: ProductFormTextField(
              controller: _controllers['productName']!,
              hintText: 'Type product name'),
        ),
        FormSection(
          label: 'Select Category',
          child: ProductFormDropdownField(
            hint: 'Select Categories',
            value: _selectedCategory,
            items: _metaController.categories.toList(), // ← .toList()
            onChanged: (val) => setState(() => _selectedCategory = val),
          ),
        ),
        FormSection(
          label: 'Description',
          child: ProductFormTextField(
              controller: _controllers['description']!,
              hintText: 'Type Description',
              maxLines: 5),
        ),
        FormSection(
          label: 'Price',
          child: ProductFormTextField(
              controller: _controllers['price']!,
              hintText: 'Type Price',
              keyboardType: TextInputType.number),
        ),
        FormSection(
          label: 'Brand',
          child: ProductFormDropdownField(
            hint: 'Select Brand',
            value: _selectedBrand,
            items: _metaController.brands.toList(), // ← .toList()
            onChanged: (val) => setState(() => _selectedBrand = val),
          ),
        ),
        FormSection(
          label: 'Discount %',
          child: ProductFormTextField(
              controller: _controllers['discount']!,
              hintText: '0',
              keyboardType: TextInputType.number),
        ),
        FormSection(
          label: 'Stock',
          child: ProductFormDropdownField(
            hint: 'Select Stock',
            value: _selectedStockStatus,
            items: const ['In Stock', 'Out of Stock', 'Limited'],
            onChanged: (val) => setState(() => _selectedStockStatus = val),
          ),
        ),
        FormSection(
          label: 'Tag',
          child: ProductFormDropdownField(
            hint: 'Select Tag',
            value: _selectedTag,
            items: _metaController.tags.toList(), // ← .toList()
            onChanged: (val) => setState(() => _selectedTag = val),
          ),
        ),
        FormSection(
          label: 'Status',
          child: ProductFormDropdownField(
            hint: 'Select Status',
            value: _selectedStatus,
            items: const ['Active', 'Inactive'],
            onChanged: (val) => setState(() => _selectedStatus = val),
          ),
        ),
        FormSection(
          label: 'Weight (kg)',
          child: ProductFormTextField(
              controller: _controllers['weight']!,
              hintText: '0',
              keyboardType: TextInputType.number),
        ),
        FormSection(
          label: 'Color',
          child: ProductFormDropdownField(
            hint: 'Select Color',
            value: _selectedColor,
            items: _metaController.colors.toList(), // ← .toList()
            onChanged: (val) => setState(() => _selectedColor = val),
          ),
        ),
        FormSection(
          label: 'Dimensions',
          child: ProductFormTextField(
              controller: _controllers['dimensions']!,
              hintText: 'e.g. 10x20x5 cm'),
        ),
      ],
    );
  }
}