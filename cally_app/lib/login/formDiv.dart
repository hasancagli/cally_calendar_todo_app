// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, duplicate_ignore

import 'package:cally_app/net/flutterfire.dart';
import 'package:flutter/material.dart';
import 'package:cally_app/assets/show_message.dart';

class FormDiv extends StatefulWidget {
  final String type; // "register" or "login"

  const FormDiv({Key? key, required this.type}) : super(key: key);

  @override
  State<FormDiv> createState() => _FormDivState();
}

class _FormDivState extends State<FormDiv> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: _emailField,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Email',
            ),
          ),
          Container(
            height: 30,
          ),
          TextFormField(
            controller: _passwordField,
            obscureText: true,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Password',
            ),
          ),
          Container(
            height: 30,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              // <-- TextButton
              onPressed: () async {
                // IF THE BUTTON == REGISTER
                if (widget.type == 'register') {
                  List returnedList =
                      await register(_emailField.text, _passwordField.text);
                  String success = returnedList[0];
                  String message = returnedList[1];
                  if (success == 'success') {
                    Navigator.pushReplacementNamed(context, '/home');
                    showMessage(
                        context: context, text: message, type: 'success');
                  } else {
                    showMessage(context: context, text: message, type: 'error');
                  }
                }
                // IF THE BUTTON == LOGIN
                else {
                  List returnedList =
                      await signIn(_emailField.text, _passwordField.text);
                  String success = returnedList[0];
                  String message = returnedList[1];
                  if (success == 'success') {
                    Navigator.pushReplacementNamed(context, '/home');
                    showMessage(
                        context: context, text: message, type: 'success');
                  } else {
                    showMessage(context: context, text: message, type: 'error');
                  }
                }
              },

              label: Text(widget.type == 'login' ? "Login" : 'Register'),

              icon: widget.type == 'login'
                  ? const Icon(
                      Icons.login,
                      size: 24.0,
                    )
                  : const Icon(
                      Icons.edit,
                      size: 24.0,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
