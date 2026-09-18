Stream<int> numbers() async* {
  yield 1;
  yield 2;
  yield 3;
  yield 4;
}

void main() async {
  await for (int number in numbers()) {
    print(number);
  }
}