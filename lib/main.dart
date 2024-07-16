//
//
// import 'dart:typed_data';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:excel/excel.dart';
//
// import 'package:flutter/material.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Firebase.initializeApp(
//     options: FirebaseOptions(
//       projectId: "test-827c1",
//       apiKey: "AIzaSyAnUR68izorkZ1JRd9PoyvxXTllkyLpLNk",
//       appId: "1:506535909332:android:082f42d6b7b0d0a67aa841",
//       messagingSenderId: "506535909332",
//       storageBucket: "test-827c1.appspot.com",
//     ),
//   );
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'ITC Haridwar'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String _searchQuery = "";
//   TextEditingController _searchController = TextEditingController();
//
//   Future<void> _uploadFile() async {
//     // Pick file
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['xlsx'],
//     );
//
//
//
//
//     if (result != null && result.files.isNotEmpty) {
//       // Get the file
//       PlatformFile file = result.files.first;
//
//       // Ensure the file has bytes
//       if (file.bytes != null) {
//         // Read the file
//         var excel = Excel.decodeBytes(file.bytes!);
//
//         // Iterate over the sheets
//         for (var table in excel.tables.keys) {
//           var sheet = excel.tables[table];
//           List<String> columnNames = sheet!.rows.first.map((cell) => cell?.value.toString() ?? '').toList();
//
//           for (var row in sheet.rows.skip(1)) {
//             // Create a map for Firestore
//             Map<String, dynamic> data = {};
//             for (var i = 0; i < row.length; i++) {
//               data[columnNames[i]] = row[i]?.value.toString() ?? '';
//             }
//
//             // Upload the data to Firestore
//             await FirebaseFirestore.instance.collection('excelData').add(data);
//           }
//         }
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Data uploaded successfully')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('File bytes are null')),
//         );
//       }
//     } else {
//       // User canceled the picker
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('No file selected')),
//       );
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> _fetchAllData() async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('excelData').get();
//     return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: _uploadFile,
//               child: Text('Upload New Excel File'),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   _searchQuery = value.toLowerCase();
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Map<String, dynamic>>>(
//               future: _fetchAllData(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }
//
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text('No data available'));
//                 }
//
//                 final allData = snapshot.data!;
//                 final filteredData = allData
//                     .where((data) =>
//                 data['Student Name']?.toLowerCase().contains(_searchQuery) ?? false)
//                     .toList();
//
//                 return ListView.builder(
//                   padding: const EdgeInsets.all(16.0),
//                   itemCount: filteredData.length,
//                   itemBuilder: (context, index) {
//                     var data = filteredData[index];
//                     return Card(
//                       margin: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: ListTile(
//                         title: Text(data['Student Name'] ?? 'No Name'),
//                         subtitle: Text('Roll Number: ${data['Roll Number'] ?? 'N/A'}'),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




