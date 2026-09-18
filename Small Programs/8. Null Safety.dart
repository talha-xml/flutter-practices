void main() {
  String? nickname;
  String? profile_pic = null;
  print(nickname);
  print(profile_pic);
}

void main() {
  String? nickname;
  print(nickname ?? "No nickname");
}

void main() {
  int? score;
  print(score ?? 0);
}