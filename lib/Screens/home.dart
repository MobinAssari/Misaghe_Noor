import 'package:flutter/material.dart';
import 'package:misaghe_noor/Screens/meetings.dart';
import 'package:misaghe_noor/Screens/members.dart';
import 'package:misaghe_noor/Screens/usersList.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/wallpaper6.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const MeetingsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(102, 206, 203, 203),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 188, 148, 84)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                    child: const Text(
                      'جلسات',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'IranYekan',
                      ),
                    ),
                  ),
                ),
                const Divider(height: 36),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const MembersScreen(
                            picking: false,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(102, 206, 203, 203),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 188, 148, 84)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                    child: const Text(
                      'اعضا',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'IranYekan',
                      ),
                    ),
                  ),
                ),
                const Divider(height: 36),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const UsersListScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(102, 206, 203, 203),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 188, 148, 84)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                    child: const Text(
                      'کاربران',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'IranYekan',
                      ),
                    ),
                  ),
                ),
                const Divider(height: 36),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(102, 206, 203, 203),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 188, 148, 84)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                    child: const Text(
                      'گزارشات',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'IranYekan',
                      ),
                    ),
                  ),
                ),
                const Divider(height: 65),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
