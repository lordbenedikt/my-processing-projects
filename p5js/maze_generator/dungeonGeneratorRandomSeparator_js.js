var levelWidth = 30;
var levelHeight = 20;
var level = [];

function setup() {
  document.body.style.background = 'black';
  for(let i = 0; i<levelWidth; i++) {
    level[i] = [];
    for(let j =0; j<levelHeight; j++) {
      level[i][j] = 0;
    }
  }
  
  createCanvas(800, 600);

  resetCells(level);
  //addRandomWalls(level);
  //randomAutomaton(level);
  randomDivider(level);
  cleanMap(level);
}

function mousePressed() {
  resetCells(level);
  randomDivider(level);
  cleanMap(level);
}

function draw() {
  background(0);

  let cellWidth = 20;
  for (let j = 0; j<levelHeight; j++) {
    for (let i = 0; i<levelWidth; i++) {
      if (level[i][j] == 1) fill(230, 230, 230);
      else if (level[i][j] == 0) fill(100, 100, 100);
      else if (level[i][j] == -1) fill(0, 0, 0);
      rect(100+i*cellWidth, 100+j*cellWidth, cellWidth, cellWidth);
    }
  }
}

function cleanMap(level) {
  let w = level.length;
  let h = level[0].length;
  for (let i = 0; i<w; i++) {
    for (let j = 0; j<h; j++) {
      let count = 0;
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
  for (let i = 0; i<w; i++) {
    for (let j = 0; j<h; j++) {
      let count = 0;
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

function dfs(level, pos, visited) {
  let w = level.length;
  let h = level[0].length;
  if (visited.includes(pos)) {
    return;
  }
  if (level[pos%w][floor(pos/w)] == 0) {
    return;
  }
  visited.push(pos);
  if (pos%w != w-1) dfs(level, pos+1, visited);
  if (pos/w != h-1) dfs(level, pos+w, visited);
  if (pos%w != 0) dfs(level, pos-1, visited);
  if (pos/w != 0) dfs(level, pos-w, visited);
}

function isConnected(level) {
  let w = level.length;
  let h = level[0].length;
  let visited = [];
  let pos = -1;
  for (let i = 0; i<w*h; i++) {
    if (level[i%w][floor(i/w)] == 1) {
      pos = i;
      break;
    }
  }
  if (pos != -1) {
    dfs(level, pos, visited);
  }
  let free = 0;
  for (let i = 0; i<w*h; i++) {
    if (level[i%w][floor(i/w)] == 1) {
      free++;
    }
  }
  if (free==visited.length) {
    console.log("connected");
    return true;
  } else {
    console.log("disconnected");
    return false;
  }
}

function randomDivider(level) {
  w = level.length;
  h = level[0].length;
  divide(level, 5, 1, w-2, 1, h-2, 0, 3, true);
}

function cutoutRect(level, x1, x2, y1, y2) {
  for (let i = x1; i<=x2; i++) {
    for (let j = y1; j<=y2; j++) {
      level[i][j] = 0;
    }
  }
}

function freeRect(level, x1, x2, y1, y2) {
  for (let i = x1; i<=x2; i++) {
    for (let j = y1; j<=y2; j++) {
      level[i][j] = 1;
    }
  }
}

function divide(level, iter, x1, x2, y1, y2, omit, minRoomSize, horizontal) {  
  let cutout = (x2-x1 > 15 || y2-y1 > 15) ? false : random(1) < 0.7;
  iter -= floor(random(2));
  if (iter<=0) return;
  let at = 0;
  if (horizontal) {
    if (y2-y1 < minRoomSize*2+2) return;
    do {
      at = y1 + minRoomSize + floor(random(y2-y1-minRoomSize*2));
    } while (at==omit);
    let nextOmit = floor(random(x2-x1))+x1;
    for (let i = x1; i<=x2; i++) {
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
    do {
      at = x1 + minRoomSize + floor(random(x2-x1-minRoomSize*2));
    } while (at==omit);
    let nextOmit = floor(random(y2-y1))+y1;
    for (let i = y1; i<=y2; i++) {
      if (i==nextOmit) continue;
      level[at][i] = 0;
    }
    divide(level, iter-1, x1, at-1, y1, y2, nextOmit, minRoomSize, true);
    divide(level, iter-1, at+1, x2, y1, y2, nextOmit, minRoomSize, true);
  }
}

function addRandomWalls(level) {
  let w = level.length;
  let h = level[0].length;
  let iterations = 5000;
  for (let i = 0; i<iterations; i++) {
    let cell = floor(random(levelWidth*levelHeight));
    let col = cell%w;
    let row = cell/w;
    if (col==0 || col==w-1 || row==0 || row==h-1) {
      continue;
    }
    let beforeChange = level[col][row];
    level[col][row] = 0;
    let count = level[col-1][row] + level[col+1][row] +
      level[col][row-1] + level[col][row + 1];
    if (!isConnected(level) || count == 4 || count == 2 || count == 1 || count == 0) {
      level[col][row] = beforeChange;
    }
  }
}

function resetCells(level) {
  let w = level.length;
  let h = level[0].length;
  for (let j = 0; j<h; j++) {
    for (let i = 0; i<w; i++) {
      level[i][j] = 0;
    }
  }
  for (let j = 1; j<h-1; j++) {
    for (let i = 1; i<w-1; i++) {
      level[i][j] = 1;
    }
  }
}

function randomAutomaton(level) {
  let w = level.length;
  let h = level[0].length;
  let cells = [];
  cells.length = (w-2)*(h-2);
  for (let j = 1; j<h-1; j++) {
    for (let i = 1; i<w-1; i++) {
      level[i][j] = random(1) < 0.5 ? 1 : 0;
    }
  }

  for (let i = 0; i<cells.length; i++) {
    cells[i] = i;
  }
  shuffleArray(cells);

  for (let c = 0; c<cells.length; c++) {
    let i = cells[c] % (w-2) + 1;
    let j = cells[c] / (w-2) + 1;
    let count = level[i-1][j-1] + level[i][j-1] + level[i+1][j-1] +
      level[i-1][j] + level[i][j] + level[i+1][j] +
      level[i-1][j+1] + level[i][j+1] + level[i+1][j+1];
    if (count >= 5) {
      level[i][j] = 1;
    } else {
      level[i][j] = 0;
    }
  }
}

function shuffleArray(arr) 
{
  for (let i = arr.length - 1; i > 0; i--)
  {
    let index = floor(random(i + 1));
    // Simple swap
    let a = arr[index];
    arr[index] = arr[i];
    arr[i] = a;
  }
}
