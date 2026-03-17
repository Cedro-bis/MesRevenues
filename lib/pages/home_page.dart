import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mesrevenus/pages/set_date.dart';
import 'package:mesrevenus/pages/tableau_de_bord.dart';
import 'package:mesrevenus/data/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SetDate setDate = SetDate(date: DateTime.now());
  TextEditingController activity = TextEditingController();
  TextEditingController dette = TextEditingController();
  TextEditingController depense = TextEditingController();
  TextEditingController gain = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: CircleAvatar(radius: 50)),

            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Tableau de bord'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (builder) => TableauDeBord()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Mes revenues'),
        backgroundColor: Colors.amberAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<MyModele>>(
          future: AppDatabase.instance.readData(),
          builder: (ctx, snp) {
            if (!snp.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snp.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text('Vous n\'avez pas d\'activité')),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: snp.data!.length,
              itemBuilder: (ctx, idx) {
                final myVar = snp.data![idx];
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        scrollable: true,
                        content: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 12,
                          children: [
                            Expanded(
                              child: Column(
                                spacing: 8,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await AppDatabase.instance.updateData(
                                        MyModele(
                                          id: myVar.id,
                                          activity: activity.text.isEmpty
                                              ? myVar.activity
                                              : activity.text,
                                          dette: dette.text.isEmpty
                                              ? myVar.dette
                                              : int.parse(dette.text),
                                          depense: depense.text.isEmpty
                                              ? myVar.depense
                                              : int.parse(depense.text),
                                          gain: gain.text.isEmpty
                                              ? myVar.gain
                                              : int.parse(gain.text),
                                          date: myVar.date,
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.edit, color: Colors.green),
                                  ),
                                  Text(
                                    'Modifier',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                spacing: 8,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          scrollable: true,
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            spacing: 4,
                                            children: [
                                              Text(
                                                'Voulez-vous supprimer l\'activité ${myVar.activity}?',
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Non'),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        await AppDatabase
                                                            .instance
                                                            .deleteData(
                                                              myVar.id!,
                                                            );
                                                        Navigator.of(
                                                          context,
                                                        ).pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                            builder:
                                                                (builder) =>
                                                                    HomePage(),
                                                          ),
                                                          (predicate) => false,
                                                        );
                                                      },
                                                      child: Text('Oui'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                  Text(
                                    'Supprimer',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.calendar_month),
                      title: Text('${myVar.activity}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vous avez enregistré ${myVar.gain} FC'),
                          Text(
                            "${DateFormat('dd/MM/yyyy à HH:mm').format(myVar.date)}",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showForm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        scrollable: true,
        title: Text("Qu'avez-vous fait aujourd'hui ?"),
        content: Column(
          mainAxisSize: .min,
          spacing: 4,
          children: [
            TextField(
              controller: activity,
              decoration: InputDecoration(labelText: 'Activité'),
            ),
            TextField(
              controller: gain,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(labelText: 'Gain'),
            ),
            TextField(
              controller: depense,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(labelText: 'Dépenses'),
            ),
            TextField(
              controller: dette,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(labelText: 'Dette'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              await AppDatabase.instance.createData(
                MyModele(
                  activity: activity.text,
                  dette: int.parse(dette.text),
                  depense: int.parse(depense.text),
                  gain: int.parse(gain.text),
                  date: DateTime.now(),
                ),
              );
              if (activity.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Veuillez préciser l\'activité')),
                );
              } else {}
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (builder) => HomePage()),
                (predicate) => false,
              );
            },
            child: Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
