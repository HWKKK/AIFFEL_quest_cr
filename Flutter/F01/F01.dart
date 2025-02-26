/*
[코딩 전략]
1. 구조 잡기(필요한 기능 정의) :
  1) 타이머 기능
  2) 작업 시간 시작
  3) 휴식 시간 시작
  4) 사이클 카운트 체크

2. 알고리즘 짜기 :
  1) main() 함수에서 타이머를 실행시킨다.
  2) 타이머를 실행하면, 작업 시간 시작 기능이 실행된다
  3) 작업 시간이 끝나면 휴식 시간 시작 기능이 실행된다
  4) 휴식 시간이 끝나면 작업 시간 시작 기능이 실행된다 (3 & 4 반복)
      ** 단, 사이클 카운트가 4일 때와 아닐 때의 휴식시간 분리
*/

import 'dart:async';

class PomodoroTimer {
  //테스트의 편리성을 위해, 각 시간은 분이 아닌 초로 지정하였습니다.
  int cycleCount = 0; // 사이클 돈 횟수
  int workTime = 5; // 작업 시간 (초)
  int breakTime = 3; // 휴식 시간 (초)
  int forthBreakTime = 10; // 4회차 휴식 시간 (초)

  void start() { // 타이머 기능 정의
    print("Pomodoro 타이머를 시작합니다.");
    startWorkTimer();
  }

  void startWorkTimer() {
      int remainingTime = workTime; // 잔여 시간 정의

      Timer.periodic(Duration(seconds: 1), (timer) { //1초씩 세면서, 잔여시간이 0이 되면 타이머 멈춤
      if (remainingTime == 0) {
        timer.cancel();
        cycleCount++;
        print("작업 시간이 종료되었습니다. 휴식 시간을 시작합니다.");
        startBreakTimer();
      } else {
        remainingTime--;
        int remainingMinutes = remainingTime ~/ 60;
        int remainingSeconds = remainingTime % 60;
        print("잔여시간: $remainingMinutes분 $remainingSeconds초");
      }
    });
  }

  void startBreakTimer() {
    int remainingTime;

    if (cycleCount == 4) {
      print('4회차 휴식 시작');
      remainingTime = forthBreakTime; // 4번째 사이클일 때 잔여 시간 정의
    } else {
      print('휴식 시작');
      remainingTime = breakTime; // 4번째 사이클이 아닐 때 잔여 시간 정의
    }

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime == 0) {
        timer.cancel();
        print("휴식 시간이 종료되었습니다. 작업 시간을 시작합니다.");
        startWorkTimer();
      } else {
        remainingTime--;
        int remainingMinutes = remainingTime ~/ 60;
        int remainingSeconds = remainingTime % 60;
        print("잔여시간: $remainingMinutes분 $remainingSeconds초");
      }
    });
  }
}

void main() {
  PomodoroTimer timer = PomodoroTimer();
  timer.start();
}

/*
[회고]

1) 김해원
workTime, breakTime 등 바뀌지 않을 값에 대해서 final 지정을 하거나,
private 변수 선언을 할만한 부분이 있었지만 지정하지 않았습니다.
코드가 커졌을 때를 대비해서 미리부터 잘 적용할 필요성을 느꼈습니다.

2) 윤순천
도움을 받아 구성한 코드를 이해하는데 집중했었는데,
해원님의 논리적이고 전략적인 코드 구상과 코드 결과를 보고 감탄하였고, 코딩을 하는데 있어 어떻게 시작해야 할지 배울 수 있었음.
코딩 구성을 이해하기 위해 공부하던 중, late 개념과, 클래스가 타입으로 선언될 수 있다는 것을 알게 되었음.
*/