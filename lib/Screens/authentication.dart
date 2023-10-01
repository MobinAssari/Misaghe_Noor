import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misaghe_noor/Screens/home.dart';
import 'package:misaghe_noor/helper/ConnectToDataBase.dart';
import 'package:misaghe_noor/models/user.dart';
import 'package:misaghe_noor/provider/users_provider.dart';

String enteredUserId = '';

//todo message if username didn't found
class AuthenticationScreen extends ConsumerStatefulWidget {
  AuthenticationScreen({super.key});

  @override
  ConsumerState<AuthenticationScreen> createState() =>
      _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  bool isLoading = false;

  final _form = GlobalKey<FormState>();

  String _enteredPassword = '';

  String _enteredEmail = '';

  final TextEditingController userController = TextEditingController();

  final TextEditingController passController = TextEditingController();

  @override
  Widget build(context) {
    void submit() async {


      if (_form.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        _form.currentState!.save();
        final loadedItems = await connectToDataBase.loadUser();
        ref.read(usersProvider.notifier).addUsers(loadedItems.cast<User>());
        final userList = ref.watch(usersProvider);

        if(userList.isEmpty){
          setState(() {
            isLoading = false;
            showDialog(
              context: context,
              builder: (ctx) =>  Directionality(textDirection: TextDirection.rtl,
                child: AlertDialog(
                    content: const Text('خطا'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('تایید'))
                    ]),
              ),
            );
          });
        }
        else{
        for (var user in userList) {
          if (user.userName == userController.text.trim()) {
            if (user.password == passController.text.trim()) {
              enteredUserId = user.id;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => const HomeScreen(),
                ),
              );
            }
          } else {
            setState(() {
              isLoading = false;
              showDialog(
                context: context,
                builder: (ctx) =>  Directionality(textDirection: TextDirection.rtl,
                  child: AlertDialog(
                      content: const Text('اطلاعات وارد شده اشتباه است'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('تایید'))
                      ]),
                ),
              );
            });
          }}
        }
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/wallpaper2.png'),
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
                            style: const TextStyle(color: Colors.white54),
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
                          style: const TextStyle(color: Colors.white54),
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
                            if (value == null || value.trim().length < 4) {
                              return 'رمز عبور حداقل 4 حرف دارد';
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
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? () {} : submit,
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 191, 191, 203)),
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'ورود',
                                    style: TextStyle(color: Colors.black),
                                  ),
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
      ),
    );
  }
}
