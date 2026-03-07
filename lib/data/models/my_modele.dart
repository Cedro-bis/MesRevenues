class MyModele {
  final int? id;
  final String activity;
  final int dette;
  final int depense;
  final int gain;
  MyModele({
    this.id,
    required this.activity,
    required this.dette,
    required this.depense,
    required this.gain,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'activity': activity,
      'dette': dette,
      'depense': depense,
      'gain': gain,
    };
  }

  factory MyModele.fromMap(Map<String, dynamic> c) {
    return MyModele(
      id: c['id'],
      activity: c['activity'],
      dette: c['dette'],
      depense: c['depense'],
      gain: c['gain'],
    );
  }
}
