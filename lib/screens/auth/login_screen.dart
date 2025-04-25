import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/app_state_provider.dart';
import 'package:rate_master/providers/auth_provider.dart';
import 'package:rate_master/shared/theme/theme.dart';
import 'package:rate_master/models/user.dart';
import 'package:rate_master/screens/auth/register_screen.dart';
import 'package:rate_master/screens/auth/widgets/auth_vector.dart';
import 'package:rate_master/generated/assets.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:rate_master/shared/api/api_helper.dart';
import 'package:rate_master/shared/api/api_routes.dart';
import 'package:http/http.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rate_master/shared/widgets/text_field_builder.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  late AuthProvider auth;

  // Controllers for text fields to keep the state
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthProvider>(context, listen: false);
  }

  Future<void> _login() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      final String user = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      if (user.isEmpty || password.isEmpty) {
        _showError('Veuillez remplir tous les champs.');
        return;
      }

      setState(() {
        _isLoading = true;
      });
      await EasyLoading.show(status: "loading...");

      // Créer le corps de la requête
      final Map<String, String> body = {
        'username': user,
        'password': password,
      };
      final response = await auth.login(user, password);

      await EasyLoading.dismiss();

      if (response is bool && response == true) {
        await EasyLoading.showSuccess("Connexion réussie");
        // return back to login
        context.goNamed(APP_PAGES.splash.toName);
      } else if (response is Map<String, dynamic> && response.containsKey('detail')) {
        final errorMessages = ApiHelper.parseApiErrors(response['detail']);
        _showError(errorMessages.join("\n"));
      } else {
        _showError('Une erreur inconnue est survenue.');
      }
      await EasyLoading.dismiss();
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Erreur'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 15,
            child: SizedBox(
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: PhosphorIcon(
                      PhosphorIconsRegular.arrowLeft,
                    size: 30,
                    color: Colors.black,
                  )),
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
        height: 150, // Vous pouvez ajuster la hauteur
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
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
                  hintText: 'test@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  inputAction: TextInputAction.next
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
                      onPressed: () {},
                      child: Text(
                        AppLocalizations.of(context)!.forgotPassword,
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    )
                  ],
                ),

                _buildPasswordField(showIcon: false),
                // Bouton de Connexion
                _buildLoginButton(),
                SizedBox(height: 10),
                // Lien "S'inscrire maintenant"
                _buildSignUpOption(),
              ],
            ),
          ),
        ));
  }

  Widget _buildPasswordField({bool showIcon = true}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.done,
        obscureText: !_isPasswordVisible,
        controller: _passwordController,
        decoration: InputDecoration(
          prefixIcon: showIcon ? Icon(Icons.vpn_key) : null,
          hintText: '********',
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: AppColors.accent, // Couleur bouton
          shape: StadiumBorder(),
        ),
        child: Text(
          AppLocalizations.of(context)!.loginNow,
          style: TextStyle(fontSize: 16, color: Colors.white),
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
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