//
// import 'dart:io' show File;
// import 'dart:typed_data';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Firebase.initializeApp(
//     options: FirebaseOptions(
//       projectId: "test-827c1",
//       apiKey: "AIzaSyAnUR68izorkZ1JRd9PoyvxXTllkyLpLNk",
//       appId: "1:506535909332:android:082f42d6b7b0d0a67aa841",
//       messagingSenderId: "506535909332",
//       storageBucket: "test-827c1.appspot.com",
//     ),
//   );
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'ITC Haridwar'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String _searchQuery = "";
//   TextEditingController _searchController = TextEditingController();
//
//   Future<void> _uploadFile() async {
//     // Request storage permission
//     var status = await Permission.storage.request();
//     if (status.isGranted) {
//       // Pick file
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['xlsx'],
//       );
//
//       if (result != null && result.files.isNotEmpty) {
//         // Get the file
//         PlatformFile file = result.files.first;
//
//         // Read the file bytes
//         Uint8List? fileBytes;
//         if (kIsWeb) {
//           fileBytes = file.bytes;
//         } else {
//           if (file.path != null) {
//             File fileFromPath = File(file.path!);
//             fileBytes = await fileFromPath.readAsBytes();
//           }
//         }
//
//         // Ensure the file has bytes
//         if (fileBytes != null) {
//           // Read the file
//           var excel = Excel.decodeBytes(fileBytes);
//
//           // Iterate over the sheets
//           for (var table in excel.tables.keys) {
//             var sheet = excel.tables[table];
//             List<String> columnNames = sheet!.rows.first.map((cell) => cell?.value.toString() ?? '').toList();
//
//             for (var row in sheet.rows.skip(1)) {
//               // Create a map for Firestore
//               Map<String, dynamic> data = {};
//               for (var i = 0; i < row.length; i++) {
//                 data[columnNames[i]] = row[i]?.value.toString() ?? '';
//               }
//
//               // Upload the data to Firestore
//               await FirebaseFirestore.instance.collection('excelData').add(data);
//             }
//           }
//
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Data uploaded successfully')),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('File bytes are null')),
//           );
//         }
//       } else {
//         // User canceled the picker
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('No file selected')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Storage permission denied')),
//       );
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> _fetchAllData() async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('excelData').get();
//     return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: _uploadFile,
//               child: Text('Upload New Excel File'),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   _searchQuery = value.toLowerCase();
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Map<String, dynamic>>>(
//               future: _fetchAllData(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }
//
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text('No data available'));
//                 }
//
//                 final allData = snapshot.data!;
//                 final filteredData = allData
//                     .where((data) =>
//                 data['Student Name']?.toLowerCase().contains(_searchQuery) ?? false)
//                     .toList();
//
//                 return ListView.builder(
//                   padding: const EdgeInsets.all(16.0),
//                   itemCount: filteredData.length,
//                   itemBuilder: (context, index) {
//                     var data = filteredData[index];
//                     return Card(
//                       margin: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: ListTile(
//                         title: Text(data['Student Name'] ?? 'No Name'),
//                         subtitle: Text('Roll Number: ${data['Roll Number'] ?? 'N/A'}'),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





import 'dart:io' show File;
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      projectId: "test-827c1",
      apiKey: "AIzaSyAnUR68izorkZ1JRd9PoyvxXTllkyLpLNk",
      appId: "1:506535909332:android:082f42d6b7b0d0a67aa841",
      messagingSenderId: "506535909332",
      storageBucket: "test-827c1.appspot.com",
    ),
  );

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
      home: const MyHomePage(title: 'ITC Haridwar'),
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
  String _searchQuery = "";
  TextEditingController _searchController = TextEditingController();

  Future<void> _requestPermission() async {
    if (!kIsWeb) {
      var status = await Permission.storage.status;
      if (status.isDenied) {
        status = await Permission.storage.request();
      }
      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  Future<void> _uploadFile() async {
    await _requestPermission();

    // Pick file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null && result.files.isNotEmpty) {
      // Get the file
      PlatformFile file = result.files.first;

      // Read the file bytes
      Uint8List? fileBytes;
      if (kIsWeb) {
        fileBytes = file.bytes;
      } else {
        if (file.path != null) {
          File fileFromPath = File(file.path!);
          fileBytes = await fileFromPath.readAsBytes();
        }
      }

      // Ensure the file has bytes
      if (fileBytes != null) {
        // Read the file
        var excel = Excel.decodeBytes(fileBytes);

        // Iterate over the sheets
        for (var table in excel.tables.keys) {
          var sheet = excel.tables[table];
          List<String> columnNames = sheet!.rows.first.map((cell) => cell?.value.toString() ?? '').toList();

          for (var row in sheet.rows.skip(1)) {
            // Create a map for Firestore
            Map<String, dynamic> data = {};
            for (var i = 0; i < row.length; i++) {
              data[columnNames[i]] = row[i]?.value.toString() ?? '';
            }

            // Upload the data to Firestore
            await FirebaseFirestore.instance.collection('excelData').add(data);
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data uploaded successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File bytes are null')),
        );
      }
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> _fetchAllData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('excelData').get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _uploadFile,
              child: Text('Upload New Excel File'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchAllData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                }

                final allData = snapshot.data!;
                final filteredData = allData
                    .where((data) =>
                data['Material Description']?.toLowerCase().contains(_searchQuery) ?? false)
                    .toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    var data = filteredData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(data['Material Description'] ?? 'No Name'),
                        subtitle: Text('Category: ${data['Category'] ?? 'N/A'}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
