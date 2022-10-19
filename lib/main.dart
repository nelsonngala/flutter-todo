import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_with_bloc/data/hive_storage.dart';

import 'package:hive_with_bloc/screens/todos__screen.dart';

import 'data/model/task_model.dart';
import 'logic/bloc/task_bloc.dart';

void main() async {
  await Hive.initFlutter();
  // Box _tasks =
  Hive.registerAdapter(TaskModelAdapter());
  runApp(BlocProvider(
    create: (context) => TaskBloc(HiveStorage())..add(GetTaskEvent()),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todos',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const TodosScreen());
  }
}
