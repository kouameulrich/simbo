import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:simbo_mobile/_api/apiService.dart';
import 'package:simbo_mobile/_api/dioException.dart';
import 'package:simbo_mobile/_api/tokenStorageService.dart';
import 'package:simbo_mobile/db/local.service.dart';
import 'package:simbo_mobile/db/repository.dart';
import 'package:simbo_mobile/models/Secteur.dart';
import 'package:simbo_mobile/models/TypeActiviteCommerciale.dart';
import 'package:simbo_mobile/models/agent.dart';
import 'package:simbo_mobile/models/dbhelper.dart';
import 'package:simbo_mobile/models/facture.dart';
import 'package:simbo_mobile/models/typeEquipement.dart';
import 'package:simbo_mobile/ui/pages/home.page.dart';
import 'package:simbo_mobile/widgets/default.colors.dart';
import 'package:simbo_mobile/widgets/error.dialog.dart';
import 'package:simbo_mobile/widgets/loading.indicator.dart';

import '../../_api/authService.dart';
import '../../di/service_locator.dart';
import '../../models/collectivite.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = locator<AuthService>();
  final apiService = locator<ApiService>();
  final dbHandler = locator<LocalService>();
  final storage = locator<TokenStorageService>();
  final TextEditingController _tenantController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool notvisible = true;
  Agent? agentConnected;
  Collectivite? collectiviteConnected;
  bool isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _tenantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.blueFondCadre,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Defaults.blueFondCadre,
      ),
      body: SingleChildScrollView(
        child: Theme(
          data: ThemeData(primarySwatch: Defaults.primaryBleuColor),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  //padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                      child: Image.asset(
                    'images/logo_exports-02.png',
                    width: 200,
                    height: 200,
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 35, bottom: 0),
                  //padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: _tenantController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrer un locataire';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: null, icon: Icon(Icons.list_rounded)),
                      border: UnderlineInputBorder(),
                      labelText: 'Locataire',
                      hintText: 'Entrer votre locataire',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 35, bottom: 0),
                  child: TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrer un nom utilisateur';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Nom utilisateur',
                        hintText: 'Enter votre nom utilisateur'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 35, bottom: 0),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrer un mot de passe';
                      }
                      return null;
                    },
                    obscureText: notvisible,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(notvisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                notvisible = !notvisible;
                              });
                            }),
                        border: const UnderlineInputBorder(),
                        labelText: 'Mot de passe',
                        hintText: 'Entrer votre mot de passe'),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 35, bottom: 0),
                    child: Container(
                      height: 50,
                      width: 500,
                      child: ElevatedButton(
                        child: const Text('Connexion',
                            style:
                                TextStyle(color: Colors.white, fontSize: 25)),
                        onPressed: () async {
                          _submitLogin();
                        },
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      LoadingIndicatorDialog().show(context);
      log(_tenantController.text);
      try {
        var statusCode = await authService.authenticateUser(
            _tenantController.text.trim(),
            _usernameController.text.trim(),
            _passwordController.text);
        if (statusCode == 200) {
          agentConnected = await apiService
              .getUserConnected(_usernameController.text.trim());
          log(agentConnected.toString());
          storage.saveAgentConnected(agentConnected!);
          //get collectivite and save
          collectiviteConnected =
              await apiService.getCollectivite(_tenantController.text.trim());
          storage.saveCollectiviteConnected(collectiviteConnected!);
          print('-------collectivite---------------');
          print(collectiviteConnected.toString());
          await storage
              .retrieveCollectiviteConnected()
              .then((value) => collectiviteConnected = value!);
          print(collectiviteConnected.toString());
          // save secteurs in local database
          List<Secteur> secteurs = await apiService.getAllSecteurs();
          for (var secteur in secteurs) {
            dbHandler.SaveSecteur(secteur);
          }
          // save TypeEquipement in local database
          List<TypeEquipement> typeequipements =
              await apiService.getAllTypeEquipemnts();
          for (var typeequipement in typeequipements) {
            dbHandler.SaveTypeEquipement(typeequipement);
          }
          // save TypeActivite in local database
          List<TypeActiviteCommerciale> typeactivites =
              await apiService.getAllTypeActiviteCommerciale();
          for (var typeactivite in typeactivites) {
            dbHandler.SaveTypeActivite(typeactivite);
          }
          //Save facture in local database
          List<Facture> factures = await apiService
              .getFactureImpayeFromAgent(agentConnected!.matricule.toString());
          for (var facture in factures) {
            dbHandler.SaveFacture(facture);
          }

          //read facture
          //dbHandler.readFactureImpayeFromAgent().then((value) => print(value.length));

          LoadingIndicatorDialog().dismiss();
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => HomePage()));
        }
      } on DioError catch (e) {
        LoadingIndicatorDialog().dismiss();
        ErrorDialog().show(e);
      }
    }
  }
}
