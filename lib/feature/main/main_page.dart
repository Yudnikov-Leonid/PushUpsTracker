import 'package:flutter/material.dart';
import 'package:push_ups/core/firebase_repository.dart';
import 'package:push_ups/feature/home/presentation/pages/home_page.dart';
import 'package:push_ups/feature/profile/presentation/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  List<Widget> _body = [];

  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  void initState() {
    final _repository = FirebaseRepository();
    _repository.init();
    _body = [
      HomePage(
        _repository,
        key: const PageStorageKey('home'),
      ),
      ProfilePage(_repository, key: const PageStorageKey('profile'))
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: _bucket,
        child: _body[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (int newIndex) {
          setState(() {
            _index = newIndex;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
      ),
    );
  }
}
