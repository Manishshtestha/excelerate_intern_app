import 'dart:async';
import 'dart:math';
import 'package:excelerate_intern_app/main.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  double progress = 0;

  @override
  void initState() {
    super.initState();

    // Fade-in animation for the text and progress
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    // Simulate loading (increasing percentage gradually)
    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      setState(() {
        progress += 1;
        if (progress >= 100) {
          progress = 100;
          timer.cancel();

          // Navigate to main page when complete
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const MyApp(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final fade = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                );
                return FadeTransition(opacity: fade, child: child);
              },
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFFFF5C8D), Color(0xFFFF8C42)], // pink to orange
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🌌 Background animated circles
          Positioned.fill(
            child: CustomPaint(
              painter: GalaxyPainter(),
            ),
          ),

          // 🌟 Foreground content
          FadeTransition(
            opacity: _fadeController,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Gradient LEVEL UP text
                    ShaderMask(
                      shaderCallback: (bounds) => gradient.createShader(bounds),
                      child: const Text(
                        "LEVEL UP",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Show percentage text
                    Text(
                      "${progress.toInt()}%",
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Animated progress bar
                    Container(
                      width: 250,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade800,
                      ),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: progress / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: gradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    const Text(
                      "Welcome to the Level-UP learning platform!",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Built by Excelerate Flutter Mobile Development Interns",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🌠 Custom painter for glowing circles background
class GalaxyPainter extends CustomPainter {
  final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Circles in pink and orange tones
    final colors = [
      const Color(0xFFFF5C8D),
      const Color(0xFFFF8C42),
      const Color(0xFFFF6FA5),
      const Color(0xFFFFA55B),
    ];

    for (int i = 0; i < 30; i++) {
      final color = colors[random.nextInt(colors.length)];
      final radius = random.nextDouble() * 6 + 2;
      final offset = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );

      paint.color = color.withOpacity(0.25 + random.nextDouble() * 0.4);
      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
