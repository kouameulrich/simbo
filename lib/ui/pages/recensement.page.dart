import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simbo_mobile/_api/apiService.dart';
import 'package:simbo_mobile/_api/tokenStorageService.dart';
import 'package:simbo_mobile/db/local.service.dart';
import 'package:simbo_mobile/di/service_locator.dart';
import 'package:simbo_mobile/models/Secteur.dart';
import 'package:simbo_mobile/models/TypeActiviteCommerciale.dart';
import 'package:simbo_mobile/models/agent.dart';
import 'package:simbo_mobile/models/sexeContribuable.dart';
import 'package:simbo_mobile/models/typeContribuable.dart';
import 'package:simbo_mobile/models/typeEquipement.dart';
import 'package:simbo_mobile/ui/pages/liste.recensement.page.dart';
import 'package:simbo_mobile/widgets/default.colors.dart';
import 'package:simbo_mobile/widgets/loading.indicator.dart';
import 'package:simbo_mobile/widgets/mydrawer.dart';
import '../../models/recensement.dart';

class RecensementPage extends StatefulWidget {
  const RecensementPage({Key? key}) : super(key: key);

  @override
  State<RecensementPage> createState() => _RecensementPageState();
}

class _RecensementPageState extends State<RecensementPage> {
  TextEditingController dateRecensementController = TextEditingController();
  TextEditingController sigleTypeEquipemntController = TextEditingController();
  TextEditingController nomCommercialController = TextEditingController();
  TextEditingController secteurCodeController = TextEditingController();
  TextEditingController activiteCommecialeController = TextEditingController();
  TextEditingController localisationController = TextEditingController();
  TextEditingController numeroDePorteController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController typePersonneController = TextEditingController();
  TextEditingController sexeController = TextEditingController();
  TextEditingController nomsocieteController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController infosComplementairesController =
      TextEditingController();
  TextEditingController matriculeAgentController = TextEditingController();
  TextEditingController estValideController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final apiService = locator<ApiService>();
  final dbHandler = locator<LocalService>();
  final _storage = locator<TokenStorageService>();

  String? matricule;
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  Future<List<TypeActiviteCommerciale>>? _futureActiviteCommerciale;
  Future<List<TypeEquipement>>? _futureTypeequipements;
  Future<List<Secteur>>? _futureSecteurs;
  // late final Future<Agent?> _futureAgentConnected;
  String? activiteSelected;
  String? typeEquipementSelected;
  String? secteurSelected;
  String? typeContribuableSelected;
  String? sexeContribuable;

  List<TypeContribuable> typeContribuables = [
    TypeContribuable("Morale", "MORALE"),
    TypeContribuable("Physique", "PHYSIQUE")
  ];

  List<SexeContribuable> sexeContribuables = [
    SexeContribuable("Masculin", "M"),
    SexeContribuable("Feminin", "F")
  ];

