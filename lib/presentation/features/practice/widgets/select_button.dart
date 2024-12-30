import 'package:flutter/material.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/presentation/common/widgets/icon_widget.dart';

class SelectOption {
  final String id;
  final String text;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  /*final String? leadingIcon;
  final String? trailingIcon;*/
  final bool disabled;
  final bool isPremium;

  const SelectOption({
    required this.id,
    required this.text,
    this.leadingIcon,
    this.trailingIcon,
    this.disabled = false,
    this.isPremium = false,
  });
}

class SelectButton extends StatelessWidget {
  final SelectOption option;
  final bool isSelected;
  final VoidCallback onPressed;

  const SelectButton({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        border: Border.all(
          color: _getBorderColor(context),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: option.disabled ? null : onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            spacing: 8,
            children: [
              if (option.leadingIcon != null) ...[
                Icon(
                  option.leadingIcon,
                  size: 20,
                  color: _getIconColor(context),
                ),

                /*IconWidget(
                  assetName: option.leadingIcon!,
                  size: 16,
                )*/
              ],
              Expanded(child: Text(option.text, style: AppTypography.btn_6)),
              if (option.isPremium) ...[
                Icon(
                  Icons.crop,
                  size: 16,
                  color: Colors.amber[600],
                ),
                /*IconWidget(
                  assetName: 'option.leadingIcon!', //TODO(Premium 아이콘)
                  size: 16,
                )*/
              ],
              if (option.trailingIcon != null) ...[
                Icon(
                  option.trailingIcon,
                  size: 20,
                  color: _getIconColor(context),
                ),
                /*IconWidget(
                  assetName: option.trailingIcon!,
                  size: 16,
                )*/
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (option.disabled) return Theme.of(context).disabledColor.withOpacity(0.1);
    if (isSelected) return Theme.of(context).primaryColor.withOpacity(0.1);
    return Colors.transparent;
  }

  Color _getBorderColor(BuildContext context) {
    if (option.disabled) return Theme.of(context).disabledColor;
    if (isSelected) return Theme.of(context).primaryColor;
    return Theme.of(context).dividerColor;
  }

  Color _getTextColor(BuildContext context) {
    if (option.disabled) return Theme.of(context).disabledColor;
    if (isSelected) return Theme.of(context).primaryColor;
    return Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
  }

  Color _getIconColor(BuildContext context) {
    if (option.disabled) return Theme.of(context).disabledColor;
    if (isSelected) return Theme.of(context).primaryColor;
    return Theme.of(context).iconTheme.color ?? Colors.black54;
  }
}
