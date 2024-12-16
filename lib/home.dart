import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<Map<dynamic,dynamic>?> fetchData() async {
    try{
      final snapshot = await _databaseReference.child('users').get();
      if(snapshot.exists){
        return snapshot.value as Map;
      }
      else{
        Exception("No data");
        throw Exception("Failed to fetch data");
      }
    }
    catch(e){
      print("exception::::::::::$e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Data'),
      ),
      body: FutureBuilder<Map<dynamic, dynamic>?>(
        future: fetchData(),
        builder: (context, snapshot) {
          // Handling different states of Future
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            final data = snapshot.data!;
            // Displaying data in a ListView
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final userId = data.keys.elementAt(index);
                Map<String, dynamic> user = data![userId];
                return ListTile(
                  title: Text("name: ${user["name"]}"),
                  subtitle: Text("email: ${user["email"]}"),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
