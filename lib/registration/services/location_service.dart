import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService extends GetxService {
  // Observable variables
  final RxBool isLocationEnabled = false.obs;
  final RxBool hasLocationPermission = false.obs;
  final RxBool isGettingLocation = false.obs;
  final RxString currentLocation = ''.obs;
  final RxString errorMessage = ''.obs;

  // Location data
  Position? _currentPosition;
  List<Placemark>? _placemarks;

  @override
  void onInit() {
    super.onInit();
    _checkLocationStatus();
  }

  // Check location service status
  Future<void> _checkLocationStatus() async {
    try {
      // Check if location services are enabled
      isLocationEnabled.value = await Geolocator.isLocationServiceEnabled();

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      hasLocationPermission.value =
          permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      errorMessage.value = 'Error checking location status: ${e.toString()}';
    }
  }

  // Request location permission
  Future<bool> requestLocationPermission() async {
    try {
      // Request permission using permission_handler
      PermissionStatus status = await Permission.location.request();

      if (status.isGranted) {
        hasLocationPermission.value = true;
        return true;
      } else {
        errorMessage.value = 'Location permission denied';
        return false;
      }
    } catch (e) {
      errorMessage.value =
          'Error requesting location permission: ${e.toString()}';
      return false;
    }
  }

  // Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      isGettingLocation.value = true;
      errorMessage.value = '';

      // Check if location services are enabled
      if (!await Geolocator.isLocationServiceEnabled()) {
        errorMessage.value = 'Location services are disabled';
        isLocationEnabled.value = false;
        return null;
      }

      // Check and request permission if needed
      if (!hasLocationPermission.value) {
        final bool granted = await requestLocationPermission();
        if (!granted) {
          return null;
        }
      }

      // Get current position with timeout
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Get placemarks for the position
      await _getPlacemarks(_currentPosition!);

      return _currentPosition;
    } catch (e) {
      errorMessage.value = 'Error getting location: ${e.toString()}';
      return null;
    } finally {
      isGettingLocation.value = false;
    }
  }

  // Get placemarks for a position
  Future<void> _getPlacemarks(Position position) async {
    try {
      _placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (_placemarks != null && _placemarks!.isNotEmpty) {
        final Placemark placemark = _placemarks!.first;
        currentLocation.value = _formatLocation(placemark);
      }
    } catch (e) {
      print('Error getting placemarks: $e');
    }
  }

  // Format location string
  String _formatLocation(Placemark placemark) {
    List<String> parts = [];

    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      parts.add(placemark.locality!);
    }

    if (placemark.administrativeArea != null &&
        placemark.administrativeArea!.isNotEmpty) {
      parts.add(placemark.administrativeArea!);
    }

    if (placemark.country != null && placemark.country!.isNotEmpty) {
      parts.add(placemark.country!);
    }

    return parts.join(', ');
  }

  // Get location from coordinates
  Future<String?> getLocationFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        return _formatLocation(placemarks.first);
      }
      return null;
    } catch (e) {
      errorMessage.value =
          'Error getting location from coordinates: ${e.toString()}';
      return null;
    }
  }

  // Get coordinates from address
  Future<Position?> getCoordinatesFromAddress(String address) async {
    try {
      final List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        return Position(
          latitude: locations.first.latitude,
          longitude: locations.first.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }
      return null;
    } catch (e) {
      errorMessage.value =
          'Error getting coordinates from address: ${e.toString()}';
      return null;
    }
  }

  // Get nearby places (placeholder for future implementation)
  Future<List<Map<String, dynamic>>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required double radiusInMeters,
    String? type,
  }) async {
    try {
      // This is a placeholder implementation
      // In a real app, you would integrate with Google Places API or similar
      return [];
    } catch (e) {
      errorMessage.value = 'Error getting nearby places: ${e.toString()}';
      return [];
    }
  }

  // Calculate distance between two points
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Get last known location
  Future<Position?> getLastKnownLocation() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      errorMessage.value = 'Error getting last known location: ${e.toString()}';
      return null;
    }
  }

  // Check if location is within a certain radius
  bool isLocationWithinRadius({
    required double centerLatitude,
    required double centerLongitude,
    required double targetLatitude,
    required double targetLongitude,
    required double radiusInMeters,
  }) {
    final double distance = calculateDistance(
      centerLatitude,
      centerLongitude,
      targetLatitude,
      targetLongitude,
    );
    return distance <= radiusInMeters;
  }

  // Get current position data
  Position? get currentPosition => _currentPosition;

  // Get current placemarks
  List<Placemark>? get currentPlacemarks => _placemarks;

  // Get formatted current location
  String get formattedLocation => currentLocation.value;

  // Check if location is available
  bool get hasLocation => _currentPosition != null;

  // Get location accuracy
  double? get locationAccuracy => _currentPosition?.accuracy;

  // Get location timestamp
  DateTime? get locationTimestamp => _currentPosition?.timestamp;
}
