import 'package:location/location.dart';

class LocationService {
  Future<String> getCurrentLocation() async {
    var location = Location();
    try {
      var locationData = await location.getLocation();
      return '${locationData.latitude}, ${locationData.longitude}';
    } catch (e) {
      return 'Could not determine location';
    }
  }
}