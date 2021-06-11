int cols = 20;
int rows = 20;
int s = 25;
Cell[][] minefield = new Cell[cols][rows];
int mines;
boolean gameOver = false;
boolean victory = false;
boolean firstClick = true;

void setup() {
  size(500, 500);
  textSize(s/2);
  mines = cols*rows/5;
  //initialize cells
  for (int i = 0; i<minefield.length; i++) {
    for (int j = 0; j<minefield[0].length; j++) {
      minefield[i][j] = new Cell(i*s, j*s, s, i, j);
    }
  }
  reset();
}

void reset() {
  gameOver = false;
  firstClick = true;
  // set to zero, unmarked, not open
  for (int i = 0; i<minefield.length; i++) {
    for (int j = 0; j<minefield[0].length; j++) {
      minefield[i][j].num = 0;
      minefield[i][j].open = false;
      minefield[i][j].marked = false;
    }
  }
  // set mines
  int minesSet = 0;
  while (minesSet<mines) {
    int newMineCol = floor(random(0, cols));
    int newMineRow = floor(random(0, rows));
    if (minefield[newMineCol][newMineRow].num!=-1) {
      minefield[newMineCol][newMineRow].num=-1;
      minesSet++;
    }
  }
  // set numbers
  for (int i = 0; i<minefield.length; i++) {
    for (int j = 0; j<minefield[0].length; j++) {
      if (minefield[i][j].num!=-1) {
        int num = 0;
        if (i!=0 && j!=0)
          if (minefield[i-1][j-1].num==-1) num++;
        if (j!=0)
          if (minefield[i][j-1].num==-1) num++;
        if (i!=cols-1 && j!=0)
          if (minefield[i+1][j-1].num==-1) num++;
        if (i!=0)
          if (minefield[i-1][j].num==-1) num++;
        if (i!=cols-1)
          if (minefield[i+1][j].num==-1) num++;
        if (i!=0 && j!=rows-1)
          if (minefield[i-1][j+1].num==-1) num++;
        if (j!=rows-1)
          if (minefield[i][j+1].num==-1) num++;
        if (i!=cols-1 && j!=rows-1)
          if (minefield[i+1][j+1].num==-1) num++;
        minefield[i][j].num = num;
      }
    }
  }
}

void draw() {
  background(0);
  for (int i = 0; i<minefield.length; i++) {
    for (int j = 0; j<minefield[0].length; j++) {
      minefield[i][j].drawThis();
    }
  }
}

boolean isWonGame() {
  int count = 0;
  for (int i = 0; i<minefield.length; i++) {
    for (int j = 0; j<minefield[0].length; j++) {
      if (minefield[i][j].open && minefield[i][j].num!=-1) {
        count++;
      }
    }
  }
  if (count==cols*rows-mines) {
    gameOver = true;
    return true;
  }
  return false;
}

void mouseReleased() {
  int col = mouseX/s;
  int row = mouseY/s;
  if (mouseButton==LEFT) {
    minefield[col][row].leftClick();
  }
  if (mouseButton==RIGHT) {
    minefield[col][row].rightClick();
  }
  if (mouseButton==CENTER) {
    minefield[col][row].centerClick();
  }
  victory = isWonGame();
}

void keyPressed() {
  if (key=='r') {
    reset();
  }
}
