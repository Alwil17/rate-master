// Flutter/Dart SDK
import 'package:flutter/material.dart';
// Third-party packages
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
// Internal packages
import 'package:rate_master/providers/auth_provider.dart';
import 'package:rate_master/screens/auth/widgets/auth_vector.dart';
import 'package:rate_master/generated/assets.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:rate_master/shared/widgets/primary_button.dart';
import 'package:rate_master/shared/widgets/reusable_text_field.dart';
import 'package:rate_master/shared/widgets/text_field_builder.dart';
// Localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'widgets/auth_back_button.dart';
import 'widgets/auth_form_card.dart';
import 'widgets/auth_header_image.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  late AuthProvider auth;

  // Controllers for text fields to keep the state
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    auth = context.read<AuthProvider>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.clear();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    // Assume all fields are valid and non empty
    final Map<String, String> body = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    };


    final success = await context.read<AuthProvider>().register(body);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.registerFailed)),
      );
    }else {
      context.goNamed(APP_PAGES.splash.toName);
    }
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
                children: [AuthHeaderImage(), _buildRegisterForm(context)],
              ),
            ),
          )
        ],
      ),
    );
  }
  // Widget to build the registration form
  Widget _buildRegisterForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: AuthFormCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.registering,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // fullname field
              Text(
                AppLocalizations.of(context)!.fullname,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
              _buildFullNameField(),
              // email field
              Text(
                AppLocalizations.of(context)!.yourEmail,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
              _buildEmailField(),
              // password field
              Text(
                AppLocalizations.of(context)!.password,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),

              _buildPasswordField(),
              // Bouton de Connexion
              PrimaryButton(
                label: AppLocalizations.of(context)!.register,
                isLoading: auth.isLoading, // from your AuthProvider
                onPressed: auth.isLoading ? null : _register,
              ),
              SizedBox(height: 10),
              // Sign up now
              _buildSignInOption(),
            ],
          ),
        ));
  }
  // Widget to build the fullname field
  Widget _buildFullNameField(){
    return ReusableTextField(
        hintText: AppLocalizations.of(context)!.fullname,
        controller: _nameController,
        keyboardType: TextInputType.name,
        inputAction: TextInputAction.next,
        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
        validator: (v) {
          if (v == null || v.isEmpty) return AppLocalizations.of(context)!.enterName;
          return null;
        }
    );
  }

  // Widget to build the email field
  Widget _buildEmailField(){
    return ReusableTextField(
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
        }
    );
  }

  // Widget to build the password field
  Widget _buildPasswordField(){
    return ReusableTextField(
      hintText: AppLocalizations.of(context)!.passwordHint,
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: !_isPasswordVisible,
      inputAction: TextInputAction.done,
      onSubmitted: (_) => _register(),
      validator: (v) {
        if (v == null || v.isEmpty) return AppLocalizations.of(context)!.enterPassword;
        if (v.length < 6) return AppLocalizations.of(context)!.passwordTooShort;
        return null;
      },
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.passwordHint,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          tooltip: _isPasswordVisible
              ? AppLocalizations.of(context)!.hidePassword
              : AppLocalizations.of(context)!.showPassword,
        ),
      ),
    );
  }

  // Widget to show the option to sign in if the user already has an account
  Widget _buildSignInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.alreadyAccount),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            AppLocalizations.of(context)!.loginNow,
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
