Future<String> getName() async {
  await Future.delayed(Duration(seconds: 2));
  return "Talha";
}

void main() async {
  print("Getting name...");
  String name = await getName();
  print(name);
}
