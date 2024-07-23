import 'package:jwt_decode/jwt_decode.dart';

bool isTokenExpired(String token) {
  try {
    DateTime expiryDate = Jwt.getExpiryDate(token)!;
    return expiryDate.isBefore(DateTime.now());
  } catch (e) {
    return true;
  }
}
