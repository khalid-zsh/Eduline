class ProductFormData {
  String productName;
  String? selectedCategory;
  String description;
  String price;
  String? selectedBrand;
  String discount;
  String? selectedStoke;
  String? selectedTag;
  String? selectedStatus;
  String? selectedColor;
  String weight;
  String dimensions;

  ProductFormData({
    this.productName = '',
    this.selectedCategory,
    this.description = '',
    this.price = '',
    this.selectedBrand,
    this.discount = '',
    this.selectedStoke,
    this.selectedTag,
    this.selectedStatus,
    this.selectedColor,
    this.weight = '',
    this.dimensions = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'selectedCategory': selectedCategory,
      'description': description,
      'price': price,
      'selectedBrand': selectedBrand,
      'discount': discount,
      'selectedStoke': selectedStoke,
      'selectedTag': selectedTag,
      'selectedStatus': selectedStatus,
      'selectedColor': selectedColor,
      'weight': weight,
      'dimensions': dimensions,
    };
  }
}