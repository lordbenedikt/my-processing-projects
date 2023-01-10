function draw() {
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
  text("Points: " + points, blockWidth, blockWidth * 5.5);

  b1.drawNext(WINDOW_SIZE_X / 2 + blockWidth * 8, WINDOW_SIZE_Y / 2);
  noStroke();
  b1.draw();
  drawGrid();
  stroke(WHITE);

  if (gameIsOver) {
    textAlign(CENTER, CENTER);
    fill(GRAY);
    textSize(blockWidth * 3.85);
    for (let i = 0; i < blockWidth / 10; i++) {
      text("GAME OVER", WINDOW_SIZE_X / 2, WINDOW_SIZE_Y / 2 + blockWidth * i * 0.1);
    }
    fill(WHITE);
    textSize(blockWidth * 4);
    text("GAME OVER", WINDOW_SIZE_X / 2, WINDOW_SIZE_Y / 2);
    textAlign(LEFT, TOP);
    textSize(blockWidth);
  }
}

function step() {
  if (!gameIsOver) levelCount -= 1;
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

let BLACK;
let PURPLE;
let YELLOW;
let GREEN;
let BLUE;
let RED;
let ORANGE;
let BRIGHT_BLUE;
let WHITE;
let GRAY;

let Colors;

const WINDOW_SIZE_X = 800;
const WINDOW_SIZE_Y = 800;

const countFall = 50;

let b1;
let grid = [];
let gameIsOver = false;
let points = 0;
let fall = countFall;
let speed = 1;
let trueSpeed = 1;
let blockWidth = 30;
let anchorX = (WINDOW_SIZE_X - blockWidth * 10) / 2;
let timeTillLevelUp = 5000;
let levelCount = timeTillLevelUp;
let level = 1;
let maxLevel = 10;

function setup() {

  BlockColors = {
  PURPLE:
  color(158, 23, 179),
  GREEN:
  color(161, 235, 52),
  YELLOW:
  color(255, 255, 0),
  BLUE:
  color(0, 119, 255),
  RED:
  color(255, 0, 0),
  ORANGE:
  color(255, 106, 0),
  BRIGHT_BLUE:
  color(0, 221, 255)
};

BLACK = color(0, 0, 0);
PURPLE = color(158, 23, 179);
YELLOW = color(255, 255, 0);
GREEN = color(161, 235, 52);
BLUE = color(0, 119, 255);
RED = color(255, 0, 0);
ORANGE = color(255, 106, 0);
BRIGHT_BLUE = color(0, 221, 255);
WHITE = color(255, 255, 255);
GRAY = color(50);

createCanvas(WINDOW_SIZE_X, WINDOW_SIZE_Y);
b1 = new Block();
b1.xPos = anchorX + blockWidth * 3;
b1.yPos = 0;
for (let i = 0; i < 20; i++) {
  grid[i] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
}
}

function keyAction() {
  if (keyCode === RIGHT_ARROW) {
    if (b1.xPos + blockWidth * 4 < anchorX + blockWidth * 10) {
      b1.xPos += blockWidth;
    }
  } else if (keyCode === LEFT_ARROW) {
    if (b1.xPos - blockWidth >= anchorX) {
      b1.xPos -= blockWidth;
    }
  } else if (keyCode === DOWN_ARROW) {
    if (b1.yPos + blockWidth * 4 < blockWidth * 20) {
      fall = countFall;
      b1.yPos += blockWidth;
    }
  } else if (keyCode === UP_ARROW) {
    b1.rotate();
  } else if (keyCode === 32) {
    while (!b1.atFloor()) {
      b1.yPos += 1;
    }
    b1.land();
  }
}


function drawGrid() {
  for (let i = 0; i < 20; i++) {
    for (let j = 0; j < 10; j++) {
      if (grid[i][j] !== 0) {
        fill(grid[i][j]);
        rect(anchorX + blockWidth * j, blockWidth * i, blockWidth, blockWidth);
      }
    }
  }
}

function gameOver() {
  for (let i = 0; i < 10; i++) {
    if (grid[0][i] !== 0) {
      return true;
    }
  }
  return false;
}

class Block {
  constructor() {
    this.shape = random(shapes);
    this.xPos = 0;
    this.yPos = 0;
    this.color = random(Object.values(BlockColors));
  }

  draw() {
    fill(this.color);
    for (let i = 0; i < 4; i++) {
      for (let j = 0; j < 4; j++) {
        if (this.shape[i][j] === 1) {
          rect(this.xPos + blockWidth * j, this.yPos + blockWidth * i, blockWidth, blockWidth);
        }
      }
    }
  }

  rotate() {
    let newShape = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]];
    for (let i = 0; i < 4; i++) {
      for (let j = 0; j < 4; j++) {
        newShape[i][j] = this.shape[3 - j][i];
      }
    }
    this.shape = newShape;
  }

  atFloor() {
    for (let i = 0; i < 4; i++) {
      for (let j = 0; j < 4; j++) {
        if (this.shape[i][j] === 1) {
          if (i + this.yPos / blockWidth + 1 > 19) {
            return true;
          } else if (grid[i + this.yPos / blockWidth + 1][j + this.xPos / blockWidth] !== 0) {
            return true;
          }
        }
      }
    }
    return false;
  }

  land() {
    for (let i = 0; i < 4; i++) {
      for (let j = 0; j < 4; j++) {
        if (this.shape[i][j] === 1) {
          grid[i + this.yPos / blockWidth][j + this.xPos / blockWidth] = this.color;
        }
      }
    }
    b1 = new Block();
    b1.xPos = anchorX + blockWidth * 3;
    b1.yPos = 0;
    points += this.removeFullRows();
    fall = countFall;
  }

  removeFullRows() {
    let count = 0;
    for (let i = 19; i >= 0; i--) {
      let full = true;
      for (let j = 0; j < 10; j++) {
        if (grid[i][j] === 0) {
          full = false;
          break;
        }
      }
      if (full) {
        count += 1;
        for (let k = i; k > 0; k--) {
          for (let l = 0; l < 10; l++) {
            grid[k][l] = grid[k - 1][l];
          }
        }
        i++;
      }
    }
    return count;
  }

  drawNext(x, y) {
    fill(this.color);
    for (let i = 0; i < 4; i++) {
      for (let j = 0; j < 4; j++) {
        if (this.shape[i][j] === 1) {
          rect(x + blockWidth * j, y + blockWidth * i, blockWidth, blockWidth);
        }
      }
    }
  }
}

const shapes = [  [[0, 0, 0, 0], [0, 0, 0, 0], [1, 1, 1, 1], [0, 0, 0, 0]],
  [[0, 0, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0]],
  [[0, 0, 0, 0], [0, 0, 0, 0], [1, 1, 1, 0], [0, 0, 1, 0]],
  [[0, 0, 0, 0], [0, 1, 0, 0], [1, 1, 0, 0], [1, 0, 0, 0]],
  [[0, 0, 0, 0], [0, 0, 0, 0], [1, 1, 1, 0], [1, 0, 0, 0]],
  [[0, 0, 0, 0], [1, 0, 0, 0], [1, 1, 0, 0], [0, 1, 0, 0]],
  [[0, 0, 0, 0], [0, 0, 0, 0], [0, 1, 1, 0], [1, 1, 0, 0]]
];
