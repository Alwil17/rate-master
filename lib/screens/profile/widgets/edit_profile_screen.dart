import 'package:flutter/material.dart';
import 'package:rate_master/shared/widgets/text_field_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec des données existantes
    _nameController.text = "Nom actuel";
    _emailController.text = "email@example.com";
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Logique pour sauvegarder les modifications
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.profileUpdated)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.editMyProfile)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Champ Nom
              Text(
                AppLocalizations.of(context)!.fullname,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
              buildTextField(
                context,
                hintText: AppLocalizations.of(context)!.enterName,
                controller: _nameController,
                keyboardType: TextInputType.name,
                inputAction: TextInputAction.next,
              ),
              // Champ Email
              Text(
                AppLocalizations.of(context)!.yourEmail,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
              buildTextField(
                context,
                hintText: 'Ex: test@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
              ),
              // Champ Mot de passe
              Text(
                AppLocalizations.of(context)!.password,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  obscureText: !_isPasswordVisible,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: '********',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              // Bouton Sauvegarder
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.saveChanges,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}