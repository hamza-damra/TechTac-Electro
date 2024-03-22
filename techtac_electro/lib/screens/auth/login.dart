import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:techtac_electro/consts/my_validators.dart';
import 'package:techtac_electro/widgets/app_name_text.dart';
import 'package:techtac_electro/widgets/auth/google_btn.dart';
import 'package:techtac_electro/widgets/subtitle_text.dart';
import 'package:techtac_electro/widgets/text_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final _formKey = GlobalKey<FormState>();
  bool obscureText = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    // Focus Nodes
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  Future<void> _loginfct() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                const AppNameTextWidget(fontSize: 30),
                const SizedBox(
                  height: 16,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: TitlesTextWidget(label: "Welcome back")),
                const SizedBox(
                  height: 16,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Email address",
                          prefixIcon: Icon(IconlyLight.message),
                        ),
                        validator: (value) {
                          return MyValidators.emailValidator(value);
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                            hintText: "********",
                            prefixIcon: const Icon(
                              IconlyLight.lock,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            )),
                        validator: (value) {
                          return MyValidators.passwordValidator(value);
                        },
                        onFieldSubmitted: (value) {
                          _loginfct();
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const SubtitleTextWidget(
                            label: "Forgot password?",
                            textDecoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(12),
                            //backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.login),
                          label: const Text(
                            "Login",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () async {
                            _loginfct();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SubtitleTextWidget(
                        label: "OR connect using".toUpperCase(),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: kBottomNavigationBarHeight + 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Expanded(
                                child: SizedBox(
                                  height: kBottomNavigationBarHeight,
                                  child: FittedBox(
                                    child: GoogleButton(),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: kBottomNavigationBarHeight,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(12),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      "Guest",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      _loginfct();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SubtitleTextWidget(
                              label: "Don't have an account?"),
                          TextButton(
                            onPressed: () {},
                            child: const SubtitleTextWidget(
                              label: "Sign up",
                              textDecoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
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
