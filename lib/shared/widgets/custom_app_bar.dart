import 'package:flutter/material.dart';

/// Custom AppBar widget with consistent styling across the app
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      leading:
          leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                )
              : null),
      automaticallyImplyLeading: showBackButton,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

/// AppBar with search functionality
class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onClear;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  const SearchAppBar({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onClear,
    this.onSubmitted,
    this.autofocus = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: TextField(
        controller: controller,
        autofocus: autofocus,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    onClear?.call();
                  },
                )
              : null,
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
