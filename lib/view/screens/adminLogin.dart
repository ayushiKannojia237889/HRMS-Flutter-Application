import 'package:attendence_geofence/view/screens/useradminscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Services/post/authentication/admin_login_service.dart';
import '../../app_constants/appconstants.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  bool isHidden = true;


  bool isDataUploading = false;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: _widget(),
    );
  }

  Widget _widget() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff9a8ec4),
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined,color: Colors.white),
          onPressed: () {
            AppConstants.pageTransition(context, const UserScreen());
          },
        ),
        title: const Text(
          'Admin Login',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 10.0, right: 10.0, top: 30.0, bottom: 0.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your mobile number',
                      style: TextStyle(fontSize: 18,
                          color: Color(0xff9a8ec4)
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        controller: mobileNumberController,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(15),
                          border: InputBorder.none,
                          counterText: "",
                          hintText: "Mobile Number",
                          hintStyle: TextStyle(color: Colors.black54),
                          prefixIcon:
                          Icon(Icons.phone, size: 18, color: Color(0xff9a8ec4)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        obscureText: isHidden,
                        controller: passwordController,
                        decoration:  InputDecoration(
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(15),
                          border: InputBorder.none,
                          counterText: "",
                          hintText: "Enter your Password",
                          hintStyle: TextStyle(color: Colors.black54),
                          suffixIcon: IconButton(
                            icon: isHidden?Icon(Icons.visibility_off,
                                color:Color(0xff5e4f9c))
                              :
                            Icon(Icons.visibility,color:Color(0xff5e4f9c)),
                            onPressed: togglePasswordVisibility,
                          ),
                          prefixIcon:
                          Icon(Icons.lock, size: 18, color: Color(0xff9a8ec4)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 48.0,
                child: GestureDetector(
                  onTap: () async {
                    if (mobileNumberController.text.isEmpty) {
                      AppConstants.showSnackBar(context,
                          "Please enter your mobile number.", Colors.red);
                    } else if (mobileNumberController.text.length < 10) {
                      AppConstants.showSnackBar(
                          context, "Mobile number not valid.", Colors.red);
                    }
                    else if (passwordController.text.isEmpty) {
                      AppConstants.showSnackBar(
                        context,
                        "Please enter Password.",
                        Colors.red,
                      );
                    }
                    else if (passwordController.text.isNotEmpty &&
                        passwordController.text.length <5) {
                      AppConstants.showSnackBar(
                        context,
                        "Password should be 5 digits.",
                        Colors.red,
                      );
                    }

                    else {
                      setState(() => isDataUploading = true);
                      print("Password:" +passwordController.text);
                      AdminLoginService.AdminLoginUser(
                          context,
                          mobileNumberController.text,
                          passwordController.text
                      ).then(
                            (value) => setState(
                              () => isDataUploading = false,
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xff9a8ec4),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                      child: isDataUploading
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // const SizedBox(height: 20),
              // Row(
              //   children: [
              //     Expanded(
              //       flex: 5,
              //       child: Divider(
              //         indent: 20,
              //         thickness: 1,
              //         color: Colors.blueGrey.shade200,
              //       ),
              //     ),
              //     const SizedBox(width: 10),
              //     const Expanded(
              //       flex: 1,
              //       child: Text(
              //         "OR",
              //         style: TextStyle(
              //           color: Color(0xff9a8ec4),
              //           fontSize: 16,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       flex: 5,
              //       child: Divider(
              //         thickness: 1,
              //         endIndent: 20,
              //         color: Colors.blueGrey.shade200,
              //       ),
              //     ),
              //   ],
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text(
              //       "Don't have an account ?",
              //     ),
              //     TextButton(
              //       onPressed: () {
              //         AppConstants.pageTransition(
              //           context,
              //           const RegistrationScreen(),
              //         );
              //       },
              //       child: const Text(
              //         'Register now',
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           color: Color(0xff9a8ec4),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);

}
