// Flutter/Dart SDK
import 'package:flutter/material.dart';

// Third-party packages
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Internal packages
import 'package:rate_master/providers/auth_provider.dart';
import 'package:rate_master/screens/auth/widgets/auth_vector.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:rate_master/shared/theme/theme.dart';
import 'package:rate_master/shared/widgets/primary_button.dart';
import 'package:rate_master/shared/widgets/text_field_builder.dart';

// Localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'widgets/auth_back_button.dart';
import 'widgets/auth_header_image.dart';
import 'widgets/auth_call_to_action.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  late AuthProvider auth;

  // Controllers for text fields to keep the state
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.clear();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final success = await context.read<AuthProvider>().login(email, password);

    if (success) context.goNamed(APP_PAGES.splash.toName);
  }

  @override
  Widget build(BuildContext context) {
    auth = context.watch<AuthProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            child: CustomPaint(
              painter: AuthVector(),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width, height: 434),
            ),
          ),
          AuthBackButton(),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [AuthHeaderImage(), _buildLoginForm(context)],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Center(
          child: Card(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.logIn,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blueColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Champ Email/Téléphone
                  Text(
                    AppLocalizations.of(context)!.yourEmail,
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  _buildEmailField(),
                  // Champ Mot de passe
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.password,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () =>
                            context.pushNamed(APP_PAGES.forgotPassword.toName),
                        child: Text(
                          AppLocalizations.of(context)!.forgotPassword,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.blueColor),
                        ),
                      )
                    ],
                  ),

                  _buildPasswordField(),
                  if (auth.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(auth.error!,
                          style: TextStyle(color: Colors.red)),
                    ),
                  // Bouton de Connexion
                  PrimaryButton(
                    label: AppLocalizations.of(context)!.loginNow,
                    isLoading: auth.isLoading, // from your AuthProvider
                    onPressed: auth.isLoading ? null : _login,
                  ),
                  SizedBox(height: 10),
                  // Lien "S'inscrire maintenant"
                  AuthCallToAction(
                    label: AppLocalizations.of(context)!.noAccount,
                    actionText: AppLocalizations.of(context)!.registerNow,
                    onPressed: () => context.pushNamed(APP_PAGES.register.toName),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildEmailField(){
    return buildTextField(context,
        hintText: AppLocalizations.of(context)!.emailHint,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        inputAction: TextInputAction.next,
        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
        validator: (v) {
          if (v == null || v.isEmpty) return AppLocalizations.of(context)!.enterEmail;
          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
          if (!emailRegex.hasMatch(v)) return AppLocalizations.of(context)!.invalidEmail;

          return null;
        });
  }

  Widget _buildPasswordField(){
    return buildTextField(
      context,
      hintText: AppLocalizations.of(context)!.passwordHint,
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: !_isPasswordVisible,
      inputAction: TextInputAction.done,
      onSubmitted: (_) => _login(),
      validator: (v) {
        if (v == null || v.isEmpty) return AppLocalizations.of(context)!.enterPassword;
        if (v.length < 6) return AppLocalizations.of(context)!.passwordTooShort;
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
          ),
          onPressed: () => setState(
                  () => _isPasswordVisible = !_isPasswordVisible),
          tooltip: _isPasswordVisible
              ? AppLocalizations.of(context)!.hidePassword
              : AppLocalizations.of(context)!.showPassword,
        ),
      ),
    );
  }

  Widget _buildSignUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.noAccount),
        TextButton(
          onPressed: () {
            context.pushNamed(APP_PAGES.register.toName);
          },
          child: Text(
            AppLocalizations.of(context)!.registerNow,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.blueColor),
          ),
        ),
      ],
    );
  }
}
