import 'package:flutter/material.dart';
import 'package:nttcs/core/app_export.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback? onFilter;
  final String hintSearch;

  const SearchField({super.key, required this.controller, required this.onChanged, required this.onClear, this.onFilter, required this.hintSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Đặt màu nền của Container là trắng
          borderRadius: BorderRadius.circular(4.0), // Bo góc cho Container
          border: Border.all(color: appTheme.grayBorder), // Viền màu xám
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.0), // Bo góc giống như Container
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintSearch,
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              // Màu nền bên trong TextField là trắng
              contentPadding: const EdgeInsets.all(12.0),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: onClear,
                        )
                      : const SizedBox.shrink(),
                  if (onFilter != null)
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.blue),
                      onPressed: onFilter,
                    ),
                ],
              ),
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
