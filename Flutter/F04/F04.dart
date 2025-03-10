import 'package:flutter/material.dart';
import "package:flutter_map/flutter_map.dart";
import 'package:latlong2/latlong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/map',
      routes: {
        '/map': (context) => MapScreen(),
        '/profile': (context) => ProfileScreen(),
      },
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng userLocation = LatLng(37.4979, 127.0276); // 강남역 좌표
  double _panelHeight = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 지도 표시하기 (플러터 내장 지도. api 사용 X)
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(37.4979, 127.0276), // 강남역 좌표
              initialZoom: 17,
            ),
            children: [
              // flutter map 패키지에서 지도를 표시하는 부분
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),

              // 내 위치 표시하는 마커
              MarkerLayer(
                markers: [
                  Marker(
                    width: 50.0,
                    height: 50.0,
                    point: userLocation,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 왼쪽 상단의 내 위치로 가는 아이콘
          Positioned(
            top: 50,
            left: 20,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {},
              backgroundColor: Colors.white,
              child: Icon(Icons.my_location, color: Colors.black),
            ),
          ),

          // 오른쪽 상단의 검색 아이콘
          Positioned(
            top: 50,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {},
              backgroundColor: Colors.white,
              child: Icon(Icons.search, color: Colors.black),
            ),
          ),

          // 카테고리 선택 버튼
          Positioned(
            bottom: _panelHeight + 60, // "이 지역 원픽 맛집" 에서 60만큼 높이 띄우기
            left: 20,
            right: 20,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // 수평으로 스크롤 가능하게
              child: Row(
                children: [
                  _categoryButton("타이", Icons.flag, Colors.white),
                  _categoryButton("분식", Icons.rice_bowl, Colors.white),
                  _categoryButton("중식", Icons.restaurant, Colors.white),
                  _categoryButton("기타 맛집", Icons.fastfood, Colors.white),
                ],
              ),
            ),
          ),
          // 이 지역 원픽 맛집을 클릭했을 때 애니메이션
          GestureDetector(
            onVerticalDragUpdate: (details) {
              setState(() {
                _panelHeight = (_panelHeight - details.primaryDelta!).clamp(100.0, 750.0);
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _panelHeight = _panelHeight == 100 ? 750 : 100; // 패널 높이가 100이면 750으로, 750이면 100으로 변경.
                            });
                          },
                          child: Text("이 지역 원픽 맛집 81곳", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        if (_panelHeight > 100)
                          Container(
                            height: 750,
                            child: ListView(
                              children: _buildRestaurantList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                  _bottomNavigationBar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 카테고리 버튼 함수
  Widget _categoryButton(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.black),
        label: Text(title, style: TextStyle(color: Colors.black)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  // 이 지역 원픽 맛집을 클릭했을 때 맛집 리스트 화면.
  List<Widget> _buildRestaurantList() {
    return [
      ListTile(
        //leading: Icon(Icons.restaurant, color: Colors.red),
        title: Text("타논55 타이"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📍 광진구 구의제3동 아차산로 480"), // 아이콘과 텍스트 분리하지 않았음...
            Text("🏆 1명의 원픽"),
            SizedBox(height: 10),
            // 원래는 가게 사진을 넣는 곳인데, 그냥 회색 박스로 대체
            Container(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    width: 180,
                    height: 180,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      SizedBox(height: 50),
      ListTile(
        //leading: Icon(Icons.fastfood, color: Colors.orange),
        title: Text("신토불이떡볶이"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📍 광진구 자양로43길 42"),
            Text("🏆 1명의 원픽"),
            SizedBox(height: 10),
            Container(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    width: 180,
                    height: 180,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    ];
  }

  // 하단 내비게이션 바 함수
  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 0) { // 첫번째 메뉴(지도) 누르면 pop
          Navigator.pop(context);
        }
        else { // 세번째 메뉴(프로필) 누르면 프로필로 이동
          Navigator.pushNamed(context, '/profile');
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.map), label: "지도"),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "둘러보기"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "프로필"),
      ],
    );
  }
}

// 프로필 페이지
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('닉네임', style: TextStyle(color: Colors.black, fontSize: 40)),
            SizedBox(height: 20),
            Text("어떤 장소를 디깅하고 계신가요?", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            Text("원픽 1   팔로워 0   팔로잉 0", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[300],
              child: Center(
                  child: Text('내 원픽 지도', textAlign: TextAlign.center)
              ),// 지도 이미지 자리
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
                children: List.generate(4, (index) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text("카테고리 원픽", textAlign: TextAlign.center),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      // 하단 내비게이션 바
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) { // 첫번째 메뉴(지도) 누르면 pop
            Navigator.pop(context);
          }
          else { // 세번째 메뉴(프로필) 누르면 프로필로 이동
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "지도"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "둘러보기"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "프로필"),
        ],
      ),
    );
  }
}
