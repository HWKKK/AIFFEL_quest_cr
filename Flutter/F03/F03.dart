/*
[회고]
- 해원:
  - async 와 await 의 필요성 및 사용법에 대해 배웠다
  - 값 초기화를 위해 setState()가 필요함을 다시 한 번 확인하였다.
  - 이미지에 모서리 둥글게 하는 효과를 주기 위해서 ClipRRect로 묶어줘야함을 배웠다
- 성욱:
  - 여전히 시간 부족하였다.
  - route 에서 데이터 전송, gesturedetector 부분을 더 집중해야 할 것 같다.
  - 조원들과 소통을 하니 부족한 부분이 확실히 보였다.
- 하은:
  - 코딩하다 보면 같은 문제도 겪을 수 있고, 다른 문제도 겪을 수 있는데, 모든 것을 공유하다 보면 새로운 내용을 배울 수 있어서 좋았다.
  - 이미지 불러오는 데에 늘 문제가 발생했었는데, 이미지를 웹링크로 불러오는 방법을 배웠고, 정보를 전달할 때 초기화를 꼭 해야하는 이유를 배웠다.
 */

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/first',
      routes: {
        '/first': (context) => FirstPage(),
        '/second': (context) => SecondPage(),
      },
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool is_cat = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: Text("First Page", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 30)),
        centerTitle: true,
        leading: Icon(Icons.pets, color: Colors.orange),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () async { // 뒤에 await를 넣어줄 것이므로 async 추가
              setState(() { //버튼을 누르면 is_cat을 false로 초기회
                is_cat = false;
              });

              //second page에서 변경된 값 받아오기

              //디버그 기록:
                //await를 넣지 않았더니 변경된 is_cat 값을 가져오지 못한다.
                //result 값이 저장이 되려면 await 뒤에 있는 코드가 다 실행이 되어야 하는데,
                //그 전에 pushNamed()가 실행이 되면서 페이지가 전환이 되어버린다.
                //await를 넣어줌으로써 result 값이 저장될 수 있게 바꿔주었다.
              final result = await Navigator.pushNamed(
                context, '/second', arguments: is_cat
              );

              if (result != null) { //second page에서 값이 뭐라도 넘어왔다면, 그 값을 is_cat으로 새로 저장
                setState(() {
                  is_cat = result as bool;
                });
              }
            },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), //버튼 꾸미기... 오렌지 색 배경
                child: Text("Next", style: TextStyle(fontSize: 25, color: Colors.white))
            ),
            SizedBox(height: 50),

            //이미지 눌렀을 때 콘솔에 is_cat 출력하기
            GestureDetector(
              onTap: () {
                print("is_cat 값: $is_cat");
              },
              child: ClipRRect( //이미지 모서리 둥글게 하기
                borderRadius: BorderRadius.circular(50),
                child: Image(
                  image: NetworkImage('https://wooripet.co.kr/data/file/freecat/thumb-2105976568_415xm3Gu_b89a4b51e269336dc6ca902961d4340af8429599_600x800.jpg'),
                  width: 300,
                  height: 300,
                  fit: BoxFit.fitWidth,
                ),
              )
            )
          ],
        )
      )
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final bool is_cat = ModalRoute.of(context)?.settings.arguments as bool; // is_cat 첫페이지에서 받아오기

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text("Second Page", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30)),
        centerTitle: true,
        leading: Icon(Icons.pets, color: Colors.blue),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // pop으로 버튼 눌렀을 시 이전 stack 제거함과 동시에, 뒤로가기 버튼 생성
            ElevatedButton(
              onPressed: () {Navigator.pop(context, true);},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade400), //버튼 꾸미기... 파란색 배경
              child: Text("Back", style: TextStyle(fontSize: 25, color: Colors.white)),
            ),
            SizedBox(height: 50),
            // 이미지 누르면 is_cat 콘솔에 프린트하는 코드
            GestureDetector(
              onTap: () {
                print("is_cat 값: $is_cat");
              },
              child: ClipRRect( //이미지 모서리 둥글게 하기
                borderRadius: BorderRadius.circular(50),
                child: Image(
                  image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQS5WM75_-hUieMo2jDvjLBC3b1kCy7uPMweg&s'),
                  width: 300,
                  height: 300,
                  fit: BoxFit.fitWidth,
                )
              )
            )
          ],
        )
      )
    );
  }
}