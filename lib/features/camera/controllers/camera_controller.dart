import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trip_mate/features/auths/services/auth_service.dart';

class TripMateCameraController extends ChangeNotifier {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  bool _isInitialized = false;
  bool _isCapturing = false;
  String? _lastCapturedImage;
  String? _errorMessage;
  XFile? _lastCapturedFile;

  // Getters
  CameraController? get cameraController => _cameraController;
  List<CameraDescription> get cameras => _cameras;
  int get selectedCameraIndex => _selectedCameraIndex;
  bool get isInitialized => _isInitialized;
  bool get isCapturing => _isCapturing;
  String? get lastCapturedImage => _lastCapturedImage;
  String? get errorMessage => _errorMessage;
  XFile? get lastCapturedFile => _lastCapturedFile;
  bool get hasCameras => _cameras.isNotEmpty;
  String? _token;
  // Initialize camera
  Future<void> initializeCamera() async {
    try {
      // Request camera permission
      final status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        _errorMessage = 'Camera permission denied';
        notifyListeners();
        return;
      }

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _errorMessage = 'No cameras available';
        notifyListeners();
        return;
      }

      // Initialize camera controller
      _cameraController = CameraController(
        _cameras[_selectedCameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      _isInitialized = true;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to initialize camera: ${e.toString()}';
      notifyListeners();
    }
  }

  // Switch camera
  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;

    try {
      await _cameraController?.dispose();
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
      
      _cameraController = CameraController(
        _cameras[_selectedCameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to switch camera: ${e.toString()}';
      notifyListeners();
    }
  }

  // Capture photo
  Future<void> capturePhoto() async {
  if (!_isInitialized || _cameraController == null) {
    _errorMessage = 'Camera not initialized';
    notifyListeners();
    return;
  }

  try {
    _isCapturing = true;
    notifyListeners();

    final XFile image = await _cameraController!.takePicture();
    _lastCapturedFile = image;
    _lastCapturedImage = image.path;
    _errorMessage = null;
    notifyListeners();

    print('📸 Photo captured: $_lastCapturedImage');

  } catch (e) {
    _isCapturing = false;
    _errorMessage = 'Failed to capture photo: ${e.toString()}';
    notifyListeners();
  }
}

Future<void> openGallery(BuildContext context) async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _lastCapturedFile = image;
      _lastCapturedImage = image.path;
      notifyListeners();
      print('🖼 Image selected from gallery: ${image.path}');

      context.go(
        '/image_view?imagePath=${Uri.encodeComponent(image.path)}',
      );
    }
  } catch (e) {
    _errorMessage = 'Failed to open gallery: ${e.toString()}';
    notifyListeners();
  }
}


// Future<void> openGallery() async {
//   try {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);

//     if (image != null) {
//       _lastCapturedFile = image;
//       _lastCapturedImage = image.path;
//       notifyListeners();
//       print('🖼 Image selected from gallery: ${image.path}');
//     }
//   } catch (e) {
//     _errorMessage = 'Failed to open gallery: ${e.toString()}';
//     notifyListeners();
//   }
// }

  // Open recent photos
  void openRecent() {
    print('Opening recent photos...');
    // Implement recent photos functionality
    // This could navigate to a gallery screen showing recent captures
  }

  // Toggle flash
  Future<void> toggleFlash() async {
    if (_cameraController == null || !_isInitialized) return;

    try {
      if (_cameraController!.value.flashMode == FlashMode.off) {
        await _cameraController!.setFlashMode(FlashMode.torch);
      } else {
        await _cameraController!.setFlashMode(FlashMode.off);
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to toggle flash: ${e.toString()}';
      notifyListeners();
    }
  }

  // Get current flash mode
  FlashMode get flashMode {
    return _cameraController?.value.flashMode ?? FlashMode.off;
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Stop analyzing
  void stopAnalyzing() {
    _isCapturing = false;
    notifyListeners();
  }

  // Reset camera state for new capture
  void resetCameraState() {
    _isCapturing = false;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
