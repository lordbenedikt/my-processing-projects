import processing.core.PApplet;

import java.util.Random;

void draw() {
  keyAction();
  step();

  background(BLACK);
  stroke(WHITE);
  textSize(blockWidth);
  strokeWeight(2);
  noFill();
  rect(anchorX - 2, blockWidth - 2, blockWidth * 10 + 4, blockWidth * 20 + 4);
  stroke(WHITE);
  fill(WHITE);
  textAlign(LEFT, TOP);

  //        text("Shape: " + b1.shape[0][0] + b1.shape[0][1] + b1.shape[0][2] + b1.shape[0][3] + "   " +
  //                +b1.shape[1][0] + b1.shape[1][1] + b1.shape[1][2] + b1.shape[1][3] + "   " +
  //                +b1.shape[2][0] + b1.shape[2][1] + b1.shape[2][2] + b1.shape[2][3] + "   " +
  //                +b1.shape[3][0] + b1.shape[3][1] + b1.shape[3][2] + b1.shape[3][3], 20, 100);
  //        text("Bottom: " + b1.getBottom(), 20, 120);
  //        text("atFloor: " + b1.atFloor(), 20, 140);
  text("Level: " + level, blockWidth, blockWidth * 4);
  text("Points: " + points, blockWidth, blockWidth * 5.5f);

  b1.drawNext(WINDOW_SIZE_X / 2 + blockWidth * 8, (float) WINDOW_SIZE_Y / 2);
  noStroke();
  b1.draw();
  drawGrid();
  stroke(WHITE);

  if (gameOver) {
    textAlign(CENTER, CENTER);
    fill(GRAY);
    textSize(blockWidth * 3.85f);
    for (int i = 0; i < blockWidth / 10; i++) {
      text("GAME OVER", WINDOW_SIZE_X / 2, WINDOW_SIZE_Y / 2 + blockWidth * i * 0.1f);
    }
    fill(WHITE);
    textSize(blockWidth * 4);
    text("GAME OVER", WINDOW_SIZE_X / 2, WINDOW_SIZE_Y / 2);
    textAlign(LEFT, TOP);
    textSize(blockWidth);
  }

  delay(frameDelay);
}

void step() {
  if (!gameOver) levelCount -= 1;
  if (levelCount <= 0) {
    levelCount = timeTillLevelUp;
    if (level < maxLevel) {
      if (level >= 10) {
        trueSpeed += 1;
        speed += 1;
      }
      trueSpeed += 1;
      speed += 1;
      level += 1;
    }
  }
  fall -= speed;
  if (fall < 0) {
    if (b1.atFloor()) {
      b1.land();
    } else {
      b1.yPos += 1;
      fall = countFall;
    }
  }
}

final int BLACK = color(0, 0, 0);
final int PURPLE = color(158, 23, 179);
final int YELLOW = color(255, 255, 0);
final int GREEN = color(161, 235, 52);
final int BLUE = color(0, 119, 255);
final int RED = color(255, 0, 0);
final int ORANGE = color(255, 106, 0);
final int BRIGHT_BLUE = color(0, 221, 255);
final int WHITE = color(255, 255, 255);
final int GRAY = color(50);

enum Colors {
  BLACK(0x000000), PURPLE(0x9E17B3), GREEN(0x7cd104), 
    YELLOW(0xffea00), BLUE(0x007bff), RED(0xff0000), 
    ORANGE(0xff7b00), BRIGHT_BLUE(0x87fff1), WHITE(0xffffff);
  private final int value;

  Colors(int value) {
    this.value = value;
  }
}

int getRandomColor() {
  int random = r.nextInt(7);
  if (random == 0) return GREEN;
  if (random == 1) return RED;
  if (random == 2) return PURPLE;
  if (random == 3) return BLUE;
  if (random == 4) return ORANGE;
  if (random == 5) return BRIGHT_BLUE;
  if (random == 6) return YELLOW;
  return 0;
}

//setup
Random r = new Random();
int WINDOW_SIZE_X = 640;      //horizontal window size
int WINDOW_SIZE_Y = 480;      //vertical window size
int frameDelay = 10;
int repeatStep = frameDelay;
int firstSpeed = 3;
int trueSpeed = firstSpeed;
int speed = firstSpeed;                  //block's falling speed
int timeTillLevelUp = 2000;
int levelCount = timeTillLevelUp;
int level = 1;
int countFall = 100;            //countdown before moving 1 field down
int fall = countFall;
int points = 0;
int maxLevel = 10;
boolean gameOver = false;
int[][] grid = new int[20][10];
float blockWidth = 0;
float anchorX;
Block b1 = createBlock();
Block nextBlock = b1.nextBlock();

boolean keyUp = false;
boolean keyDown = false;
boolean keyLeft = false;
boolean keyRight = false;
boolean keyEsc = false;
boolean keySpace = false;
boolean keyR = false;

