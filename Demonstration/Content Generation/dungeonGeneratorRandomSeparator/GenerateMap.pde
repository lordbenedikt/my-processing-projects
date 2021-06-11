void cleanMap(int level[][]) {
  int w = level.length;
  int h = level[0].length;
  for (int i = 0; i<w; i++) {
    for (int j = 0; j<h; j++) {
      int count = 0;
      if (j!=0 && level[i][j-1]==1) count++;
      if (i!=0 && level[i-1][j]==1) count++;
      if (level[i][j]==1) count++;
      if (i!=w-1 && level[i+1][j]==1) count++;
      if (j!=h-1 && level[i][j+1]==1) count++;
      if (level[i][j]==1 && count==1 || count==2) {
        level[i][j]=0;
      }
    }
  }
  for (int i = 0; i<w; i++) {
    for (int j = 0; j<h; j++) {
      int count = 0;
      if (j!=0 && level[i][j-1]==1) count++;
      if (i!=0 && level[i-1][j]==1) count++;
      if (level[i][j]==1) count++;
      if (i!=w-1 && level[i+1][j]==1) count++;
      if (j!=h-1 && level[i][j+1]==1) count++;
      if (i!=0 && j!=0 && level[i-1][j-1]==1) count++;
      if (i!=w-1 && j!=0 && level[i+1][j-1]==1) count++;
      if (i!=0 && j!=h-1 && level[i-1][j+1]==1) count++;
      if (i!=w-1 && j!=h-1 && level[i+1][j+1]==1) count++;
      if (count==0) {
        level[i][j]=-1;
      }
    }
  }
}

void dfs(int level[][], int pos, ArrayList<Integer> visited) {
  int w = level.length;
  int h = level[0].length;
  if (visited.contains(pos)) {
    return;
  }
  if (level[pos%w][pos/w] == 0) {
    return;
  }
  visited.add(pos);
  if (pos%w != w-1) dfs(level, pos+1, visited);
  if (pos/w != h-1) dfs(level, pos+w, visited);
  if (pos%w != 0) dfs(level, pos-1, visited);
  if (pos/w != 0) dfs(level, pos-w, visited);
}

boolean isConnected(int level[][]) {
  int w = level.length;
  int h = level[0].length;
  ArrayList<Integer> visited = new ArrayList<Integer>();
  int pos = -1;
  for (int i = 0; i<w*h; i++) {
    if (level[i%w][i/w] == 1) {
      pos = i;
      break;
    }
  }
  if (pos != -1) {
    dfs(level, pos, visited);
  }
  int free = 0;
  for (int i = 0; i<w*h; i++) {
    if (level[i%w][i/w] == 1) {
      free++;
    }
  }
  if (free==visited.size()) {
    return true;
  } else {
    return false;
  }
}

void randomDivider(int level[][]) {
  int w = level.length;
  int h = level[0].length;
  divide(level, 5, 1, w-2, 1, h-2, 0, 3, true);
}

void cutoutRect(int level[][], int x1, int x2, int y1, int y2) {
  for (int i = x1; i<=x2; i++) {
    for (int j = y1; j<=y2; j++) {
      level[i][j] = 0;
    }
  }
}

void freeRect(int level[][], int x1, int x2, int y1, int y2) {
  for (int i = x1; i<=x2; i++) {
    for (int j = y1; j<=y2; j++) {
      level[i][j] = 1;
    }
  }
}

void divide(int level[][], int iter, int x1, int x2, int y1, int y2, int omit, int minRoomSize, boolean horizontal) {  
  boolean cutout = (x2-x1 > 15 || y2-y1 > 15) ? false : random(1) < 0.7;
  iter -= int(random(2));
  if (iter<=0) return;
  int at = 0;
  if (horizontal) {
    if (y2-y1 < minRoomSize*2+2) return;
    do {
      at = y1 + minRoomSize + (int)random(y2-y1-minRoomSize*2);
    } while (at==omit);
    int nextOmit = int(random(x2-x1))+x1;
    for (int i = x1; i<=x2; i++) {
      if (i==nextOmit) continue;
      level[i][at] = 0;
    }
    if (at<omit && cutout) {
      cutoutRect(level, x1, x2, y1, at-1);
      if (!isConnected(level)) {
        freeRect(level, x1, x2, y1, at-1);
        divide(level, iter-1, x1, x2, y1, at-1, nextOmit, minRoomSize, false);
      }
    } else {
      divide(level, iter-1, x1, x2, y1, at-1, nextOmit, minRoomSize, false);
      
    }
    if (at>omit && cutout) {
      cutoutRect(level, x1, x2, at+1, y2);
      if (!isConnected(level)) {
        freeRect(level, x1, x2, at+1, y2);
        divide(level, iter-1, x1, x2, at+1, y2, nextOmit, minRoomSize, false);
      }
    } else {
      divide(level, iter-1, x1, x2, at+1, y2, nextOmit, minRoomSize, false);
    }
  } else {
    if (x2 - x1 < minRoomSize*2+2) return;
    print(random(3) + "\n");
    do {
      at = x1 + minRoomSize + floor(random(x2-x1-minRoomSize*2));
    } while (at==omit);
    int nextOmit = int(random(y2-y1))+y1;
    for (int i = y1; i<=y2; i++) {
      if (i==nextOmit) continue;
      level[at][i] = 0;
    }
    divide(level, iter-1, x1, at-1, y1, y2, nextOmit, minRoomSize, true);
    divide(level, iter-1, at+1, x2, y1, y2, nextOmit, minRoomSize, true);
  }
}

void addRandomWalls(int level[][]) {
  int w = level.length;
  int h = level[0].length;
  int iterations = 5000;
  for (int i = 0; i<iterations; i++) {
    int cell = floor(random(levelWidth*levelHeight));
    int col = cell%w;
    int row = cell/w;
    if (col==0 || col==w-1 || row==0 || row==h-1) {
      continue;
    }
    int beforeChange = level[col][row];
    level[col][row] = 0;
    int count = level[col-1][row] + level[col+1][row] +
      level[col][row-1] + level[col][row + 1];
    if (!isConnected(level) || count == 4 || count == 2 || count == 1 || count == 0) {
      level[col][row] = beforeChange;
    }
  }
}

void resetCells(int level[][]) {
  int w = level.length;
  int h = level[0].length;
  for (int j = 0; j<h; j++) {
    for (int i = 0; i<w; i++) {
      level[i][j] = 0;
    }
  }
  for (int j = 1; j<h-1; j++) {
    for (int i = 1; i<w-1; i++) {
      level[i][j] = 1;
    }
  }
}

void randomAutomaton(int level[][]) {
  int w = level.length;
  int h = level[0].length;
  int cells[] = new int[(w-2)*(h-2)];
  for (int j = 1; j<h-1; j++) {
    for (int i = 1; i<w-1; i++) {
      level[i][j] = random(1) < 0.5 ? 1 : 0;
    }
  }

  for (int i = 0; i<cells.length; i++) {
    cells[i] = i;
  }
  shuffleArray(cells);

  for (int c = 0; c<cells.length; c++) {
    int i = cells[c] % (w-2) + 1;
    int j = cells[c] / (w-2) + 1;
    int count = level[i-1][j-1] + level[i][j-1] + level[i+1][j-1] +
      level[i-1][j] + level[i][j] + level[i+1][j] +
      level[i-1][j+1] + level[i][j+1] + level[i+1][j+1];
    if (count >= 5) {
      level[i][j] = 1;
    } else {
      level[i][j] = 0;
    }
  }
}
