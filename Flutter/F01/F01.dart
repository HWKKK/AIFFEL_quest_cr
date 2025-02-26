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
  int workTime = 5; // 작업 시간
  int breakTime = 3; // 휴식 시간
  int forthBreakTime = 10; // 4회차 휴식 시간

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
        print("잔여시간: $remainingTime");
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
        print("잔여시간: $remainingTime");
      }
    });
  }
}

void main() {
  PomodoroTimer timer = PomodoroTimer();
  timer.start();
}