import 'package:flutter/material.dart';

class LoginFormWidget extends StatelessWidget {
  final ValueChanged<String> onChangedPassword;

  const LoginFormWidget({Key? key, required this.onChangedPassword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: buildPassword(),
      ),
    );
  }

  Widget buildPassword() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: true,
      maxLines: 1,
      style: TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.brown.shade700,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.brown.shade700, width: 3.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.brown.shade700, width: 3.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.red.shade900, width: 3.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.red.shade900, width: 3.0),
        ),
        border: OutlineInputBorder(),
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.white70),
      ),
      validator: (password) {
        if (password != null && password.isEmpty) {
          return 'Password cannot be empty';
        } else if (password!.length < 6) {
          return 'Password must be of minimum 6 characters';
        }
        return null;
      },
      onChanged: onChangedPassword,
    );
  }
}
