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
import 'package:rate_master/shared/api/api_helper.dart';
import 'package:rate_master/shared/widgets/primary_button.dart';
import 'package:rate_master/shared/widgets/text_field_builder.dart';
import 'package:rate_master/shared/widgets/utils.dart';
// Localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
  void initState() {
    super.initState();
    auth = context.read<AuthProvider>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final success = await auth.login(email, password);

    if (success) {
      // return back to login
      context.goNamed(APP_PAGES.splash.toName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(8),
                    elevation: 1,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: PhosphorIcon(PhosphorIconsRegular.caretLeft, color: Theme.of(context).iconTheme.color,
                  semanticLabel: AppLocalizations.of(context)!.goBack,),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [_buildHeaderImage(), _buildLoginForm(context)],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Image.asset(
        Assets.imagesShootingStar, // Votre image du médecin ici
        height: 120, // Vous pouvez ajuster la hauteur
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Center(
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child:  Padding(padding: EdgeInsets.all(20), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context)!.logIn,
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
                // Champ Email/Téléphone
                Text(
                  AppLocalizations.of(context)!.yourEmail,
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
                buildTextField(
                    context,
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
                ),
                // Champ Mot de passe
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.password,
                      style:
                      const TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () => context.pushNamed(APP_PAGES.forgotPassword.toName),
                      child: Text(
                        AppLocalizations.of(context)!.forgotPassword,
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    )
                  ],
                ),

                buildTextField(
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
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      tooltip: _isPasswordVisible
                          ? AppLocalizations.of(context)!.hidePassword
                          : AppLocalizations.of(context)!.showPassword,
                    ),
                  ),
                ),
                if (auth.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(auth.error!, style: TextStyle(color: Colors.red)),
                  ),
                // Bouton de Connexion
                PrimaryButton(
                  label: AppLocalizations.of(context)!.loginNow,
                  isLoading: auth.isLoading, // from your AuthProvider
                  onPressed: auth.isLoading ? null : _login,
                ),
                SizedBox(height: 10),
                // Lien "S'inscrire maintenant"
                _buildSignUpOption(),
              ],
            ),) ,
          ),
        ));
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
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
