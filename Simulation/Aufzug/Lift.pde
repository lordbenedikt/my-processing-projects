class Lift {
  boolean goingUp;                  //true = up, false = down
  boolean isMoving = false;
  boolean goUp;
  boolean goDown;

  int floor = 0;                       //derzeitige position
  int nextFloor;
  float moveProgress;              //fortschritt der Bewegung in %

  int wait;                        //Wartezeit in frames

  boolean[] aufrufe = new boolean[floors]; 

  float vy;            //y-speed
  float d;             //diameter



  void update() {
    if (isMoving) {
      moveProgress++;
      if (moveProgress >= 100) {
        floor = nextFloor;
        moveProgress = 0;
        isMoving = false;


        if (aufrufe[floor]) {
          wait = waitTime;
          aufrufe[floor] = false;
        }
      }
    } else if (wait <= 0) {
      getNextDestination();
      wait = 0;
    } else { 
      wait--;
    }

    yAufzugHendrik = (height-bottomHeight)-(((floor+2)*aufzugBen.h)+(aufzugBen.h+visualMove()));
  }

  float visualMove() {
    float move = moveProgress/2;
    if (!goingUp) { 
      move *= -1;
    }    
    return move;
  }

  void getNextDestination() {
    if (goingUp) {
      for (int i = floor+1; i<floors; i++) {
        if (aufrufe[i]) {
          nextFloor = floor + 1;
          isMoving = true;
          break;
        }
      }
    } else {
      for (int i = floor-1; i>=0; i--) {
        if (aufrufe[i]) {
          nextFloor = floor - 1;
          isMoving = true;
          break;
        }
      }
    }
    if (nextFloor == floor) {
      goingUp = !goingUp;
    }
  }
}