  @override
  void initState() {
    print('inistate');
    _futureActiviteCommerciale = getActiviteCommerciale();
    _futureTypeequipements = getTypeEquipements();
    _futureSecteurs = getSecteurs();
    // _futureAgentConnected = getAgentConnected();
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      print('postconstrust');
      getAgentConnected().then((value) => setState(() {
            matricule = value!.matricule;
          }));
    });
  }

  @override
  void dispose() {
    dateRecensementController.dispose();
    sigleTypeEquipemntController.dispose();
    matriculeAgentController.dispose();
    localisationController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    nomsocieteController.dispose();
    prenomController.dispose();
    infosComplementairesController.dispose();
    nomController.dispose();
    numeroDePorteController.dispose();
    nomCommercialController.dispose();
    sexeController.dispose();
    typePersonneController.dispose();
    secteurCodeController.dispose();
    activiteCommecialeController.dispose();
    super.dispose();
  }

  Future<Agent?> getAgentConnected() async {
    return await _storage.retrieveAgentConnected();
  }

  Future<List<TypeEquipement>> getTypeEquipements() async {
    return await dbHandler.readAllTypeEquipements();
  }

  Future<List<TypeActiviteCommerciale>> getActiviteCommerciale() async {
    return await dbHandler.readAllTypeActivites();
  }

  Future<List<Secteur>> getSecteurs() async {
    return await dbHandler.readAllSecteurs();
  }

  @override
  Widget build(BuildContext context) {
    print('build widget');
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: const Text('Ajouter un recensement'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ListeRecensementPage()));
            },
            icon: Icon(Icons.arrow_back_ios_new)),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Defaults.blueFondCadre),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Theme(
                  data: ThemeData(primarySwatch: Defaults.primaryGreenColor),
                  child: Stepper(
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_currentStep == 0) ...[
                            ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: const Text('Suivant',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white))),
                          ] else if (_currentStep == 2) ...[
                            ElevatedButton(
                                onPressed: details.onStepCancel,
                                child: const Text('Precedent',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white))),
                            ElevatedButton(
                                onPressed: () {
                                  _submitDetails();
                                },
                                child: const Text('Enregistrer',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white))),
                          ] else ...[
                            ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: const Text('Suivant',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white))),
                            ElevatedButton(
                                onPressed: details.onStepCancel,
                                child: const Text('Precedent',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white))),
                          ]
                        ],
                      );
                    },
                    type: stepperType,
                    physics: ScrollPhysics(),
                    currentStep: _currentStep,
                    onStepTapped: (step) => tapped(step),
                    onStepContinue: continued,
                    onStepCancel: cancel,
                    steps: <Step>[
                      Step(
                        title: const Text('Equipement',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        content: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: FutureBuilder<List<TypeEquipement>>(
                                  future: _futureTypeequipements,
                                  builder: (context, snapshot) {
                                    return DropdownButtonFormField<String>(
                                      hint: const Text("Selectionnez un type"),
                                      isExpanded: true,
                                      isDense: true,
                                      value: typeEquipementSelected,
                                      onChanged: (newValue) {
                                        setState(() {
                                          typeEquipementSelected = newValue;
                                        });
                                      },
                                      onSaved: (newValue) =>
                                          typeEquipementSelected = newValue,
                                      items: snapshot.hasData
                                          ? snapshot.data!
                                              .map((fc) =>
                                                  DropdownMenuItem<String>(
                                                    value:
                                                        fc.libelle.toString(),
                                                    child: Text(
                                                        fc.libelle.toString()),
                                                  ))
                                              .toList()
                                          : [],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Selectionner un type';
                                        }
                                        return null;
                                      },
                                    );
                                  }),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child:
                                  FutureBuilder<List<TypeActiviteCommerciale>>(
                                      future: _futureActiviteCommerciale,
                                      builder: (context, snapshot) {
                                        return DropdownButtonFormField<String>(
                                          hint: const Text(
                                              "Selectionnez une activité "),
                                          isExpanded: true,
                                          isDense: true,
                                          value: activiteSelected,
                                          onSaved: (newValue) =>
                                              activiteSelected = newValue,
                                          onChanged: (newValue) {
                                            setState(() {
                                              activiteSelected = newValue;
                                            });
                                          },
                                          items: snapshot.hasData
                                              ? snapshot.data!
                                                  .map((fc) =>
                                                      DropdownMenuItem<String>(
                                                        value:
                                                            fc.type.toString(),
                                                        child: Text(
                                                          fc.type.toString(),
                                                        ),
                                                      ))
                                                  .toList()
                                              : [],
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Selectionner une activité';
                                            }
                                            return null;
                                          },
                                        );
                                      }),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: FutureBuilder<List<Secteur>>(
                                  future: _futureSecteurs,
                                  builder: (context, snapshot) {
                                    return DropdownButtonFormField<String>(
                                      hint:
                                          const Text("Selectionnez un secteur"),
                                      isExpanded: true,
                                      isDense: true,
                                      onSaved: (newValue) =>
                                          secteurSelected = newValue,
                                      value: secteurSelected,
                                      onChanged: (newValue) {
                                        setState(() {
                                          secteurSelected = newValue;
                                        });
                                      },
                                      items: snapshot.hasData
                                          ? snapshot.data!
                                              .map((fc) =>
                                                  DropdownMenuItem<String>(
                                                    value: fc.designation
                                                        .toString(),
                                                    child: Text(
                                                      fc.designation.toString(),
                                                    ),
                                                  ))
                                              .toList()
                                          : [],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Selectionner un secteur';
                                        }
                                        return null;
                                      },
                                    );
                                  }),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: TextFormField(
                                controller: localisationController,
                                decoration: const InputDecoration(
                                    labelText: 'Localisation'),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Nom commercial'),
                                controller: nomCommercialController,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Numero de porte'),
                                controller: numeroDePorteController,
                              ),
                            ),
                          ],
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 0
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: const Text('Contribuable',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        content: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Nom'),
                                controller: nomController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Entrer un Nom';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Prenom'),
                                controller: prenomController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Entrer un Prenom';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: DropdownButtonFormField<String>(
                                  hint: const Text("Selectionnez un type"),
                                  isExpanded: true,
                                  value: typeContribuableSelected,
                                  onSaved: (newValue) =>
                                      typeContribuableSelected = newValue,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Selectionner un type';
                                    }
                                    return null;
                                  },
                                  onChanged: (newValue) {
                                    setState(() {
                                      typeContribuableSelected = newValue;
                                    });
                                  },
                                  items: typeContribuables
                                      .map((fc) => DropdownMenuItem<String>(
                                            value: fc.value,
                                            child: Text(
                                              fc.label.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList()),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: DropdownButtonFormField<String>(
                                  hint: const Text("Selectionnez un genre"),
                                  isExpanded: true,
                                  value: sexeContribuable,
                                  onSaved: (newValue) =>
                                      sexeContribuable = newValue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      sexeContribuable = newValue;
                                    });
                                  },
                                  items: sexeContribuables
                                      .map((fc) => DropdownMenuItem<String>(
                                            value: fc.label,
                                            child: Text(
                                              fc.label.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList()),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: TextFormField(
                                controller: nomsocieteController,
                                decoration:
                                    const InputDecoration(labelText: 'Société'),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: TextFormField(
                                controller: telephoneController,
                                decoration: const InputDecoration(
                                    labelText: 'Telephone'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Entrer un numero';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 15, top: 15),
                              child: TextFormField(
                                controller: emailController,
                                //keyboardType: TextInputType.emailAddress,
                                decoration:
                                    const InputDecoration(labelText: 'Email'),
                              ),
                            ),
                          ],
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 1
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: const Text('Divers',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        content: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 15, top: 15),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText:
                                          'Informations complementaires'),
                                  controller: infosComplementairesController,
                                  maxLines: 500,
                                  minLines: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 2
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Defaults.greenPrincipal,
      //   onPressed: _submitDetails,
      //   child: const Icon(Icons.save),
      // ),
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  void showSnackBarMessage(String message, [MaterialColor color = Colors.red]) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _submitDetails() {
    final FormState? formState = _formKey.currentState;
    DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
    Recensement recensement = Recensement(
        sigleTypeEquipement: typeEquipementSelected,
        activiteCommerciale: activiteSelected,
        secteurCode: secteurSelected,
        nomCommercial: nomCommercialController.text,
        numeroDePorte: numeroDePorteController.text,
        nom: nomController.text,
        prenom: prenomController.text,
        typePersonne: typeContribuableSelected,
        sexe: sexeContribuable,
        nomSociete: nomsocieteController.text,
        telephone: telephoneController.text,
        email: emailController.text,
        infosComplementaires: infosComplementairesController.text,
        dateRecensement: dateFormat.format(DateTime.now()),
        estValide: 0,
        id: Random().nextInt(50),
        localisation: localisationController.text,
        matriculeAgent: matricule);
    if (!formState!.validate()) {
      showSnackBarMessage('Renseigner les champs obligatoires');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirmation",
                  style: TextStyle(color: Defaults.bluePrincipal)),
              content: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Contribuable',
                      style: TextStyle(
                          color: Defaults.greenPrincipal, fontSize: 20)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Nom:  ${recensement.nom}'),
                      const SizedBox(height: 4),
                      Text('Prenom: ${recensement.prenom}'),
                      const SizedBox(height: 4),
                      Text('Type:  ${recensement.typePersonne} '),
                      const SizedBox(height: 4),
                      Text('Genre:  ${recensement.sexe}'),
                      const SizedBox(height: 4),
                      Text('Societé:  ${recensement.nomSociete}'),
                      const SizedBox(height: 4),
                      Text('Telephone:  ${recensement.telephone}'),
                      const SizedBox(height: 4),
                      Text('Email:  ${recensement.email}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Equipement',
                      style: TextStyle(
                          color: Defaults.greenPrincipal, fontSize: 20)),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Type:  ${recensement.sigleTypeEquipement}'),
                      const SizedBox(height: 4),
                      Text('Activité: ${recensement.activiteCommerciale}'),
                      const SizedBox(height: 4),
                      Text('Secteur:  ${recensement.secteurCode} '),
                      const SizedBox(height: 4),
                      Text('Localisation:  ${recensement.localisation}'),
                      const SizedBox(height: 4),
                      Text('Nom commercial:  ${recensement.nomCommercial}'),
                      const SizedBox(height: 4),
                      Text('N° de porte:  ${recensement.numeroDePorte}'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Infos complementaires',
                      style: TextStyle(
                          color: Defaults.greenPrincipal, fontSize: 20)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(recensement.infosComplementaires.toString()),
                    ],
                  ),
                ],
              )),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler')),
                TextButton(
                  child: const Text('Ajouter'),
                  onPressed: () {
                    LoadingIndicatorDialog().show(context);
                    dbHandler.SaveRecensement(recensement);
                    LoadingIndicatorDialog().dismiss();
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ListeRecensementPage()));
                  },
                ),
              ],
            );
          });
    }
  }
}
