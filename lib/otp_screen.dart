// import 'package:flutter/material.dart';
// import 'package:otp_login/src/features/phone_login/data/repository/phone_login_repository_impl.dart';
//
// class OtpScreen extends StatefulWidget {
//   const OtpScreen({super.key});
//
//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends State<OtpScreen> {
//   TextEditingController otpController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.purple.shade100,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'OTP',
//                 style: TextStyle(
//                   shadows: [
//                     Shadow(
//                       color: Colors.black,
//                       offset: Offset(1, 2),
//                     ),
//                   ],
//                   color: Colors.white,
//                   fontSize: 28,
//                   fontStyle: FontStyle.italic,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(
//                 height: 40,
//               ),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 controller: otpController,
//                 decoration: const InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(15),
//                       ),
//                     ),
//                     labelText: "Enter Otp"),
//               ),
//               ElevatedButton(
//                 style: const ButtonStyle(
//                     backgroundColor: MaterialStatePropertyAll(Colors.blue),
//                     foregroundColor: MaterialStatePropertyAll(Colors.white)),
//                 onPressed: () {
//                   AuthRepo.submitOtp(context, otpController.text);
//                 },
//                 child: const Text("Submit OTP"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:otp_login/src/features/phone_login/data/repository/phone_login_repository_impl.dart';

class OtpInputPage extends StatefulWidget {
  const OtpInputPage({Key? key}) : super(key: key);

  @override
  State<OtpInputPage> createState() => _OtpInputPageState();
}

class _OtpInputPageState extends State<OtpInputPage> {
  // Controllers for each OTP digit field
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  // FocusNodes to switch focus between fields
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      // Move to the next field if a digit is entered and it's not the last field
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      // Move to the previous field if the input is cleared
      _focusNodes[index - 1].requestFocus();
    }
  }

  String getOtpCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter the 6-digit OTP',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 40,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      onChanged: (value) => _onOtpChanged(index, value),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () {
                    final otpCode = getOtpCode();
                    //  AuthRepo.submitOtp(context, otpCode);
                    if (otpCode.length == 6) {
                      // Handle OTP verification
                      AuthRepo.submitOtp(context, otpCode);
                      print("Entered OTP: $otpCode");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please enter all 6 digits")),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                      //elevation: 3.0,
                      backgroundColor: const Color(0xFF313131),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35))),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: Text(
                      'Send OTP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
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
