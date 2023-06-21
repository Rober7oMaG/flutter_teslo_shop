abstract class CameraGalleryService {
  Future<String?> takePhoto();
  Future<String?> selectImage();
  // Future<List<String>> selectMultiplePhotos();
}