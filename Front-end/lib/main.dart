import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'package:provider/provider.dart';
import 'providers/favorite_provider.dart';
// Ensure you have the following dependencies in your pubspec.yaml:

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await GoogleSignIn.instance.initialize(
      clientId: '740569241494-pvu35tc8q6gr3pmevmcs48ugeq888qj6.apps.googleusercontent.com', 
      serverClientId: '740569241494-q8bgce9k289ni397sfpia98k38k68va4.apps.googleusercontent.com',
    );
  } catch (e) {
    debugPrint("GoogleSignIn init error: $e");
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sitlly App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
      ),
      home: Consumer<AuthService>(
        builder: (context, auth, _) {
          if (auth.isLoading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return auth.isAuthenticated ? const HomeScreen() : const RegisterScreen();
        },
      ),
    );
  }
}
