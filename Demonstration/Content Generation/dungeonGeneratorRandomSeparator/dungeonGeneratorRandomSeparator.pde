int levelWidth = 30;
int levelHeight = 20;
int level[][] = new int[levelWidth][levelHeight];

void setup() {
  size(800, 600);

  resetCells(level);
  //addRandomWalls(level);
  //randomAutomaton(level);
  randomDivider(level);
  cleanMap(level);
}

void mousePressed() {
  resetCells(level);
  randomDivider(level);
  cleanMap(level);
}

void draw() {
  background(0);

  float cellWidth = 20;
  for (int j = 0; j<levelHeight; j++) {
    for (int i = 0; i<levelWidth; i++) {
      if (level[i][j] == 1) fill(230, 230, 230);
      else if (level[i][j] == 0) fill(100, 100, 100);
      else if (level[i][j] == -1) fill(0, 0, 0);
      rect(100+i*cellWidth, 100+j*cellWidth, cellWidth, cellWidth);
    }
  }
}
