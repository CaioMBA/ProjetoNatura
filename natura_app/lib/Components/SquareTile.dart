import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final Function()? onTap;
  final String imagePath;
  final double? Height;
  final double? Width;

  const SquareTile(
      {super.key,
      required this.imagePath,
      this.Height,
      this.Width,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Image.asset(
          imagePath,
          height: Height ?? 40,
          width: Width ?? (Height ?? 40),
        ),
      ),
    );
  }
}
