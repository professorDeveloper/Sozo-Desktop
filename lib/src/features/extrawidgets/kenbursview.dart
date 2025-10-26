import 'package:flutter/material.dart';

class KenBurnsView extends StatefulWidget {
  final ImageProvider image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Duration duration;

  const KenBurnsView({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<KenBurnsView> createState() => _KenBurnsViewState();
}

class _KenBurnsViewState extends State<KenBurnsView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<Alignment> _alignment;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _alignment = Tween<Alignment>(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          alignment: _alignment.value,
          child: Container(
            width: widget.width ?? double.infinity,
            height: widget.height ?? double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.image,
                fit: widget.fit,
              ),
            ),
          ),
        );
      },
    );
  }
}
