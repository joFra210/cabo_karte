class Player {
  int? id;
  String name;
  int? overallScore;

  Player({
    this.id,
    required this.name,
    this.overallScore,
  });

  // Convert a Player into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'name': name,
      'overallScore': overallScore,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static Player fromMap(Map<dynamic, dynamic> map) {
    return Player(
      id: map['id'],
      name: map['name'],
      overallScore: map['overallScore'],
    );
  }

  // Implement toString to make it easier to see information about
  // each player when using the print statement.
  @override
  String toString() {
    return 'Player{id: $id, name: $name, overallScore: $overallScore}';
  }
}
