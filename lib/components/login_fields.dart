import 'package:flutter/material.dart';

class LoginFields extends StatelessWidget {
  const LoginFields(
      {Key? key,
      required this.formHintText,
      required this.formPrefixIcon,
      required this.obscureText,
      required this.onChanged})
      : super(key: key);

  final String formHintText;
  final IconData formPrefixIcon;
  final bool obscureText;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: TextFormField(
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          hintText: formHintText,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey.shade400),
          prefixIcon: Icon(
            formPrefixIcon,
            color: Colors.grey.shade400,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
