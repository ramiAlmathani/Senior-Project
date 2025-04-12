import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_verification_page.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({Key? key}) : super(key: key);

  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  String? _errorMessage;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateAndSendCode() async {
    String phoneNumber = _phoneController.text;

    if (phoneNumber.isEmpty || phoneNumber.length != 9 || !phoneNumber.startsWith('5')) {
      setState(() {
        _errorMessage = phoneNumber.isEmpty
            ? "Phone number cannot be empty"
            : !phoneNumber.startsWith('5')
            ? "Phone number must start with 5"
            : "Phone number must be 9 digits";
      });
      return;
    }

    String fullPhoneNumber = '+966$phoneNumber';

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _errorMessage = 'Verification failed: ${e.message}';
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => OTPVerificationPage(
                phoneNumber: phoneNumber,
                verificationId: verificationId,
              ),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error sending code: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
                    ),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(24),
                  child: const Icon(Icons.phone_android, size: 48, color: Colors.white),
                ),
                const SizedBox(height: 50),
                const Text(
                  "Verify Your Phone Number",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  maxLength: 9,
                  decoration: InputDecoration(
                    prefixText: '+966 ',
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: "5XXXXXXXX",
                    hintStyle: const TextStyle(color: Colors.grey),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty && (!value.startsWith('5') || value.length > 9)) {
                        _errorMessage = !value.startsWith('5')
                            ? "Phone number must start with 5"
                            : "Phone number must be 9 digits";
                      } else {
                        _errorMessage = null;
                      }
                    });
                  },
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _validateAndSendCode,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Send Verification Code",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
