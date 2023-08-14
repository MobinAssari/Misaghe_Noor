import 'package:flutter/material.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _form = GlobalKey<FormState>();
  var _enteredPassword = '';
  var _enteredEmail = '';

  void _submit() {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      print(_enteredPassword);
      print(_enteredEmail);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 76, 85, 93),
            ),
            width: 280,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                        decoration: const InputDecoration(
                          label: Text(
                            'نام کاربری',
                            style: TextStyle(color: Colors.white,),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'نام کاربری را به درستی وارد کنید';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _enteredEmail = value!;
                        }),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text(
                          'رمز عبور',
                          style: TextStyle(color: Colors.white),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 6) {
                          return 'رمز عبور حداقل ۶ حرف دارد';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _enteredPassword = value!;
                      },
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 191, 191, 203)),
                      child: const Text(
                        'ورود',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
