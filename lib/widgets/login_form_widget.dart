import 'package:flutter/material.dart';

class LoginFormWidget extends StatelessWidget {
  final ValueChanged<String> onChangedPassword;

  const LoginFormWidget({Key? key, required this.onChangedPassword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          buildPassword(),
        ]),
      ),
    );
  }

  Widget buildPassword() {
    return TextFormField(
      maxLines: 1,
      style: TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.white70),
      ),
      validator: (password) => password != null && password.isEmpty ? 'Password cannot be empty' : null,
      onChanged: onChangedPassword,
    );
  }
}
