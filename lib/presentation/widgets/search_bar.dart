import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;
  final String hintText;
  final EdgeInsetsGeometry padding;
  final Color fillColor;
  final Color borderColor;
  final double borderRadius;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    required this.onClear,
    required this.controller,
    this.hintText = 'Search books by title or author...',
    this.padding = const EdgeInsets.all(18),
    this.fillColor = Colors.white,
    this.borderColor = const Color(0xFFDDDDDD),
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return Padding(
          padding: padding,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 16,
                color: Color(0xFF868B99),
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 30,
                color: Color(0xFF505664),
              ),
              suffixIcon: value.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(
                        Icons.clear_rounded,
                        color: Color(0xFF505664),
                      ),
                      onPressed: () {
                        controller.clear();
                        onClear();
                      },
                    ),
              filled: true,
              fillColor: fillColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: Color(0xFF9CA7C4),
                  width: 1.2,
                ),
              ),
            ),
            onChanged: onSearch,
            onSubmitted: onSearch,
          ),
        );
      },
    );
  }
}
