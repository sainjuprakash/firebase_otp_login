import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_login/src/constant/custom_text_field/custom_text_from_field.dart';
import 'package:otp_login/src/constant/themes/app_colors.dart';
import 'package:otp_login/src/features/phone_login/data/repository/phone_login_repository_impl.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_slash_fill;
  bool obscurePassword = true;
  String? _errorMsg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment:
                    const Alignment(-0.38, -1.09), // Adjusted alignment values
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFC4C4C4),
                  ),
                ),
              ),
              Align(
                alignment:
                    const Alignment(-0.6, -1.08), // Adjusted alignment values
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Log-In',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                MyTextField(
                                  controller: contactController,
                                  hintText: 'Enter Mobile Number',
                                  obsecureText: false,
                                  keyboardType: TextInputType.number,
                                  errorMsg: _errorMsg,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Enter Contact Number';
                                    } else if (val.length < 10) {
                                      return 'Enter Valid Contact Number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                !signInRequired
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: TextButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                String phoneNumber =
                                                    contactController.text;
                                                AuthRepo.verifyPhoneNumber(
                                                    context, phoneNumber);
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                                //elevation: 3.0,
                                                backgroundColor:
                                                    const Color(0xFF313131),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            35))),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25, vertical: 5),
                                              child: Text(
                                                'Send OTP',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            )))
                                    : const CircularProgressIndicator(),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              /*     Align(
                  alignment: const AlignmentDirectional(0, 0.92),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account ? "),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpPage()));
                          },
                          child: const Text(
                            " Register ?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ))
                    ],
                  )),*/
            ],
          ),
        ),
      ),
    );
  }
}
