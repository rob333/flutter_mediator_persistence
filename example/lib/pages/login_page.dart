import 'package:flutter/material.dart';
import 'package:flutter_mediator_persistence/mediator.dart';

import '/api/api_login.dart';
import '/var.dart';
import 'components/progress.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  bool isApiCallProcess = false;

  /// Persistence variable
  final rememberMe = true.globalPersist('rememberMe');
  final rememberedAccount = ''.globalPersist('account');

  final FocusNode accountFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode loginFocusNode = FocusNode();
  final TextEditingController accountFieldController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final loginRequest = LoginRequest();

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: body(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget body(BuildContext context) {
    if (!isApiCallProcess) {
      late FocusNode focus;
      if (rememberMe.value) {
        if (rememberedAccount.value.isEmpty) {
          focus = accountFocusNode;
        } else {
          accountFieldController.text = rememberedAccount.value;
          focus = passwordFocusNode;
        }
      } else {
        focus = accountFocusNode;
      }
      FocusScope.of(context).requestFocus(focus);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              margin: const EdgeInsets.symmetric(vertical: 85, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).hintColor.withOpacity(0.2),
                    offset: const Offset(0, 10),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    'login.title'.ci18n(
                      context,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 20),
                    const Text('ID: eve.holt@reqres.in'),
                    buildAccountFormField(context),
                    const SizedBox(height: 20),
                    const Text('PW: cityslicka'),
                    buildPasswordFormField(context),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => tapRememberMe(!rememberMe.value),
                          child: Row(
                            children: [
                              Checkbox(
                                value: rememberMe.value,
                                onChanged: tapRememberMe,
                              ),
                              'login.rememberMe'.ci18n(context),
                            ],
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          // ignore: todo
                          // TODO(xxx): implement 'ForgetPasswordPage'
                          onTap: () {},
                          child: 'login.forgotPassword'.ci18n(
                            context,
                            style: const TextStyle(
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    loginButton(context),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            //* Stet4A: Make an update to the watched variable.
            onPressed: () => changeTheme(0),
            tooltip: 'Theme 1',
            child: Image.asset('assets/images/1.png'),
            heroTag: null,
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            //* Stet4B: Make an update to the watched variable.
            onPressed: () => changeTheme(1),
            tooltip: 'Theme 2',
            child: Image.asset('assets/images/2.png'),
            heroTag: null,
          )
        ],
      ),
    );
  }

  void tapRememberMe(bool? value) {
    setState(() {
      rememberMe.value = value!;

      // Clear the remembered account if un-checked.
      if (value == false) {
        rememberedAccount.remove();
      }
    });
  }

  TextFormField buildAccountFormField(BuildContext context) {
    return TextFormField(
      controller: accountFieldController,
      focusNode: accountFocusNode,
      keyboardType: TextInputType.emailAddress,
      onSaved: (input) => loginRequest.account = input,
      validator: (input) => accountValidator(input),
      decoration: formInputDecoration(
        context,
        'login.enterYourAccount'.i18n(context),
        Icons.person,
      ),
      onFieldSubmitted: (value) =>
          FocusScope.of(context).requestFocus(passwordFocusNode),
    );
  }

  String? accountValidator(String? input) {
    if (input == null || input.isEmpty) {
      return 'login.accountlNullError'.i18n(context);
    }
    if (!input.contains('@')) {
      return 'login.invalidAccountError'.i18n(context);
    }
    return null;
  }

  TextFormField buildPasswordFormField(BuildContext context) {
    return TextFormField(
      focusNode: passwordFocusNode,
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      keyboardType: TextInputType.text,
      onSaved: (input) => loginRequest.password = input,
      validator: (input) => passwordValidator(input),
      obscureText: hidePassword,
      decoration: formInputDecoration(
        context,
        'login.password'.i18n(context),
        Icons.lock,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              hidePassword = !hidePassword;
            });
          },
          color: Theme.of(context).highlightColor.withOpacity(0.4),
          icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
        ),
      ),
      onFieldSubmitted: (value) =>
          FocusScope.of(context).requestFocus(loginFocusNode),
    );
  }

  String? passwordValidator(String? input) {
    if (input == null || input.isEmpty) {
      return 'login.passwordNullError'.i18n(context);
    }
    if (input.length < 3) {
      return 'login.shortPasswordError'.i18n(context);
    }
    return null;
  }

  InputDecoration formInputDecoration(
    BuildContext context,
    String hintText,
    IconData iconData, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.secondary)),
      prefixIcon: Icon(
        iconData,
        color: Theme.of(context).highlightColor,
      ),
      suffixIcon: suffixIcon,
    );
  }

  TextButton loginButton(BuildContext context) {
    return TextButton(
      focusNode: loginFocusNode,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(10),
        minimumSize: const Size(80, 12),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: const StadiumBorder(),
        // alignment: Alignment.centerLeft,
      ),
      onPressed: onLoginForm,
      child: 'login.login'.ci18n(
        context,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  bool validateAndSaveLoginForm() {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> onLoginForm() async {
    if (validateAndSaveLoginForm()) {
      print('login: ${loginRequest.toJson()}');

      if (rememberMe.value) {
        rememberedAccount.store(loginRequest.account!);
      }

      setState(() {
        isApiCallProcess = true;
      });

      final response = await APIService.login(loginRequest);

      if (response.token!.isNotEmpty) {
        /// Login Successful
        loginToken = response.token!;
        Navigator.of(context).pushReplacementNamed('/');
        //
      } else {
        setState(() {
          isApiCallProcess = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.error!),
            duration: const Duration(seconds: 3),
            // action: SnackBarAction(
            //   label: 'ACTION',
            //   onPressed: () {},
            // ),
          ),
        );
      }
    }
  }
}
