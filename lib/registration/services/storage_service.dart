import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

class StorageService extends GetxService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Observable variables
  final RxBool isUploading = false.obs;
  final RxDouble uploadProgress = 0.0.obs;
  final RxString errorMessage = ''.obs;

  // Maximum file size (5MB)
  static const int maxFileSize = 5 * 1024 * 1024;

  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Upload image to Firebase Storage
  Future<String?> uploadImage(
    File imageFile, {
    required String userId,
    required String type, // 'id_card' or 'profile_picture'
    bool compress = true,
  }) async {
    try {
      isUploading.value = true;
      uploadProgress.value = 0.0;
      errorMessage.value = '';

      // Validate file
      if (!await _validateImageFile(imageFile)) {
        return null;
      }

      // Compress image if needed
      File processedFile = imageFile;
      if (compress) {
        processedFile = await _compressImage(imageFile);
      }

      // Generate unique filename
      final String fileName = _generateFileName(type);
      final String storagePath = '$type/$userId/$fileName';

      // Create storage reference
      final Reference storageRef = _storage.ref().child(storagePath);

      // Upload with retry logic
      String? downloadUrl;
      int retryCount = 0;

      while (retryCount < maxRetries) {
        try {
          final UploadTask uploadTask = storageRef.putFile(
            processedFile,
            SettableMetadata(
              contentType: 'image/jpeg',
              customMetadata: {
                'userId': userId,
                'type': type,
                'uploadedAt': DateTime.now().toIso8601String(),
              },
            ),
          );

          // Monitor upload progress
          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            uploadProgress.value =
                snapshot.bytesTransferred / snapshot.totalBytes;
          });

          // Wait for upload to complete
          final TaskSnapshot snapshot = await uploadTask;
          downloadUrl = await snapshot.ref.getDownloadURL();
          break;
        } catch (e) {
          retryCount++;
          if (retryCount >= maxRetries) {
            throw Exception('Upload failed after $maxRetries attempts: $e');
          }

          // Wait before retrying
          await Future.delayed(retryDelay * retryCount);
        }
      }

      uploadProgress.value = 1.0;
      return downloadUrl;
    } catch (e) {
      errorMessage.value = 'Failed to upload image: ${e.toString()}';
      return null;
    } finally {
      isUploading.value = false;
    }
  }

  // Delete image from Firebase Storage
  Future<bool> deleteImage(String imageUrl) async {
    try {
      final Reference storageRef = _storage.refFromURL(imageUrl);
      await storageRef.delete();
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to delete image: ${e.toString()}';
      return false;
    }
  }

  // Validate image file
  Future<bool> _validateImageFile(File file) async {
    try {
      // Check if file exists
      if (!await file.exists()) {
        errorMessage.value = 'Image file does not exist';
        return false;
      }

      // Check file size
      final int fileSize = await file.length();
      if (fileSize > maxFileSize) {
        errorMessage.value = 'Image file is too large (max 5MB)';
        return false;
      }

      // Check file extension
      final String extension = path.extension(file.path).toLowerCase();
      if (!['.jpg', '.jpeg', '.png'].contains(extension)) {
        errorMessage.value =
            'Invalid image format (only JPG, JPEG, PNG allowed)';
        return false;
      }

      // Try to decode image to verify it's valid
      final Uint8List bytes = await file.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        errorMessage.value = 'Invalid image file';
        return false;
      }

      return true;
    } catch (e) {
      errorMessage.value = 'Error validating image: ${e.toString()}';
      return false;
    }
  }

  // Compress image
  Future<File> _compressImage(File file) async {
    try {
      // Read image bytes
      final Uint8List bytes = await file.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Calculate new dimensions (maintain aspect ratio)
      int width = image.width;
      int height = image.height;

      // If image is too large, resize it
      const int maxDimension = 1024;
      if (width > maxDimension || height > maxDimension) {
        if (width > height) {
          height = (height * maxDimension / width).round();
          width = maxDimension;
        } else {
          width = (width * maxDimension / height).round();
          height = maxDimension;
        }
      }

      // Resize image
      final img.Image resizedImage = img.copyResize(
        image,
        width: width,
        height: height,
      );

      // Encode as JPEG with quality 85
      final Uint8List compressedBytes = img.encodeJpg(
        resizedImage,
        quality: 85,
      );

      // Create temporary file
      final String tempPath = '${file.path}_compressed.jpg';
      final File compressedFile = File(tempPath);
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      // If compression fails, return original file
      print('Image compression failed: $e');
      return file;
    }
  }

  // Generate unique filename
  String _generateFileName(String type) {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String random =
        (1000 + (DateTime.now().microsecond % 9000)).toString();
    return '${type}_$timestamp$random.jpg';
  }

  // Get file size in human readable format
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // Upload multiple images
  Future<List<String>> uploadMultipleImages(
    List<File> imageFiles, {
    required String userId,
    required String type,
  }) async {
    final List<String> uploadedUrls = [];

    for (int i = 0; i < imageFiles.length; i++) {
      final String? url = await uploadImage(
        imageFiles[i],
        userId: userId,
        type: type,
      );

      if (url != null) {
        uploadedUrls.add(url);
      }
    }

    return uploadedUrls;
  }

  // Get storage usage for user
  Future<Map<String, dynamic>> getUserStorageUsage(String userId) async {
    try {
      final ListResult result = await _storage.ref().listAll();
      int totalSize = 0;
      int fileCount = 0;

      for (final Reference ref in result.items) {
        if (ref.fullPath.contains(userId)) {
          final FullMetadata metadata = await ref.getMetadata();
          totalSize += metadata.size ?? 0;
          fileCount++;
        }
      }

      return {
        'totalSize': totalSize,
        'fileCount': fileCount,
        'formattedSize': _formatFileSize(totalSize),
      };
    } catch (e) {
      errorMessage.value = 'Failed to get storage usage: ${e.toString()}';
      return {'totalSize': 0, 'fileCount': 0, 'formattedSize': '0 B'};
    }
  }
}
