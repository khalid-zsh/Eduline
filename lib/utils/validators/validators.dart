// class Validators {
//   static String? validateRequired(String? value, String fieldName) {
//     if (value == null || value.trim().isEmpty) {
//       return '$fieldName is required';
//     }
//     return null;
//   }
//
//   static String? validateEmail(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Email is required';
//     }
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(value)) {
//       return 'Enter a valid email address';
//     }
//     return null;
//   }
//
//   static String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Password is required';
//     }
//     if (value.length < 6) {
//       return 'Password must be at least 6 characters';
//     }
//     return null;
//   }
//
//   static String? validatePrice(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Price is required';
//     }
//     final price = double.tryParse(value);
//     if (price == null || price <= 0) {
//       return 'Enter a valid price greater than 0';
//     }
//     return null;
//   }
//
//   static String? validateStock(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Stock is required';
//     }
//     final stock = int.tryParse(value);
//     if (stock == null || stock < 0) {
//       return 'Enter a valid stock quantity';
//     }
//     return null;
//   }
//
//   static String? validateDiscount(String? value) {
//     if (value == null || value.isEmpty) {
//       return null;
//     }
//     final discount = double.tryParse(value);
//     if (discount == null || discount < 0 || discount > 100) {
//       return 'Discount must be between 0 and 100';
//     }
//     return null;
//   }
// }