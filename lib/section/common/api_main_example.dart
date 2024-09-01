// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import './kakao_api/views/search_page.dart';
// import './tour_api/views/tour_api_search_page.dart';
// import './google_api/views/google_search_page.dart';
//
// void main() async {
//   await dotenv.load(fileName: ".env");  // 환경 변수 로드
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Place Search',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MainPage(),
//     );
//   }
// }
//
// class MainPage extends StatefulWidget {
//   @override
//   _MainPageState createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//   int _selectedIndex = 0;
//
//   static List<Widget> _pages = <Widget>[
//     SearchPage(), // 기존 Kakao 검색 페이지
//     TourApiSearchPage(), // TourAPI 검색 페이지
//     GoogleSearchPage(), // Google Places 검색 페이지
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Place Search'),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               child: Text('기능'),
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//             ),
//             ListTile(
//               title: Text('Kakao Search'),
//               onTap: () {
//                 _onItemTapped(0);
//                 Navigator.pop(context); // 메뉴를 닫음
//               },
//             ),
//             ListTile(
//               title: Text('TourAPI Search'),
//               onTap: () {
//                 _onItemTapped(1);
//                 Navigator.pop(context); // 메뉴를 닫음
//               },
//             ),
//             ListTile(
//               title: Text('Google Place Search'),
//               onTap: () {
//                 _onItemTapped(2);
//                 Navigator.pop(context); // 메뉴를 닫음
//               },
//             ),
//           ],
//         ),
//       ),
//       body: _pages[_selectedIndex],
//     );
//   }
// }
