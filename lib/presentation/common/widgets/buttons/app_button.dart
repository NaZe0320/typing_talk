import 'package:flutter/material.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';

enum AppButtonType {
  primary,
  secondary,
  error,
  success,
  warning,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatefulWidget {
  final String text;
  final Future<void> Function()? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isFullWidth;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isFullWidth = true,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (_isLoading || widget.onPressed == null) return;

    setState(() => _isLoading = true);

    try {
      await widget.onPressed!();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isFullWidth ? double.infinity : null,
      height: _getHeight(),
      child: ElevatedButton(
        onPressed: widget.onPressed == null ? null : _handlePress,
        style: _getButtonStyle(),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (_isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.type == AppButtonType.secondary ? AppColors.primaryBlue : Colors.white,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.prefixIcon != null) ...[
          widget.prefixIcon!,
          const SizedBox(width: 8),
        ],
        Text(
          widget.text,
          style: _getTextStyle(),
        ),
        if (widget.suffixIcon != null) ...[
          const SizedBox(width: 8),
          widget.suffixIcon!,
        ],
      ],
    );
  }

  double _getHeight() {
    switch (widget.size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  ButtonStyle _getButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: _getBackgroundColor(),
      foregroundColor: _getForegroundColor(),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: widget.type == AppButtonType.secondary ? BorderSide(color: AppColors.primaryBlue) : BorderSide.none,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: widget.size == AppButtonSize.small ? 16 : 24,
      ),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return _getPressedColor();
          }
          return null;
        },
      ),
    );
  }

  TextStyle _getTextStyle() {
    final baseStyle = widget.size == AppButtonSize.small ? AppTypography.btn_5 : AppTypography.btn_6;

    return baseStyle.copyWith(
      color: _getForegroundColor(),
    );
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case AppButtonType.primary:
        return AppColors.primaryBlue;
      case AppButtonType.secondary:
        return Colors.transparent;
      case AppButtonType.error:
        return AppColors.errorText;
      case AppButtonType.success:
        return AppColors.successText;
      case AppButtonType.warning:
        return AppColors.warningText;
    }
  }

  Color _getForegroundColor() {
    switch (widget.type) {
      case AppButtonType.secondary:
        return AppColors.primaryBlue;
      default:
        return Colors.white;
    }
  }

  Color _getPressedColor() {
    switch (widget.type) {
      case AppButtonType.primary:
        return AppColors.tertiaryBlue;
      case AppButtonType.secondary:
        return AppColors.secondaryBlue;
      case AppButtonType.error:
        return AppColors.errorText.withValues(alpha: 0.8);
      case AppButtonType.success:
        return AppColors.successText.withValues(alpha: 0.8);
      case AppButtonType.warning:
        return AppColors.warningText.withValues(alpha: 0.8);
    }
  }
}
