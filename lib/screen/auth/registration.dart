import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../firebase/firebase_auth.dart';
import '../../model/firebase_response.dart';
import '../../util/helper.dart';
import '../../widget/my_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> with Helper {
  late TextEditingController _passwordController;
  late TextEditingController _emailController;

  @override
  void initState() {
    // TODO: implement initState
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool indicator = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: indicator,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 180,
                child: Image.asset('images/logo.png'),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: _emailController,
                textAlign: TextAlign.center,
                onChanged: (value) {},
                decoration: const InputDecoration(
                  hintText: 'Enter your Email',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                textAlign: TextAlign.center,
                onChanged: (value) {},
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              MyButton(
                color: Colors.blue[800]!,
                title: 'register',
                onPressed: () async => await _performRegister(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _performRegister() async {
    if (checkData()) {
      await register();
    }
  }

  bool checkData() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context,
        message:
        'Required Data, Please Enter your information Password, Email and full Name ',
        error: true);
    return false;
  }

  Future<void> register() async {
    setState(() {
      indicator = true;
    });
    FBResponse fbResponse = await FBAuthController().create(
        email: _emailController.text, password: _passwordController.text);
    showSnackBar(context,
        message: fbResponse.message, error: !fbResponse.status);
    setState(() {
      indicator = false;
    });
    if (fbResponse.status) {
      Navigator.pop(context);
    }
  }
}