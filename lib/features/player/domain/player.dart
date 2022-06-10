class Player {
  final int id;
  final String name;
  int? overallScore;

  Player({
    required this.id,
    required this.name,
    this.overallScore,
  });

  // Convert a Player into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'overallScore': overallScore,
    };
  }

  // Implement toString to make it easier to see information about
  // each player when using the print statement.
  @override
  String toString() {
    return 'Player{id: $id, name: $name, overallScore: $overallScore}';
  }
}
