void main() {
  String name = "Talha";
  int age = 22;

  final currentTime = DateTime.now();
  const country = "Pakistan";

  String? nickname;
  List<String> hobbies = ["Coding", "Gaming"];
  Set<String> games = {"COD", "Tekken", "Assassin's Creed"};
  Map<String, dynamic> user = {"name": name, "age": age};
  print("Name: $name");
  print("Age: $age");
  print("Country: $country");
  print("Current Time: $currentTime");
  print("Nickname: ${nickname ?? "No nickname"}");
  print("Hobbies: $hobbies");
  print("Games: $games");
  print("User: $user");
}
