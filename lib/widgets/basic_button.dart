import 'package:flutter/material.dart';

class BasicButton extends StatefulWidget {
  final Function() onTap;
  final String text;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Icon? icon;
  final double textSize;
  const BasicButton({
    super.key,
    required this.onTap,
    required this.text,
    this.icon,
    this.padding = const EdgeInsets.all(22),
    this.margin = const EdgeInsets.symmetric(horizontal: 25),
    this.textSize = 15
  });

  @override
  State<BasicButton> createState() => _BasicButtonState();
}

class _BasicButtonState extends State<BasicButton> {
  bool _isPressed = false;
  Color get _backgroundColor {
    if (_isPressed) return Color(0xFF0B4D7F);
    return Color(0xFF1067B4);
  }
  Color get _textColor {
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() {
          _isPressed = false;
          widget.onTap();
        }),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          padding: widget.padding,
          margin: widget.margin,
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(milliseconds: 75),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(widget.icon != null) ... [
                widget.icon!,
                const SizedBox(width: 5),
              ],
              Text(
                widget.text,
                style: TextStyle(
                color: _textColor, fontWeight: FontWeight.bold, fontSize: widget.textSize),
              )
            ],
          ),
        ),
      ),
    );
  }
}
