import 'package:crypt/crypt.dart';
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
        backgroundColor: Colors.brown.shade900,
        title: Text("Login page"),
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
              shape: StadiumBorder(),
              foregroundColor: Colors.white,
              backgroundColor: isValid ? Colors.brown.shade700 : Colors.grey.shade700,
            ),
          ),
          ElevatedButton(
            onPressed: isFirstLogin ? null : resetPassword,
            child: Text("Reset password"),
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              foregroundColor: Colors.white,
              backgroundColor: isValid ? Colors.brown.shade700 : Colors.grey.shade700,
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
      if (checkIfEqual()) {
        resetDataInSecureStorage();
        return;
      }
      incrementFailedAttempts();
      if (failedAttempts >= 3) {
        wipeAllData();
        return;
      }
      showWrongPasswordMessage();
    }
  }

  bool checkIfEqual() {
    String hashedPassword = Crypt.sha512(
      typedPassword.trim(),
      rounds: 10000,
      salt: "salt",
    ).toString();
    return hashedPassword == savedEncryptedPassword;
  }

  void validateLogin() async {
    final isValid = _loginFormKey.currentState!.validate();
    _loginFormKey.currentState?.reset();

    if (isValid) {
      if (!isFirstLogin) {
        if (checkIfEqual()) {
          await PasswordSecureStorage.setFailedAttempts(0);
          moveToNotesPage();
          showSuccessfulLoginMessage();
          return;
        }
        incrementFailedAttempts();
        if (failedAttempts >= 3) {
          wipeAllData();
          return;
        }
        showWrongPasswordMessage();
        return;
      }

      await PasswordSecureStorage.setPassword(typedPassword);
      moveToNotesPage();
    }
  }

  void resetDataInSecureStorage() async {
    await PasswordSecureStorage.setPassword('');
    await PasswordSecureStorage.setFailedAttempts(0);
    refresh();
  }

  void wipeAllData() async {
    showWipingDataMessage();
    DatabaseProvider.instance.deleteAll();
    await PasswordSecureStorage.setSecretKey();
    resetDataInSecureStorage();
  }

  void incrementFailedAttempts() async {
    setState(() => failedAttempts += 1);
    await PasswordSecureStorage.setFailedAttempts(failedAttempts);
  }

  void moveToNotesPage() async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NotesPage(),
    ));
    refresh();
  }

  void showWrongPasswordMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Wrong password. To reset the password type the old one."
            " Failed attempts: $failedAttempts/3"),
        duration: Duration(milliseconds: 5000),
      ),
    );
  }

  void showWipingDataMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Wrong password has been typed 3 times - wiping all data."),
        duration: Duration(milliseconds: 5000),
      ),
    );
  }

  void showSuccessfulLoginMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Successful login"),
        duration: Duration(milliseconds: 1000),
      ),
    );
  }
}
