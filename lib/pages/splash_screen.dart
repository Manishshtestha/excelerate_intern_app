import 'dart:async';
import 'dart:math';
import 'package:excelerate_intern_app/pages/login.dart';
import 'package:flutter/material.dart';

// Splash screen displayed when the app starts
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override 
  State<SplashScreen> createState() => _SplashScreenState();
}

// Controls animations and transitions for the splash screen
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController; // Controls fade-in animation
  double progress = 0; // Tracks loading progress (0–100%)

  @override
  void initState() {
    super.initState();

    // Initialize fade-in animation for logo and text
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward(); // Starts animation immediately

    // Simulate a loading effect by increasing progress every 80ms
    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      setState(() {
        progress += 1;

        // When loading reaches 100%, stop timer and navigate to LoginPage
        if (progress >= 100) {
          progress = 100;
          timer.cancel();

          // Smooth transition to LoginPage with fade animation
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const LoginPage(),
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
    _fadeController.dispose(); // Dispose animation controller to free memory
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Gradient used for text and progress bar
    final gradient = const LinearGradient(
      colors: [Color(0xFFFF5C8D), Color(0xFFFF8C42)], // Pink → Orange
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background with randomly placed glowing circles
          Positioned.fill(
            child: CustomPaint(
              painter: GalaxyPainter(), // Draws the abstract background
            ),
          ),

          // Foreground splash content with fade-in animation
          FadeTransition(
            opacity: _fadeController,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Gradient "LEVEL UP" text
                    Image.network('https://excelerateuserprofile.s3.ap-south-1.amazonaws.com/WebsiteImages/Excelerate_180_27.png',
                      height: 100,
                    ),
                    Text('presents',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
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

                    // Display percentage text (progress)
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
                        widthFactor: progress / 100, // Progress fill percentage
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: gradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Subtitle text
                    const Text(
                      "Welcome to the Level-UP learning platform!",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    // Credit text
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

// 🎆 Custom painter class for glowing circular background
class GalaxyPainter extends CustomPainter {
  final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Set of colors for the circles (soft glowing effect)
    final colors = [
      const Color(0xFFFF5C8D),
      const Color(0xFFFF8C42),
      const Color(0xFFFF6FA5),
      const Color(0xFFFFA55B),
    ];

    // Draw 30 random glowing circles
    for (int i = 0; i < 30; i++) {
      final color = colors[random.nextInt(colors.length)];
      final radius = random.nextDouble() * 6 + 2; // Vary radius size
      final offset = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );

      // Random opacity for more natural glow
      paint.color = color.withOpacity(0.25 + random.nextDouble() * 0.4);
      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true; // Always repaint
}
