import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final bool isNavigating;
  final VoidCallback onPressed;

  const NavigationButton({
    Key? key,
    required this.isNavigating,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isNavigating) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.view_in_ar),
            SizedBox(width: 8),
            Text(
              'Live AR View',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 