import 'package:flutter/material.dart';
import 'package:notepad/pages/notes_page.dart';

import '../db/database_provider.dart';
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
  int failedAttempts = 0;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future refresh() async {
    setState(() => isLoading = true);
    savedEncryptedPassword = await PasswordSecureStorage.getPassword();
    setState(() => isFirstLogin = savedEncryptedPassword == '');
    failedAttempts = await PasswordSecureStorage.getFailedAttempts();
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
        await PasswordSecureStorage.setFailedAttempts(0);
        refresh();
        return;
      }
      setState(() => failedAttempts += 1);
      await PasswordSecureStorage.setFailedAttempts(failedAttempts);
      if (failedAttempts == 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Wrong password has been typed 3 times - wiping all data."),
            duration: Duration(milliseconds: 3000),
          ),
        );
        await PasswordSecureStorage.setPassword('');
        await PasswordSecureStorage.setFailedAttempts(0);
        DatabaseProvider.instance.deleteAll();
        refresh();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Wrong password. To reset the password you have to type the old one first!"
              " Failed attempts: $failedAttempts/3"),
          duration: Duration(milliseconds: 5000),
        ),
      );
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
          await PasswordSecureStorage.setFailedAttempts(0);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Successful login"),
              duration: Duration(milliseconds: 1000),
            ),
          );
          refresh();
          return;
        }
        setState(() => failedAttempts += 1);
        await PasswordSecureStorage.setFailedAttempts(failedAttempts);
        if (failedAttempts == 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Wrong password has been typed 3 times - wiping all data."),
              duration: Duration(milliseconds: 5000),
            ),
          );
          await PasswordSecureStorage.setPassword('');
          await PasswordSecureStorage.setFailedAttempts(0);
          DatabaseProvider.instance.deleteAll();
          refresh();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Wrong password. Failed attempts: $failedAttempts/3"),
            duration: Duration(milliseconds: 3000),
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
