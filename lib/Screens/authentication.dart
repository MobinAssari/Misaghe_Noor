import 'package:flutter/material.dart';
import 'package:misaghe_noor/data/dummy_user.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _form = GlobalKey<FormState>();
  var _enteredPassword = '';
  var _enteredEmail = '';
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  void _submit() {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      print(_enteredPassword);
      print(_enteredEmail);
      for(var user in dummyUser){
        if(user.userName == userController.text.trim()){
          if
        }
      }
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mosque.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(148, 0, 0, 0),
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
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          controller: userController,
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
                        controller: passController,
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
        ],
      ),
    );
  }
}
