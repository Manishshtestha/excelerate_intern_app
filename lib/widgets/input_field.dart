import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData? icon;
  final bool obscureText;
  final TextEditingController? controller;
  final bool autoFocus;

  const InputField({
    super.key,
    required this.label,
    required this.hint,
    this.icon,
    this.obscureText = false,
    this.controller,
    this.autoFocus = true,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 12, end: 12, bottom: 8),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        autofocus: widget.autoFocus,
        decoration: InputDecoration(
          prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
          hintText: widget.hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
          // 👁️ Eye icon toggle
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
