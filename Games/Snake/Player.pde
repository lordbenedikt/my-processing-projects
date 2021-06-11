class Player {
  //snake attributes
  int body[];
  int nextPos;
  int speed;
  int segmentCount = 1;
  int direction = 1;

  //field proportions
  int rows;
  int cols;
  float w;
  float h;

  int count = 0;
  boolean gameOver = false;
  int lastTailPos = -1;

  Player(int rows, int cols, float w, float h) {
    this.rows = rows;
    this.cols = cols;
    this.w = w;
    this.h = h;
    speed = 100/cols;
    body = new int[rows*cols];
    body[0] = body.length/2+rows/2;
    addSegment();
    addSegment();
    addSegment();
    addSegment();
    addSegment();
    addSegment();
    addSegment();
    addSegment();
  }

  void update() {
    if (!gameOver) {
      count++;
      if (count>=speed) {
        count = count-speed;
        int nextPos = getNextPos();
        //if no collision
        if (nextPos != -1) {
          for (int i = segmentCount; i>0; i--) {
            body[i] = body[i-1];
          }
          body[0] = nextPos;
        }
      }
      
      if(body[0]==screen.apple.pos) {
        screen.apple.eat();
        addSegment();
      }
      
    }
  }

  void draw() {
    fill(255);
    text("Position: "+body[0], 10, 20);
    text("GameOver: "+gameOver, 10, 30);
    fill(snakeColor);
    if (segmentCount>1) {
      for (int i = 1; i<segmentCount-1; i++) {
        drawSegmentByNumber(i);
      }
      drawHead();
      drawTail();
    } else {
      for (int i = 0; i<segmentCount; i++) {
        drawSegmentByNumber(i);
      }
    }
  }

  void drawHead() {
    int pos = body[0];
    fill(snakeColor);
    if (body[1]==getAbove(body[0])) {
      ellipse((pos%cols+0.5)*(w/cols), (pos/cols+0.5)*h/rows, w/cols, h/rows);
      rect((pos%cols)*(w/cols), (pos/cols-0.5)*h/rows, w/cols, h/rows);
      fill(0);
      circle((pos%cols+0.3)*(w/cols), (pos/cols+0.7)*h/rows, w/cols/6);
      circle((pos%cols+0.7)*(w/cols), (pos/cols+0.7)*h/rows, w/cols/6);
    }
    if (body[1]==getBelow(body[0])) {
      ellipse((pos%cols+0.5)*(w/cols), (pos/cols+0.5)*h/rows, w/cols, h/rows);
      rect((pos%cols)*(w/cols), (pos/cols+0.5)*h/rows, w/cols, h/rows);
      fill(0);
      circle((pos%cols+0.3)*(w/cols), (pos/cols+0.3)*h/rows, w/cols/6);
      circle((pos%cols+0.7)*(w/cols), (pos/cols+0.3)*h/rows, w/cols/6);
    }
    if (body[1]==getLeft(body[0])) {
      ellipse((pos%cols+0.5)*(w/cols), (pos/cols+0.5)*h/rows, w/cols, h/rows);
      rect((pos%cols-0.5)*(w/cols), (pos/cols)*h/rows, w/cols, h/rows);
      fill(0);
      circle((pos%cols+0.8)*(w/cols), (pos/cols+0.3)*h/rows, w/cols/6);
      circle((pos%cols+0.8)*(w/cols), (pos/cols+0.7)*h/rows, w/cols/6);
    }
    if (body[1]==getRight(body[0])) {
      ellipse((pos%cols+0.5)*(w/cols), (pos/cols+0.5)*h/rows, w/cols, h/rows);
      rect((pos%cols+0.5)*(w/cols), (pos/cols)*h/rows, w/cols, h/rows);
      fill(0);
      circle((pos%cols+0.2)*(w/cols), (pos/cols+0.3)*h/rows, w/cols/6);
      circle((pos%cols+0.2)*(w/cols), (pos/cols+0.7)*h/rows, w/cols/6);
    }
  }

  void drawSegmentByNumber(int num) {
    int pos = body[num];
    boolean last = (num==segmentCount-2);
    fill(snakeColor);
    if (body[num+1]==getAbove(body[num])) {
      ellipse((pos%cols+0.5)*(w/cols), (pos/cols+0.5)*h/rows, w/cols, h/rows);
      rect((pos%cols)*(w/cols), (pos/cols - (last ? 0 : 0.5))*h/rows, w/cols, h/rows * (last ? 0.5 : 1));
      fill(0);
    }
    if (body[num+1]==getBelow(body[num])) {
      ellipse((pos%cols+0.5)*(w/cols), (pos/cols+0.5)*h/rows, w/cols, h/rows);
      rect((pos%cols)*(w/cols), (pos/cols+0.5)*h/rows, w/cols, h/rows * (last ? 0.5 : 1));
      fill(0);
    }
    if (body[num+1]==getLeft(body[num])) {
      ellipse((pos%cols+0.5)*(w/cols), (pos/cols+0.5)*h/rows, w/cols, h/rows);
      rect((pos%cols - (last ? 0 : 0.5))*(w/cols), (pos/cols)*h/rows, w/cols * (last ? 0.5 : 1), h/rows);
      fill(0);
    }
    if (body[num+1]==getRight(body[num])) {
      ellipse((pos%cols+0.5)*(w/cols), (pos/cols+0.5)*h/rows, w/cols, h/rows);
      rect((pos%cols+0.5)*(w/cols), (pos/cols)*h/rows, w/cols * (last ? 0.5 : 1), h/rows);
      fill(0);
    }
  }

  void drawSegment(int pos) {
    rect((pos%cols)*(w/cols), (pos/cols)*h/rows, w/cols+0.2, h/rows+0.2);
  }

  void drawTail() {
    fill(snakeColor);
    int pos = body[segmentCount-1];
    if (body[segmentCount-2]==getAbove(body[segmentCount-1])) {
      triangle((pos%cols)*(w/cols), (pos/cols)*h/rows, (pos%cols+1)*(w/cols), (pos/cols)*h/rows, (pos%cols+0.5)*(w/cols), (pos/cols+1)*h/rows);
    }
    if (body[segmentCount-2]==getBelow(body[segmentCount-1])) {
      triangle((pos%cols)*(w/cols), (pos/cols+1)*h/rows, (pos%cols+1)*(w/cols), (pos/cols+1)*h/rows, (pos%cols+0.5)*(w/cols), (pos/cols)*h/rows);
    }
    if (body[segmentCount-2]==getLeft(body[segmentCount-1])) {
      triangle((pos%cols)*(w/cols), (pos/cols)*h/rows, (pos%cols)*(w/cols), (pos/cols+1)*h/rows, (pos%cols+1)*(w/cols), (pos/cols+0.5)*h/rows);
    }
    if (body[segmentCount-2]==getRight(body[segmentCount-1])) {
      triangle((pos%cols+1)*(w/cols), (pos/cols)*h/rows, (pos%cols+1)*(w/cols), (pos/cols+1)*h/rows, (pos%cols)*(w/cols), (pos/cols+0.5)*h/rows);
    }
  }

  void addSegment() {
    body[segmentCount] = body[segmentCount-1];
    segmentCount++;
  }

  int getLeft(int of) {
    if ((of%cols)== 0) return of + cols - 1;
    return of - 1;
  }
  int getRight(int of) {
    if ((of+1)%cols == 0) return of - cols + 1;
    return of + 1;
  }
  int getAbove(int of) {
    if (of-cols < 0) return of + cols*(rows-1);
    return of - cols;
  }
  int getBelow(int of) {
    if ((of+cols) >= cols*rows) return of % cols;
    return of + cols;
  }

  int getNextPos() {
    switch(direction) {
    case 0:
      nextPos = getAbove(body[0]);
      break;
    case 1: 
      nextPos = getRight(body[0]);
      break;
    case 2: 
      nextPos = getBelow(body[0]);
      break;
    default: 
      nextPos = getLeft(body[0]);
      break;
    }
    for (int i = 1; i<segmentCount-1; i++) {
      if (nextPos == body[i]) {
        gameOver = true;
        return -1;
      }
    }
    return nextPos;
  }

  boolean isColliding(int pos) {
    for (int i = 0; i<body.length; i++) {
      if (body[i]==pos) return true;
    }
    return false;
  }
}
