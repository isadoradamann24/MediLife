/**import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1200,
      ),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );

    scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );

    controller.forward();

    iniciarAplicacao();
  }

  Future<void> iniciarAplicacao() async {

    await Future.delayed(
      const Duration(
        seconds: 3,
      ),
    );

    if(!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      "/",
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color.fromARGB(
            255,
            0,
            70,
            80,
          ),

      body: Center(

        child: FadeTransition(

          opacity: fadeAnimation,

          child: ScaleTransition(

            scale: scaleAnimation,

            child: Column(

              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                Container(

                  height: 130,

                  width: 130,

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(35),

                  ),

                  child: const Icon(

                    Icons.medication,

                    size: 75,

                    color: Color.fromARGB(
                      255,
                      0,
                      90,
                      110,
                    ),

                  ),

                ),

                const SizedBox(
                  height: 30,
                ),

                const Text(

                  "MedLife",

                  style: TextStyle(

                    color: Colors.white,

                    fontSize: 40,

                    fontWeight:
                        FontWeight.bold,

                    letterSpacing: 1.5,

                  ),

                ),

                const SizedBox(
                  height: 10,
                ),
              ],

            ),

          ),

        ),

      ),

    );

  }

}**/