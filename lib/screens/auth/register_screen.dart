
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/auth_provider.dart';
import 'package:rate_master/shared/theme/theme.dart';
import 'package:rate_master/screens/auth/widgets/auth_vector.dart';
import 'package:rate_master/generated/assets.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rate_master/shared/api/api_helper.dart';
import 'package:rate_master/shared/widgets/text_field_builder.dart';

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
    auth = Provider.of<AuthProvider>(context, listen: false);
  }

  Future<void> _register() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      final String fullname = _nameController.text.trim();
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty || fullname.isEmpty) {
        _showError('Veuillez remplir tous les champs.');
        return;
      }
      await EasyLoading.show(status: "loading...");

      // Créer le corps de la requête
      final Map<String, String> body = {
        'name': fullname,
        'email': email,
        'password': password,
      };

      final response = await auth.register(body);

      await EasyLoading.dismiss();

      if (response is bool && response == true) {
        await EasyLoading.showSuccess("Inscription réussie.");
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
                  child: PhosphorIcon(PhosphorIconsRegular.caretLeft, color: Theme.of(context).iconTheme.color,),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [_buildHeaderImage(), _buildRegisterForm(context)],
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

  Widget _buildRegisterForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
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
                buildTextField(context,
                    hintText: AppLocalizations.of(context)!.enterName,
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                inputAction: TextInputAction.next,
                ),
                // email field
                Text(
                  AppLocalizations.of(context)!.yourEmail,
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
                buildTextField(context,
                    hintText: 'Ex: test@example.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    inputAction: TextInputAction.next),
                // password field
                Text(
                  AppLocalizations.of(context)!.password,
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),

                _buildPasswordField(showIcon: false),
                // Bouton de Connexion
                _buildRegisterButton(),
                SizedBox(height: 10),
                // Sign up now
                _buildSignInOption(),
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

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _register,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: AppColors.accent, // Couleur bouton
          shape: StadiumBorder(),
        ),
        child: Text(
          AppLocalizations.of(context)!.register,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

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