void keyPressed() {
  if (keyCode == ESC) keyEsc = true;
  if (keyCode == UP) keyUp = true;
  if (keyCode == DOWN) keyDown = true;
  if (keyCode == LEFT) keyLeft = true;
  if (keyCode == RIGHT) keyRight = true;
  if (key == ' ') keySpace = true;
  if (key == 'r') keyR = true;
}

void keyReleased() {
  if (keyCode == UP) keyUp = false;
  if (keyCode == DOWN) keyDown = false;
  if (keyCode == LEFT) keyLeft = false;
  if (keyCode == RIGHT) keyRight = false;
  if (key == ' ') keySpace = false;
  if (key == 'r') keyR = true;
}

void settings() {
  WINDOW_SIZE_X = displayWidth;
  WINDOW_SIZE_Y = displayHeight;
  fullScreen();
  //        size(WINDOW_SIZE_X, WINDOW_SIZE_Y);
}

void setup() {
  background(BLACK);
  blockWidth = (float) WINDOW_SIZE_Y / 22;
  anchorX = WINDOW_SIZE_X / 2 - blockWidth * 5;
  b1.yPos = 0;
}

void keyAction() {
  if (keyEsc) exit();
  if (!gameOver) {
    if (keyUp) {
      if (b1.isFree(0, 0, b1.turn()))
        b1.shape = b1.turn();
      keyUp = false;
    }
    if (keyDown) {
      speed = 51;
    } else speed = trueSpeed;
    if (keyRight) {
      if (b1.isFree(1, 0))
        b1.xPos += 1;
      keyRight = false;
    }
    if (keyLeft) {
      if (b1.isFree(-1, 0))
        b1.xPos -= 1;
      keyLeft = false;
    }
  }
  if (keySpace) {
    b1.newBlock();
    keySpace = false;
  }
  if (keyR) {
    restart();
  }
}

void restart() {
  gameOver = false;
  trueSpeed = firstSpeed;
  speed = firstSpeed;
  level = 1;
  grid = new int[20][10];
  keyR = false;
}

Block createBlock() {
  return new Block(getRandomColor());
}

class Block {
  int xPos = 3;
  int yPos = -3;
  int colour;
  int dir;
  int[][] shape;

  Block(int colour) {
    this.colour = colour;
    dir = r.nextInt(3);
    setShape(colour);
    for (int i = 0; i < dir; i++) {
      this.shape = this.turn();
    }
  }

  void setShape(int colour) {
    if (colour == PURPLE) {
      shape = new int[][]{
        {0, 0, 1, 0}, 
        {0, 0, 1, 0}, 
        {0, 1, 1, 0}, 
        {0, 0, 0, 0}
      };
    }
    if (colour == ORANGE) {
      shape = new int[][]{
        {0, 0, 0, 0}, 
        {0, 0, 1, 0}, 
        {0, 1, 1, 1}, 
        {0, 0, 0, 0}
      };
    }
    if (colour == GREEN) {
      shape = new int[][]{
        {0, 0, 1, 0}, 
        {0, 0, 1, 0}, 
        {0, 0, 1, 0}, 
        {0, 0, 1, 0}
      };
    }
    if (colour == RED) {
      shape = new int[][]{
        {0, 0, 0, 0}, 
        {0, 1, 1, 0}, 
        {0, 1, 1, 0}, 
        {0, 0, 0, 0}
      };
    }
    if (colour == BRIGHT_BLUE) {
      shape = new int[][]{
        {0, 0, 0, 0}, 
        {0, 1, 1, 0}, 
        {0, 0, 1, 1}, 
        {0, 0, 0, 0}
      };
    }
    if (colour == BLUE) {
      shape = new int[][]{
        {0, 1, 0, 0}, 
        {0, 1, 0, 0}, 
        {0, 1, 1, 0}, 
        {0, 0, 0, 0}
      };
    }
    if (colour == YELLOW) {
      shape = new int[][]{
        {0, 0, 0, 0}, 
        {0, 1, 1, 0}, 
        {1, 1, 0, 0}, 
        {0, 0, 0, 0}
      };
    }
  }

