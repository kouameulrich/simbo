import 'package:flutter/material.dart';
import 'package:simbo_mobile/db/local.service.dart';
import 'package:simbo_mobile/di/service_locator.dart';
import 'package:simbo_mobile/models/Secteur.dart';
import 'package:simbo_mobile/models/recensement.dart';
import 'package:simbo_mobile/models/typeEquipement.dart';
import 'package:simbo_mobile/ui/pages/recensement.page.dart';
import 'package:simbo_mobile/widgets/default.colors.dart';
import 'package:simbo_mobile/widgets/mydrawer.dart';

class ListeRecensementPage extends StatefulWidget {
  const ListeRecensementPage({Key? key}) : super(key: key);

  @override
  State<ListeRecensementPage> createState() => _ListeRecensementPageState();
}

class _ListeRecensementPageState extends State<ListeRecensementPage> {
  final dbHandler = locator<LocalService>();
  int _countRecensement=0;
  List<Recensement> _recensements = [];

  TextEditingController searchController = TextEditingController();


  Future<List<Recensement>> getAllRecensement() async {
    return await dbHandler.readAllRecensement();
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // do something
        getAllRecensement().then((value) =>
            setState(()  {
              _countRecensement =value.length;
              _recensements = value;
              _recensements.sort();
            })
          );
    });
  }

  _convertFormatDate(String date){
    return '${date.substring(6,10)}-${date.substring(3,5)}-${date.substring(0,2)} ${date.substring(11)}';
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recensements'),
              Text('$_countRecensement',style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          centerTitle: true,
        ),
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor:Defaults.greenPrincipal,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const RecensementPage()));
          },
          child: const Icon(Icons.add),
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Defaults.blueFondCadre
          ),
          child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 10, top: 15, bottom: 15),
                  child: _countRecensement == 0 ? const Text('')
                      :
                  TextFormField(
                    controller: searchController,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        hintText: 'Recherche',
                    ),
                    onChanged: (value) {
                      setState(() {
                        getAllRecensement().then((recensements) => {
                          _recensements = recensements
                              .where((element) =>
                          element.telephone!.contains(
                              searchController.text.toString())
                              || element.nom!.toLowerCase().contains(searchController.text.toString().toLowerCase())
                              || element.prenom!.toLowerCase().contains(searchController.text.toString().toLowerCase())
                              || element.sigleTypeEquipement!.toLowerCase().contains(searchController.text.toString().toLowerCase())
                              || element.secteurCode!.toLowerCase().contains(searchController.text.toString().toLowerCase())
                          )
                              .toList(),
                            _countRecensement = _recensements.length
                        }

                        );
                      });
                    },
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTileTheme(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    // tileColor: const Color(0xff0e6324),
                    // textColor: Colors.white,
                    // iconColor: Colors.white,
                    child: ListView.separated(
                            itemCount: _recensements.length,
                            separatorBuilder: (context, index) => const Divider(
                              color: Colors.white,
                            ) ,

                            itemBuilder: (context, index) {
                              return Card(
                                //color: Defaults.greenSelected,
                                elevation: 5.0,
                                margin: const EdgeInsets.all(0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const CircleAvatar(
                                        //backgroundColor: Colors.grey,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Column(

                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${_recensements![index].nom} ${_recensements![index].prenom}', style: const TextStyle(fontWeight: FontWeight.bold, color: Defaults.bluePrincipal),),
                                          Text(
                                              '${_recensements![index]
                                                  .sigleTypeEquipement} - ${_recensements![index].telephone}'),
                                        ],
                                      ),

                                      trailing: IconButton(onPressed: () {
                                        showDialog(context: context,
                                            builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Confirmation'),
                                            content: const Text('Voulez-vous supprimer ce recensement?'),
                                            actions: [
                                              TextButton(
                                              child: const Text('Non'),
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                }),
                                              TextButton(onPressed: ()  {
                                                 dbHandler.deleteRecensement(_recensements![index].id);
                                                 setState(() {
                                                   _recensements.removeWhere((element) => element.id == _recensements![index].id);
                                                   _countRecensement = _recensements.length;
                                                 });
                                                Navigator.of(context).pop();

                                              }, child: const Text('Oui'))
                                            ],
                                          );
                                        });
                                        },
                                          icon: const Icon(Icons.delete, color: Colors.red,)),
                                          subtitle: Text('${_recensements![index].secteurCode} - ${_recensements![index].dateRecensement}'),
                                    onTap: (){
                                        showDialog(context: context,
                                            builder: (context){
                                          return AlertDialog(
                                            title: const Text('Modification', style: TextStyle(color:Defaults.bluePrincipal)),
                                            content: Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text('Contribuable', style: TextStyle(color: Defaults.greenPrincipal, fontSize: 20)),
                                                    const SizedBox(height: 10,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text('Nom:  ${_recensements![index].nom}'),
                                                        const SizedBox(height: 4,),
                                                        Text('Prenom: ${_recensements![index].prenom}'),
                                                        const SizedBox(height: 4,),
                                                        Text('Type personne:  ${_recensements![index].typePersonne} '),
                                                        const SizedBox(height: 4,),
                                                        Text('Genre:  ${_recensements![index].sexe}'),
                                                        const SizedBox(height: 4,),
                                                        Text('Societé:  ${_recensements![index].nomSociete}'),
                                                        const SizedBox(height: 4,),
                                                        Text('Telephone:  ${_recensements![index].telephone}'),
                                                        const SizedBox(height: 4,),
                                                        Text('Email:  ${_recensements![index].email}'),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    const Text('Equipement', style: TextStyle(color: Defaults.greenPrincipal, fontSize: 20)),
                                                    SizedBox(height: 10,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text('Type:  ${_recensements![index].sigleTypeEquipement}'),
                                                        const SizedBox(height: 4,),
                                                        Text('Activité: ${_recensements![index].activiteCommerciale}'),
                                                        const SizedBox(height: 4,),
                                                        Text('Secteur:  ${_recensements![index].secteurCode} '),
                                                        const SizedBox(height: 4,),
                                                        Text('Localisation:  ${_recensements![index].localisation}'),
                                                        const SizedBox(height: 4,),
                                                        Text('Nom commercial:  ${_recensements![index].nomCommercial}'),
                                                        const SizedBox(height: 4,),
                                                        Text('N° de porte:  ${_recensements![index].numeroDePorte}'),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 20),
                                                    const Text('Infos complementaires', style: TextStyle(color: Defaults.greenPrincipal, fontSize: 20)),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(_recensements![index].infosComplementaires.toString()),

                                                      ],
                                                    ),
                                                  ],
                                                )
                                            ),
                                            actions: [
                                              TextButton(onPressed: (){
                                                Navigator.of(context).pop();
                                              }, child: const Text('Annuler')
                                              ),
                                              TextButton(onPressed: (){}, child: const Text('Modifier'))
                                            ],
                                          );
                                            });
                                    },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        //}),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
  
}
