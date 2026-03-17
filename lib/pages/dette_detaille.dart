import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mesrevenus/data/data.dart';

class DetteDetaille extends StatelessWidget {
  const DetteDetaille({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Détail dette'), elevation: 12),
      body: Container(
        margin: EdgeInsets.all(4),
        child: FutureBuilder<List<MyModele>>(
          future: AppDatabase.instance.readData(),
          builder: (ctx, snp) {
            if (!snp.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snp.data!.isEmpty) {
              return Center(
                child: Text(
                  'Votre boite de dette n\'a pas d\'information pour l\'instant',
                ),
              );
            }
            return ListView.builder(
              itemCount: snp.data!.length,
              itemBuilder: (ctx, idx) {
                final mydata = snp.data![idx];
                if (mydata.dette > 0) {
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.monetization_on_outlined, size: 30),
                      title: Text(mydata.activity),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${mydata.dette} FC'),
                          Text(
                            "${DateFormat('dd/MM/yyyy à HH:mm').format(mydata.date)}",
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Center();
              },
            );
          },
        ),
      ),
    );
  }
}
