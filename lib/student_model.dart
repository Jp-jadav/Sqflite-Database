class Student {
  final int? id;
  final String name;
  final int age;

  Student({this.id, required this.name, required this.age});

  // Convert Student object into a Map object (for database operations)
  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }

  // Convert a Map object into a Student object (for fetching data from the database)
  factory Student.fromMap(Map<String, dynamic> res) {
    return Student(
      id: res['id'], // Fix: correctly mapping 'id'
      name: res['name'], // Fix: mapping 'name' correctly
      age: res['age'],
    );
  }
}
