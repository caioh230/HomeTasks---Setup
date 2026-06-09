import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Avatar extends StatefulWidget {
  final String? id;
  final double size;
  final double offset;
  final double borderSize;

  Avatar({
    super.key,
    this.id = "",
    this.size = 34.0,
    this.offset = 0.0,
    this.borderSize = 2.0,
  });

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(widget.offset, 0),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: widget.borderSize,
          ),
        ),
        child: ClipOval(
          child: Skeletonizer(
            enabled: isLoading,
            child: Image.network(
              'https://i.pravatar.cc/100?img=${widget.id}',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null && isLoading) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() => isLoading = false);
                    }
                  });
                }
                return child;
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Color(0xFF1067B4),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: widget.size * 0.5,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}