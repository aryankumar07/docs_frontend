import 'package:shared_preferences/shared_preferences.dart';

class LocalStrorage{
  void setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('x-auth-token', token);
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('x-auth-token');
    return token;
  }
}