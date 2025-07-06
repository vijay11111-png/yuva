import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  // Request location permission
  Future<bool> requestLocationPermission() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check permission status
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      return true;
    } catch (e) {
      throw Exception('Failed to request location permission: $e');
    }
  }

  // Get current location
  Future<Position> getCurrentLocation() async {
    try {
      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        throw Exception('Location permission denied');
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  // Get address from coordinates
  Future<Map<String, String>> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return {
          'street': place.thoroughfare ?? place.street ?? '',
          'city': place.locality ?? place.administrativeArea ?? '',
          'state': place.administrativeArea ?? '',
          'country': place.country ?? '',
          'postalCode': place.postalCode ?? '',
        };
      }

      return {
        'street': '',
        'city': '',
        'state': '',
        'country': '',
        'postalCode': '',
      };
    } catch (e) {
      throw Exception('Failed to get address from coordinates: $e');
    }
  }

  // Get coordinates from address
  Future<Map<String, double>> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        Location location = locations[0];
        return {'latitude': location.latitude, 'longitude': location.longitude};
      }

      throw Exception('No coordinates found for the given address');
    } catch (e) {
      throw Exception('Failed to get coordinates from address: $e');
    }
  }

  // Get current location with address
  Future<Map<String, dynamic>> getCurrentLocationWithAddress() async {
    try {
      Position position = await getCurrentLocation();
      Map<String, String> address = await getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'street': address['street'] ?? '',
        'city': address['city'] ?? '',
        'state': address['state'] ?? '',
        'country': address['country'] ?? '',
        'postalCode': address['postalCode'] ?? '',
      };
    } catch (e) {
      throw Exception('Failed to get current location with address: $e');
    }
  }
}
