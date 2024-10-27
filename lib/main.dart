import 'package:flutter/material.dart';
import 'db_handler.dart';
import 'student_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DbHandler? dbHandler;
  late Future<List<Student>> studentList;

  @override
  void initState() {
    super.initState();
    dbHandler = DbHandler();
    loadData();
  }

  loadData() {
    setState(() {
      studentList = dbHandler!.getStudent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Student>>(
          future: studentList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error loading data');
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Text('No students available');
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 10,
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: InkWell(
                        onTap: () {
                          dbHandler!.update(
                            Student(
                              id: snapshot.data![index].id,
                              name: "Updated Name",
                              age: 20,
                            ),
                          );
                          loadData();
                        },
                        child: const CircleAvatar(
                          child: Icon(Icons.edit),
                        ),
                      ),
                      title: Text(snapshot.data![index].name),
                      subtitle: Text('Age: ${snapshot.data![index].age}'),
                      trailing: InkWell(
                        onTap: () {
                          dbHandler!.delete(snapshot.data![index].id!);
                          loadData();
                        },
                        child: const CircleAvatar(
                          child: Icon(Icons.delete),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text('Unexpected error');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbHandler!.insert(Student(name: "Jaydip", age: 10)).then((value) {
            loadData();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
