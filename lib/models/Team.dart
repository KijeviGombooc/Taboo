class Team {
  final int id;
  int score;
  String? name;

  String get getName {
    return name == null ? "Team: ${(id + 1).toString()}" : name as String;
  }

  Team({required this.id, this.score = 0, this.name});
}
