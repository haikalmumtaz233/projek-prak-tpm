import 'package:flutter/material.dart';
import 'package:game_galaxy/models/users.dart';
import 'package:game_galaxy/utils/color.dart';
import 'package:game_galaxy/views/main_screen.dart';
import 'package:game_galaxy/views/register_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  late SharedPreferences pref;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoginTrue = false;

  final key = encrypt.Key.fromUtf8('my 32 length key................');
  final iv = encrypt.IV.fromUtf8("1234567890123456");

  void checkInputForLogin() async {
    var userBox = await Hive.openBox<Users>("userBox");
    bool userFound = false;

    for (int i = 0; i < userBox.length; i++) {
      if (userBox.getAt(i)!.username == _usernameController.text &&
          decryptData(userBox.getAt(i)!.password) == _passwordController.text) {
        userFound = true; // Set flag to true if credentials match
        pref = await SharedPreferences.getInstance();
        pref.setBool("logedIn", true);
        pref.setInt("accIndex", i);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
        break;
      }
    }

    if (!userFound) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Username or Password is Wrong"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }

    await userBox.close();
  }

  void clearUserBox() async {
    var userBox = await Hive.openBox<Users>("userBox");
    await userBox.clear();
    await userBox.close();
    print("All data in the userBox has been cleared.");
  }

  String decryptData(String encryptText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decrypted = encrypter.decrypt64(encryptText, iv: iv);

    return decrypted;
  }

  void checkIfLogedIn() async {
    pref = await SharedPreferences.getInstance();

    bool logedIn = pref.getBool("logedIn") ?? false;

    if (logedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return MainScreen();
      }));
    } else {}
  }

  @override
  void initState() {
    super.initState();
    checkIfLogedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hello, Gamers!',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: textColor1,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome, This is your place!',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: textColor2,
                  ),
                ),
                SizedBox(height: 50),

                // Username TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        controller: _usernameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Username is required!";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Username',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Password TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required!";
                          }
                          return null;
                        },
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Login Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: ElevatedButton(
                    onPressed: () {
                      checkInputForLogin();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.deepPurple.withOpacity(0.8);
                        }
                        return Colors.deepPurple;
                      }),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            checkInputForLogin;
                          },
                          child: Text(
                            'Login',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),

                // Register Field
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: GoogleFonts.poppins(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      child: Text(
                        ' Register Now',
                        style: GoogleFonts.poppins(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