  int[][] turn() {
    int[][] turned = new int[4][4];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        turned[i][j] = shape[j][3 - i];
      }
    }
    return turned;
  }

  int[][] turnCounter() {
    int[][] turned = new int[4][4];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        turned[i][j] = shape[j][3 - i];
      }
    }
    return turned;
  }

  int getLeft() {
    int res = 0;
    for (int i = 0; i < 4; i++) {
      res += (this.shape[i][1]);
    }
    if (res == 0) return 2;
    res = 0;
    for (int i = 0; i < 4; i++) {
      res += (this.shape[i][0]);
    }
    if (res == 0) return 1;
    return 0;
  }

  int getTop() {
    int res = 0;
    for (int i = 0; i < 4; i++) {
      res += (this.shape[1][i]);
    }
    if (res == 0) return 2;
    res = 0;
    for (int i = 0; i < 4; i++) {
      res += (this.shape[0][i]);
    }
    if (res == 0) return 1;
    return 0;
  }

  int getRight() {
    int res = 0;
    for (int i = 0; i < 4; i++) {
      res += (this.shape[i][2]);
    }
    if (res == 0) return 2;
    res = 0;
    for (int i = 0; i < 4; i++) {
      res += (this.shape[i][3]);
    }
    if (res == 0) return 1;
    return 0;
  }

  int getBottom() {
    int res = 0;
    for (int i = 0; i < 4; i++) {
      res += (this.shape[2][i]);
    }
    if (res == 0) return 2;
    res = 0;
    for (int i = 0; i < 4; i++) {
      res += (this.shape[3][i]);
    }
    if (res == 0) return 1;
    return 0;
  }

  boolean atFloor() {
    return (!isFree(0, 1));
  }

  void land() {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (shape[i][j] == 1) {
          if (yPos + i < 0) {
            gameOver = true;
            trueSpeed = 0;
            speed = 0;
          }
          if (yPos + i < grid.length && yPos + i >= 0)
            if (xPos + j < grid[i].length && xPos + j >= 0)
              grid[yPos + i][xPos + j] = colour;
        }
      }
    }
    newBlock();
    fullRow();
  }

  void newBlock() {
    b1.yPos = -4;
    b1.colour = nextBlock.colour;
    b1.xPos = 3;
    b1.shape = nextBlock.shape;
    nextBlock = nextBlock();
  }

  Block nextBlock() {
    Block next = new Block(getRandomColor());
    return next;
  }

  boolean isFree(int xPos, int yPos) {
    return isFree(xPos, yPos, shape);
  }

  boolean isFree(int xPos, int yPos, int[][] shape) {
    xPos = this.xPos + xPos;
    yPos = this.yPos + yPos;
    if ((yPos + 4 - getBottom()) > grid.length) return false;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (shape[i][j] == 1) {
          if (yPos + i < grid.length && yPos + i >= 0)
            if (xPos + j < grid[i].length && xPos + j >= 0) {
              if (grid[yPos + i][xPos + j] != 0) return false;
            } else return false;
          if ( !(xPos + j < grid[i].length && xPos + j >= 0) ) return false;
        }
      }
    }
    return true;
  }

  void draw() {
    fill(this.colour);
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (shape[j][i] == 1)
          if (yPos + j >= 0)
            drawSquare(anchorX + blockWidth * xPos + blockWidth * i, 
              blockWidth + blockWidth * yPos + blockWidth * j);
      }
    }
  }

  void fullRow() {
    boolean fullRow = false;
    int row = 0;
    for (int i = 0; i < 20; i++) {
      int count = 0;
      for (int j = 0; j < 10; j++) {
        if (grid[i][j] != 0) count += 1;
      }
      if (count == 10) {
        fullRow = true;
        row = i;
      }
    }
    if (fullRow) {
      points += 1;
      for (int i = 0; i < row; i++) {
        for (int j = 0; j < 10; j++)
          grid[row - i][j] = grid[row - i - 1][j];
      }
      fullRow();
      emptyRow();
    }
  }

  void emptyRow() {
  }

  void drawNext(float x, float y) {
    fill(BLACK);
    rect(x - blockWidth * 0.2f, y - blockWidth * 0.2f, blockWidth * 4.4f, blockWidth * 4.4f);
    if (nextBlock.colour != GREEN) {
      if (nextBlock.getTop() == 0) y += blockWidth / 2;
      if (nextBlock.getRight() == 0) x -= blockWidth / 2;
      if (nextBlock.getBottom() == 0) y -= blockWidth / 2;
      if (nextBlock.getLeft() == 0) x += blockWidth / 2;
    } else {
      if (nextBlock.getTop() == 2) y -= blockWidth / 2;
      if (nextBlock.getRight() == 2) x += blockWidth / 2;
      if (nextBlock.getBottom() == 2) y += blockWidth / 2;
      if (nextBlock.getLeft() == 2) x -= blockWidth / 2;
    }
    fill(nextBlock.colour);
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (nextBlock.shape[j][i] == 1)
          rect(x + blockWidth * i, 
            y + blockWidth * j, 
            blockWidth, blockWidth);
      }
    }
  }
}

void drawSquare(float xPos, float yPos) {
  stroke(GRAY);
  strokeWeight(2);
  //        noStroke();
  rect(xPos, yPos, blockWidth, blockWidth);
  noStroke();
}

void drawGrid() {
  for (int i = 0; i < 20; i++) {
    for (int j = 0; j < 10; j++) {
      if (grid[i][j] != 0) {
        fill(grid[i][j]);
        drawSquare(anchorX + blockWidth * j, blockWidth + blockWidth * i);
      }
    }
  }
}
