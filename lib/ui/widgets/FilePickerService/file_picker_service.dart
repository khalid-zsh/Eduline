import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FilePickerService {
  static const List<String> supportedExtensions = ['jpg', 'jpeg', 'png', 'pdf'];
  static const int maxFileSize = 10 * 1024 * 1024;

  static Future<Map<String, dynamic>?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: supportedExtensions,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        final validation = _validateFile(file);
        if (!validation['isValid']) {
          return {
            'isValid': false,
            'error': validation['error'],
            'file': null,
          };
        }
        return {
          'isValid': true,
          'error': null,
          'file': file,
          'fileName': file.name,
          'filePath': file.path,
          'fileSize': file.size,
        };
      } else {
        return {
          'isValid': false,
          'error': 'No file selected',
          'file': null,
        };
      }
    } catch (e) {
      return {
        'isValid': false,
        'error': 'Error picking file: ${e.toString()}',
        'file': null,
      };
    }
  }

  static Map<String, dynamic> _validateFile(PlatformFile file) {
    if (file.size > maxFileSize) {
      return {
        'isValid': false,
        'error': 'File size exceeds 10 MB limit',
      };
    }
    final extension = _getFileExtension(file.name).toLowerCase();
    if (!supportedExtensions.contains(extension)) {
      return {
        'isValid': false,
        'error': 'Only JPG, PNG, PDF formats are supported',
      };
    }
    if (file.path != null && file.path!.isNotEmpty) {
      try {
        final fileExists = File(file.path!).existsSync();
        if (!fileExists) {
          return {
            'isValid': false,
            'error': 'File not found',
          };
        }
      } catch (e) {
        print('File existence check skipped: $e');
      }
    }
    return {
      'isValid': true,
      'error': null,
    };
  }
  static String _getFileExtension(String fileName) {
    final lastIndex = fileName.lastIndexOf('.');
    if (lastIndex == -1) {
      return '';
    }
    return fileName.substring(lastIndex + 1);
  }
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }
}