import 'package:fishing_lab/constants/colors.dart';
import 'package:fishing_lab/services/auth_service.dart';
import 'package:fishing_lab/widgets/auth_widgets/auth_input.dart';
import 'package:fishing_lab/widgets/auth_widgets/auth_logo.dart';
import 'package:fishing_lab/widgets/auth_widgets/full_width_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class ForgotScreen extends StatefulWidget {
  static const route = '/reset-screen';
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void showErrorMessage(String error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          error,
        ),
        duration: const Duration(milliseconds: 800),
        showCloseIcon: true,
        closeIconColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }

    Future submit() async {
      if (_controller!.text.isEmpty) {
        return showErrorMessage('Fill an empty field.');
      }
      if (!RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(_controller!.text)) {
        return showErrorMessage('Invalid Email address!');
      }
      await AuthService().resetPassword(_controller!.text.trim()).then(
        (message) {
          if (message == 'User is not found.') {
            return showErrorMessage(message);
          } else {
            Navigator.pop(context);
          }
        },
      );
    }

    void resetPassword(String text) {}

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: mainColor,
          leadingWidth: 100,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    const AuthLogo(),
                    const SizedBox(
                      height: 40,
                    ),
                    const Center(
                      child: LocaleText(
                        'Reset Password',
                        style: TextStyle(
                            fontFamily: 'PlayFair',
                            fontSize: 28,
                            color: mainColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AuthInput(
                        controller: _controller!,
                        text: 'Email',
                        callback: resetPassword),
                    const SizedBox(
                      height: 20,
                    ),
                    FullWithButton(text: 'Reset', callback: submit),
                  ]),
            ),
          ),
        ));
  }
}
