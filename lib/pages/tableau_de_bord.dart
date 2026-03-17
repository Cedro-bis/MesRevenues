import 'package:flutter/material.dart';
import 'package:mesrevenus/data/data.dart';
import 'package:mesrevenus/pages/dette_detaille.dart';

class TableauDeBord extends StatelessWidget {
  const TableauDeBord({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tableau de bord'), elevation: 12),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            FutureBuilder<List<int>>(
              future: Future.wait([
                AppDatabase.instance.getTotalGain(),
                AppDatabase.instance.getTotalDette(),
                AppDatabase.instance.getTotalDepense(),
              ]),
              builder: (ctx, snp) {
                if (!snp.hasData)
                  return Center(child: CircularProgressIndicator());
                int sommeGain = snp.data![0];
                int sommeDette = snp.data![1];
                int sommeDepense = snp.data![2];
                int sommeDisponible = sommeGain - (sommeDette + sommeDepense);
                return Column(
                  spacing: 23,
                  children: [
                    Row(
                      spacing: 23,
                      children: [
                        Expanded(
                          child: Container(
                            height: 200,
                            color: Colors.amberAccent,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Vos entrées',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    '$sommeGain',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => DetteDetaille(),
                                ),
                              );
                            },
                            child: Container(
                              height: 200,
                              color: Colors.red.shade300,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Vos dette',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      '$sommeDette',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 23,
                      children: [
                        Expanded(
                          child: Container(
                            height: 200,
                            color: Colors.blue.shade300,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Vos dépense',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    '$sommeDepense',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 200,
                            color: Colors.green,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Somme disponible',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    '${sommeDisponible <= 0 ? 'Vos compte est vide' : sommeDisponible}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 23),
            Text(
              'Vos activités',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            FutureBuilder<List<MyModele>>(
              future: AppDatabase.instance.readData(),
              builder: (ctx, snp) {
                if (!snp.hasData)
                  return Center(child: CircularProgressIndicator());
                List<MyModele> data = snp.data!;
                if (data.isEmpty)
                  return Center(child: Text('Aucune activité enregistrée'));
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (ctx, index) {
                    MyModele item = data[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.activity),
                        subtitle: Text(
                          'Dette: ${item.dette}, Dépense: ${item.depense}, Gain: ${item.gain}, Date: ${item.date.toLocal().toString().split(' ')[0]}',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
