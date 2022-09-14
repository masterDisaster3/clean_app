// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:animated_background/animated_background.dart';
import 'package:clean_app/data/constants/enums.dart';
import 'package:clean_app/data/constants/size.dart';
import 'package:clean_app/data/constants/ui.dart';
import 'package:clean_app/logic/repositories/repository.dart';
import 'package:clean_app/presentation/pages/screens/edit_profile.dart';
import 'package:clean_app/presentation/widgets/app_scaffold.dart';
import 'package:clean_app/presentation/widgets/fancy_container.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:iconsax/iconsax.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  static const name = "Registration";

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: name),
      builder: (context) => const Registration(),
    );
  }

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration>
    with SingleTickerProviderStateMixin {
  bool visibleSignUpPass = true;

  bool visibleConfirm = true;

  bool visibleSignInPass = true;

  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DialogPage currentDialogPage = DialogPage.loginOrSignup;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBackground(
            behaviour: RandomParticleBehaviour(options: particles),
            vsync: this,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: FancyContainer(
                  color1: const Color.fromARGB(255, 206, 238, 169),
                  color2: const Color.fromARGB(255, 185, 226, 245),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _isLoading
                        ? const SizedBox(
                            height: 150,
                            child: preloader,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (currentDialogPage ==
                                  DialogPage.termsOfService)
                                ...termsOfService(),
                              if (currentDialogPage == DialogPage.loginOrSignup)
                                ...loginOrSignUp(),
                              if (currentDialogPage == DialogPage.login)
                                ...login(),
                              if (currentDialogPage == DialogPage.signUp)
                                ...signUp(),
                              if (currentDialogPage == DialogPage.verify)
                                ...verify(),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: IconButton(
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    ));
  }

  List<Widget> termsOfService() {
    return [
      const Text(
        "Authentication required!",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        height: 200,
        child: FutureBuilder(
          future: rootBundle.loadString('assets/md/terms_of_services.md'),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              final mdData = snapshot.data;
              if (mdData == null) {
                return const Center(
                  child: Text('Error loading Terms of Service'),
                );
              }
              return Markdown(data: mdData);
            }
            return preloader;
          },
        ),
      ),
      const SizedBox(height: 8),
      ElevatedButton(
          onPressed: () async {
            log("Terms and conditions are agreed ");
            setState(() {
              currentDialogPage = DialogPage.loginOrSignup;
            });
            await RepositoryProvider.of<Repository>(context)
                .agreedToTermsOfService();
          },
          child: const Text("agree"))
    ];
  }

  List<Widget> loginOrSignUp() {
    return [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentDialogPage = DialogPage.login;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Sign In", style: smallWhite),
                  )),
            ),
            const Text("OR", style: smallWhite),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentDialogPage = DialogPage.signUp;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Sign Up", style: smallWhite),
                  )),
            )
          ],
        ),
      ),
    ];
  }

  List<Widget> login() {
    return [
      Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Iconsax.arrow_left,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      currentDialogPage = DialogPage.loginOrSignup;
                    });
                  },
                ),
                const SizedBox(width: 90),
                const Text(
                  'Sign in',
                  style: mediumBlack,
                ),
              ],
            ),
            const SizedBox(height: 24.5),
            TextFormField(
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !EmailValidator.validate(_emailController.text)) {
                  return "Please enter correct email @address!";
                } else {
                  return null;
                }
              },
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(
                  Iconsax.link,
                  color: supaGreenColor,
                ),
              ),
            ),
            const SizedBox(height: 24.5),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 6) {
                  return "Seriously??";
                } else {
                  return null;
                }
              },
              controller: _passwordController,
              obscureText: visibleSignInPass,
              decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(
                    Iconsax.lock,
                    color: supaGreenColor,
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          visibleSignInPass = !visibleSignInPass;
                        });
                      },
                      icon: visibleSignInPass
                          ? const Text(
                              "🙈",
                              style: TextStyle(fontSize: 20),
                            )
                          : const Text("🐵", style: TextStyle(fontSize: 20)))),
            ),
            const SizedBox(height: 24.5),
            ElevatedButton(
              onPressed: () async {
                log("Signing in is in process");
                if (_formKey.currentState!.validate()) {
                  try {
                    setState(() {
                      _isLoading = true;
                    });

                    final repository =
                        RepositoryProvider.of<Repository>(context)
                          ..statusKnown = Completer<void>();
                    final persistSessionString = await repository.signIn(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

                    //log("Got the persist session from supabase: $persistSessionString");

                    await repository.setSessionString(persistSessionString);
                    await repository.statusKnown.future;

                    final myProfile = repository.myProfile;
                    log("Profile details : $myProfile");

                    if (myProfile == null) {
                      await Navigator.of(context).pushReplacement(
                        EditProfile.route(isCreatingAccount: true),
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  } on PlatformException catch (err) {
                    setState(() {
                      _isLoading = false;
                    });
                    showGradientFlushbar(
                        context, err.message ?? "Error signing in");
                    return;
                  } catch (err) {
                    setState(() {
                      _isLoading = false;
                    });
                    showGradientFlushbar(context, "Error signing in");
                  }
                }
              },
              child: const Text("Sign in"),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> signUp() {
    return [
      Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Iconsax.arrow_left,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      currentDialogPage = DialogPage.loginOrSignup;
                    });
                  },
                ),
                const SizedBox(width: 90),
                const Text(
                  'Sign up',
                  style: mediumBlack,
                ),
              ],
            ),
            const SizedBox(height: 24.5),
            TextFormField(
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !EmailValidator.validate(_emailController.text)) {
                  return "Please enter correct email @address!";
                } else {
                  return null;
                }
              },
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(
                  Iconsax.link,
                  color: supaGreenColor,
                ),
              ),
            ),
            const SizedBox(height: 24.5),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 6) {
                  return "Password is too weak!!";
                } else {
                  return null;
                }
              },
              obscureText: visibleSignUpPass,
              controller: _passwordController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(
                    Iconsax.lock,
                    color: supaGreenColor,
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          visibleSignUpPass = !visibleSignUpPass;
                        });
                      },
                      icon: visibleSignUpPass
                          ? const Text(
                              "🙈",
                              style: TextStyle(fontSize: 20),
                            )
                          : const Text("🐵", style: TextStyle(fontSize: 20)))),
            ),
            const SizedBox(height: 24.5),
            TextFormField(
              validator: (value) {
                if (value == null || value != _passwordController.text) {
                  return "Password don't match!";
                } else {
                  return null;
                }
              },
              controller: _confirmPasswordController,
              obscureText: visibleConfirm,
              decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(
                    Iconsax.password_check,
                    color: supaGreenColor,
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          visibleConfirm = !visibleConfirm;
                        });
                      },
                      icon: visibleConfirm
                          ? const Text(
                              "🙈",
                              style: TextStyle(fontSize: 20),
                            )
                          : const Text("🐵", style: TextStyle(fontSize: 20)))),
            ),
            const SizedBox(height: 24.5),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    setState(() {
                      _isLoading = true;
                    });

                    final persistSessionString =
                        await RepositoryProvider.of<Repository>(context).signUp(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    await RepositoryProvider.of<Repository>(context)
                        .setSessionString(persistSessionString);

                    await Navigator.of(context).pushReplacement(
                      EditProfile.route(isCreatingAccount: true),
                    );
                  } on PlatformException catch (err) {
                    setState(() {
                      _isLoading = false;
                    });
                    showGradientFlushbar(
                        context, err.message ?? "Error signing upp");
                    return;
                  } catch (err) {
                    setState(() {
                      _isLoading = false;
                    });
                    showGradientFlushbar(
                        context, "Please confirm your email and login!");
                    setState(() {
                      currentDialogPage = DialogPage.verify;
                    });
                  }
                }
              },
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> verify() {
    return [
      Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Iconsax.arrow_left,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    currentDialogPage = DialogPage.signUp;
                  });
                },
              ),
              const SizedBox(
                width: 150,
              ),
              const Text(
                'Verify',
                style: mediumBlack,
              ),
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          Image.asset(
            "assets/images/check your email.gif",
            height: 125.0,
            width: 125.0,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  currentDialogPage = DialogPage.login;
                });
              },
              child: const Text("I have received the mail"))
        ],
      )
    ];
  }

  Future<void> _checkTermsOfServiceAgreement() async {
    final agreed = await RepositoryProvider.of<Repository>(context)
        .hasAgreedToTermsOfService;
    if (!agreed) {
      setState(() {
        currentDialogPage = DialogPage.termsOfService;
      });
    }
  }

  @override
  void initState() {
    _checkTermsOfServiceAgreement();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}



// masterHutirar@tutanota.com
// btdnyr6yrtherbd