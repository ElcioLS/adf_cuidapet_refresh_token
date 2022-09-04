import 'package:adf_cuidapet/app/core/ui/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

class CuidapetDefaultButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double borderRadius;
  final String label;
  final Color? color;
  final Color? labelColor;
  final double labelSize;
  final double padding;
  final double width;
  final double height;

  const CuidapetDefaultButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.borderRadius = 10,
    this.labelColor,
    this.color,
    this.labelSize = 20,
    this.padding = 10,
    this.width = double.infinity,
    this.height = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor: color ?? context.primaryColor,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: labelSize,
            color: labelColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
