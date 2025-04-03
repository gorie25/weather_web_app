import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Map<String, double>?> getCurrentLocation() async {
    try {
      print("🛰 Kiểm tra dịch vụ vị trí...");
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("⚠️ GPS chưa được bật.");
        return null;
      }

      print("🔍 Kiểm tra quyền truy cập...");
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        print("🚫 Quyền bị từ chối, yêu cầu cấp quyền...");
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("⚠️ Người dùng từ chối cấp quyền.");
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("❌ Quyền bị từ chối vĩnh viễn. Không thể yêu cầu lại.");
        return null;
      }

      print("📡 Lấy vị trí hiện tại...");
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print("✅ Lấy vị trí thành công: ${position.latitude}, ${position.longitude}");
      return {
        "latitude": position.latitude,
        "longitude": position.longitude,
      };
    } catch (e, stackTrace) {
      print("❗ Lỗi trong getCurrentLocation: $e");
      print(stackTrace);
      return null;
    }
  }
}
