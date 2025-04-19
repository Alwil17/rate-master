import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/core/providers/app_state_provider.dart';
import 'package:rate_master/features/auth/models/user.dart';
import 'package:rate_master/features/auth/widgets/auth_vector.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:rate_master/shared/api/api_routes.dart';
import 'package:http/http.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  late AppStateProvider prefs;

  // Controllers for text fields to keep the state
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    prefs = Provider.of<AppStateProvider>(context, listen: false);
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
        'user': user,
        'password': password,
      };

      try {
        // Effectuer la requête POST
        final response = await post(
          Uri.parse(ApiRoutes.login), // Remplacez par votre URL
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          // Si le login est correct, on stocke le token
          if (responseData['status'] == 200) {
            await _saveLoginData(responseData);
            await EasyLoading.dismiss();
            await EasyLoading.showSuccess("Connecté avec succès");
            await EasyLoading.dismiss();
            _navigateToHome();
          } else {
            _showError(responseData['message'] ?? 'Erreur de connexion.');
          }
        } else {
          _showError('Erreur du serveur : ${response.body}');
        }
      } catch (error, s) {
        print(error);
        debugPrintStack(stackTrace: s);
        _showError('Une erreur est survenue. Vérifiez votre connexion.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
      await EasyLoading.dismiss();
    }


  }

  Future<void> _saveLoginData(Map<String, dynamic> datas) async {
    // Récupérer les données du patient et le token
    String token = datas['token'];
    Map<String, dynamic> patientData = datas['data'];


    // Créer un objet User à partir des données reçues
    User user = User.fromJson({
      ...patientData, // Combine les données du patient
      'token': token  // Ajoute le token dans les données
    });

    //print(user.toJson());

    // Sauvegarder les données utilisateur dans le UserProvider
    prefs.user = user;
    prefs.loggedIn = true;
  }

  void _navigateToHome() {

    context.goNamed(APP_PAGES.splash.toName);
    /*Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()), // Votre page d'accueil
    );*/
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
            top: MediaQuery.of(context).padding.top,
            right: 20,
            child: SizedBox(
              child: Image.asset(
                'assets/images/logo.PNG',
                height: 80,
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
        'assets/images/doctor_image.png', // Votre image du médecin ici
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
                  AppLocalizations.of(context)!.phoneOrEmail,
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
                _buildTextField(
                  hintText: 'Exemple: 24156333538',
                  icon: Icons.alternate_email,
                ),
                // Champ Mot de passe
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.password,
                      style: const TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        context.goNamed(APP_PAGES.forgetPassword.toName);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.forgotPassword,
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    )
                  ],
                ),

                _buildPasswordField(),
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

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        autofocus: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Veuillez entrer un email ou telephone valide";
          }
          return null;
        },
        controller: _emailController,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.done,
        obscureText: !_isPasswordVisible,
        controller: _passwordController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
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
          backgroundColor: Color(0xFF056380), // Couleur bouton
          shape: StadiumBorder(),
        ),
        child: Text(
          AppLocalizations.of(context)!.loginNow,
          style: TextStyle(fontSize: 16),
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
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => RegisterScreen()));
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
