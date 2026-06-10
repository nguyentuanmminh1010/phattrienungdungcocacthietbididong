import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '/services/auth_service.dart';
import 'package:provider/provider.dart';
import '/config/api_config.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['token'] != null) await context.read<AuthService>().saveToken(data['token']);
        _showMessage('Đăng ký thành công!');
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      } else {
        _showMessage('Đăng ký thất bại: ${_getErrorMessage(response.bodyBytes)}');
      }
    } catch (e) {
      _showMessage('Lỗi kết nối: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _handleGoogleRegister() async {
    setState(() => _isLoading = true);
    try {
      await GoogleSignIn.instance.disconnect(); // Disconnect hoàn toàn để ép buộc Google hiện bảng chọn lại
      final GoogleSignInAccount account = await GoogleSignIn.instance.authenticate();
      final GoogleSignInAuthentication auth = account.authentication;
      if (auth.idToken != null) {
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/api/auth/google'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'token': auth.idToken, 'action': 'REGISTER'}),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(utf8.decode(response.bodyBytes));
          if (data['token'] != null) await context.read<AuthService>().saveToken(data['token']);
          _showMessage('Đăng ký thành công! Vui lòng đăng nhập.');
          if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        } else {
          String errorMsg = _getErrorMessage(response.bodyBytes);
          if (errorMsg.contains('đã tồn tại') || errorMsg.contains('đã có')) {
            _showMessage('Tài khoản đã tồn tại! Vui lòng đăng nhập.');
            if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
          } else {
            _showMessage(errorMsg);
          }
        }
      }
        } catch (e) {
      _showMessage('Lỗi Google Sign Up: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _handleFacebookRegister() async {
    setState(() => _isLoading = true);
    try {
      await FacebookAuth.instance.logOut(); // Bắt buộc đăng xuất cũ để hiện bảng chọn
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile'],
        loginBehavior: LoginBehavior.webOnly, // Ép dùng cửa sổ Web
      );
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final response = await http.post(
            Uri.parse('${ApiConfig.baseUrl}/api/auth/facebook'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'token': accessToken.tokenString, 'action': 'REGISTER'}),
          );
          if (response.statusCode == 200) {
            final data = jsonDecode(utf8.decode(response.bodyBytes));
            if (data['token'] != null) await context.read<AuthService>().saveToken(data['token']);
            _showMessage('Đăng ký thành công! Vui lòng đăng nhập.');
            if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
          } else {
            String errorMsg = _getErrorMessage(response.bodyBytes);
            if (errorMsg.contains('đã tồn tại') || errorMsg.contains('đã có')) {
              _showMessage('Tài khoản đã tồn tại! Vui lòng đăng nhập.');
              if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            } else {
              _showMessage(errorMsg);
            }
          }
      } else {
        _showMessage('Facebook Sign Up thất bại: ${result.message}');
      }
    } catch (e) {
      _showMessage('Lỗi Facebook Sign Up: $e');
    }
    setState(() => _isLoading = false);
  }

  String _getErrorMessage(List<int> bodyBytes) {
    try {
      final decoded = jsonDecode(utf8.decode(bodyBytes));
      return decoded['message'] ?? utf8.decode(bodyBytes);
    } catch (e) {
      return utf8.decode(bodyBytes);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Sign up', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                        child: const Text('Already have an account? ➔', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE12B20), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                      child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('SIGN UP', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    
                    const Spacer(), // Đẩy phần social xuống dưới cùng
                    
                    const Text('Or sign up with social account', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: _handleGoogleRegister,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 8)]),
                            child: Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png', width: 24, height: 24, errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 24)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: _handleFacebookRegister,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 8)]),
                            child: Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/2021_Facebook_icon.svg/120px-2021_Facebook_icon.svg.png', width: 24, height: 24, errorBuilder: (context, error, stackTrace) => const Icon(Icons.facebook, size: 24, color: Colors.blue)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
