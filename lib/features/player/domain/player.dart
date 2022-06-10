class Player {
  int? id;
  String name;
  int numberOfWins;

  Player({
    this.id,
    required this.name,
    this.numberOfWins = 0,
  });

  // Convert a Player into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'name': name,
      'overallScore': numberOfWins,
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
      numberOfWins: map['overallScore'] ?? 0,
    );
  }

  // Implement toString to make it easier to see information about
  // each player when using the print statement.
  @override
  String toString() {
    return 'Player{id: $id, name: $name, overallScore: $numberOfWins}';
  }

  @override
  int get hashCode =>
      (id.hashCode.toString() + name.hashCode.toString()).hashCode;

  @override
  bool operator ==(Object other) {
    if (other is Player) {
      return id == other.id && name == other.name;
    } else {
      return false;
    }
  }
}
