import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final Color backgroundColor;
  final Icon? prefixIcon;
  final Function? onForgotPassword;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  const InputField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.backgroundColor = Colors.white,
    this.prefixIcon,
    this.onForgotPassword,
    this.hintText,
    this.onChanged,
  });
  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF334155),
                  ),
                ),

                if (widget.isPassword && widget.onForgotPassword != null)
                  GestureDetector(
                    onTap: () => widget.onForgotPassword!(),
                    child: const Text(
                      "Esqueci a senha",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF005DAF),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              obscureText: _obscureText,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1E293B),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.isPassword
                  ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility,
                      color: const Color(0xFF64748B),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}