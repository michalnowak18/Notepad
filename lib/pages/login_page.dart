import 'package:flutter/material.dart';
import 'package:notepad/pages/notes_page.dart';

import '../utils/password_secure_storage.dart';
import '../widgets/login_form_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  bool isFirstLogin = false;
  bool isLoading = false;
  late String typedPassword = '';
  late String? savedEncryptedPassword;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future refresh() async {
    setState(() => isLoading = true);
    savedEncryptedPassword = await PasswordSecureStorage.getPassword();
    setState(() => isFirstLogin = savedEncryptedPassword == '');
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login page"),
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : Column(
              children: [
                Form(
                  key: _loginFormKey,
                  child: LoginFormWidget(
                    onChangedPassword: (password) => setState(() => this.typedPassword = password),
                  ),
                ),
                loginButton(),
              ],
            ),
    );
  }

  Widget loginButton() {
    final isValid = typedPassword.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            child: isFirstLogin ? Text("Register") : Text("Login"),
            onPressed: validateLogin,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: isValid ? null : Colors.grey.shade700,
            ),
          ),
          ElevatedButton(
            onPressed: isFirstLogin ? null : resetPassword,
            child: Text("Reset password"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: isValid ? null : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  void resetPassword() async {
    final isValid = _loginFormKey.currentState!.validate();
    _loginFormKey.currentState?.reset();

    if (isValid) {
      if (typedPassword == savedEncryptedPassword) {
        await PasswordSecureStorage.setPassword('');
        refresh();
      }
    }
  }

  void validateLogin() async {
    final isValid = _loginFormKey.currentState!.validate();
    _loginFormKey.currentState?.reset();

    if (isValid) {
      if (!isFirstLogin) {
        if (typedPassword == savedEncryptedPassword) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NotesPage(),
          ));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Successful login"),
              duration: Duration(milliseconds: 1000),
            ),
          );
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Wrong password"),
            duration: Duration(milliseconds: 1000),
          ),
        );
        return;
      }

      await PasswordSecureStorage.setPassword(typedPassword);
      refresh();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NotesPage(),
      ));
    }
  }
}
