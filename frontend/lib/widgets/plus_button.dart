import 'package:flutter/material.dart';

class PlusButton extends StatefulWidget {
  final Function() onTap;
  const PlusButton({
    super.key,
    required this.onTap,
  });
  
  @override
  State<PlusButton> createState() => _PlusButtonState();
}

class _PlusButtonState extends State<PlusButton> {
  bool _isPressed = false;
  Color get _backgroundColor {
    if (_isPressed) return Color(0xFF0B4D7F);
    return Color(0xFF1067B4);
  }
  Color get _iconColor {
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _isPressed = true),
      onPointerUp: (_) => setState(() => _isPressed = false),
      onPointerCancel: (_) => setState(() => _isPressed = false),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 75),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: FloatingActionButton(
            onPressed: widget.onTap,
            backgroundColor: _backgroundColor,
            elevation: _isPressed ? 2 : 6,
            shape: const CircleBorder(),

            child: Icon(
              Icons.add,
              color: _iconColor,
            ),
          ),
        ),
      ),
    );
  }
}