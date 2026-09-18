mixin Activity {
  void study() {
    print("I am studying.");
  }

  void play() {
    print("I am playing.");
  }
}

class Student with Activity {
  String name;
  int age;

  Student(this.name, this.age);

  void introduce() {
    print("My name is $name and I am $age years old.");
  }
}

void main() {
  Student student = Student("Talha", 22);

  student.introduce();
  student.study();
  student.play();
}
