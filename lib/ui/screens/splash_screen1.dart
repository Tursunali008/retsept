import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/widgets/route.dart';
import 'package:go_router/go_router.dart';

class Splash1Screen extends StatefulWidget {
  const Splash1Screen({super.key});

  @override
  _Splash1ScreenState createState() => _Splash1ScreenState();
}

class _Splash1ScreenState extends State<Splash1Screen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  Future<void> _navigateToNextPage() async {
    await Future.delayed(const Duration(seconds: 3), () {
      context.goNamed(AppRoutes.news); // Bu yerda nom to'g'irlandi
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.purple,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Image.asset(
            "assets/foodify.png",
            width: 300.0,
            height: 300.0,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
