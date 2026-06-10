import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/config/api_config.dart';
import '/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/login'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['token'] != null) await context.read<AuthService>().saveToken(data['token']);
        _showMessage('Đăng nhập thành công!');
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        _showMessage('Đăng nhập thất bại: ${_getErrorMessage(response.bodyBytes)}');
      }
    } catch (e) {
      _showMessage('Lỗi kết nối: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    try {
      await GoogleSignIn.instance.signOut();
      final GoogleSignInAccount account = await GoogleSignIn.instance.authenticate();
      
      final GoogleSignInAuthentication auth = account.authentication;
      if (auth.idToken != null) {
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/api/auth/google'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'token': auth.idToken, 'action': 'LOGIN'}),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(utf8.decode(response.bodyBytes));
          if (data['token'] != null) await context.read<AuthService>().saveToken(data['token']);
          _showMessage('Google Login thành công!');
          if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          String errorMsg = _getErrorMessage(response.bodyBytes);
          if (errorMsg.contains('chưa được đăng ký') || errorMsg.contains('chưa đăng ký')) {
            if (mounted) {
              _showErrorDialog(
                'Tài khoản chưa đăng ký',
                'Tài khoản này chưa được đăng ký. Vui lòng đăng ký trước khi đăng nhập!',
              );
            }
          } else {
            _showMessage(errorMsg);
          }
        }
      }
        } catch (e) {
      _showMessage('Lỗi Google Login: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _handleFacebookLogin() async {
    setState(() => _isLoading = true);
    try {
      await FacebookAuth.instance.logOut();
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile'],
        loginBehavior: LoginBehavior.webOnly, // Ép dùng cửa sổ Web
      );
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final response = await http.post(
            Uri.parse('${ApiConfig.baseUrl}/api/auth/facebook'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'token': accessToken.tokenString, 'action': 'LOGIN'}),
          );
          if (response.statusCode == 200) {
            final data = jsonDecode(utf8.decode(response.bodyBytes));
            if (data['token'] != null) await context.read<AuthService>().saveToken(data['token']);
            _showMessage('Facebook Login thành công!');
            if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          } else {
            String errorMsg = _getErrorMessage(response.bodyBytes);
            if (errorMsg.contains('chưa được đăng ký') || errorMsg.contains('chưa đăng ký')) {
              if (mounted) {
                _showErrorDialog(
                  'Tài khoản chưa đăng ký',
                  'Tài khoản này chưa được đăng ký. Vui lòng đăng ký trước khi đăng nhập!',
                );
              }
            } else {
              _showMessage(errorMsg);
            }
          }
      } else {
        _showMessage('Facebook Login thất bại: ${result.message}');
      }
    } catch (e) {
      _showMessage('Lỗi Facebook Login: $e');
    }
    setState(() => _isLoading = false);
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text("OK", style: TextStyle(color: Color(0xFFE12B20))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
        ),
      ),
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
                    const Text(
                      'Login',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {}, // TODO: Forgot Password
                        child: const Text('Forgot your password? ➔', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE12B20),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('LOGIN', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                          child: const Text('Sign up', style: TextStyle(color: Color(0xFFE12B20), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    
                    const Spacer(), // Đẩy phần social xuống dưới cùng
                    
                    const Text('Or login with social account', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: _handleGoogleLogin,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 8)]),
                            child: Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png', width: 24, height: 24, errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 24)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: _handleFacebookLogin,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 8)]),
                            child: Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/2021_Facebook_icon.svg/120px-2021_Facebook_icon.svg.png', width: 24, height: 24, errorBuilder: (context, error, stackTrace) => const Icon(Icons.facebook, size: 24, color: Colors.blue)),
                          ),
                        ),
                      ],
                    ),
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
