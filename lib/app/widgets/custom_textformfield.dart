import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.icon,
    required this.label,
    this.isPassword = false,
    this.inputFormatters,
    this.initialValue,
    this.readOnly = false,
    this.validator,
    this.controller,
    this.textInputType,
    this.maxLength,
  }) : super(key: key);

  final String label;
  final bool isPassword;
  final IconData? icon;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool readOnly;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final int? maxLength;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isSecret = false;

  @override
  void initState() {
    super.initState();
    isSecret = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: SizedBox(
        height: 50,
        child: TextFormField(
          maxLength: widget.maxLength,
          keyboardType: widget.textInputType,
          readOnly: widget.readOnly,
          initialValue: widget.initialValue,
          inputFormatters: widget.inputFormatters,
          obscureText: isSecret,
          validator: widget.validator,
          controller: widget.controller,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon),
            labelText: widget.label,
            isDense: true,
            suffix: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isSecret = !isSecret;
                      });
                    },
                    icon: Icon(
                        isSecret ? Icons.visibility_off : Icons.visibility),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
      ),
    );
  }
}
