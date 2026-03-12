class MyModele {
  final int? id;
  final String activity;
  final int dette;
  final int depense;
  final int gain;
  final DateTime date;
  MyModele({
    this.id,
    required this.activity,
    this.dette = 0,
    this.depense = 0,
    this.gain = 0,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'activity': activity,
      'dette': dette,
      'depense': depense,
      'gain': gain,
      'date': date.toIso8601String(),
    };
  }

  factory MyModele.fromMap(Map<String, dynamic> c) {
    return MyModele(
      id: c['id'],
      activity: c['activity'] ?? '',
      dette: c['dette'] ?? 0,
      depense: c['depense'] ?? 0,
      gain: c['gain'] ?? 0,
      date: c['date'] != null ? DateTime.parse(c['date']) : DateTime.now(),
    );
  }
}
