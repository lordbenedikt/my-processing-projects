class Cell {
  float x;
  float y;
  float s;
  int col;
  int row;
  int num = 0;
  boolean marked = false;
  boolean open = false;
  Cell(float x, float y, float s, int col, int row) {
    this.x = x;
    this.y = y;
    this.s = s;
    this.col = col;
    this.row = row;
  }
  void leftClick() {
    if(firstClick) {
      while(num!=0) {
        reset();
      }
      firstClick = false;
    }
    if (gameOver) return;
    if (open || marked) return;
    open = true;
    if (num==-1) {
      gameOver = true;
    }
    if (num==0) {
      clickSurroundings();
    }
  }
  void rightClick() {
    if (gameOver) return;
    marked = !marked;
  }
  void centerClick() {
    if (open) {
      clickSurroundings();
    }
  }
  void clickSurroundings() {
    if (col!=0 && row!=0)
      minefield[col-1][row-1].leftClick();
    if (row!=0)
      minefield[col][row-1].leftClick();
    if (col!=cols-1 && row!=0)
      minefield[col+1][row-1].leftClick();
    if (col!=0)
      minefield[col-1][row].leftClick();
    if (col!=cols-1)
      minefield[col+1][row].leftClick();
    if (col!=0 && row!=rows-1)
      minefield[col-1][row+1].leftClick();
    if (row!=rows-1)
      minefield[col][row+1].leftClick();
    if (col!=cols-1 && row!=rows-1)
      minefield[col+1][row+1].leftClick();
  }
  void drawThis() {
    if (num==-1) {
      if (victory) {
        fill(200, 150, 0);
      } else {
        fill(255, 0, 0);
      }
    } else if (open) {
      fill(100);
    } else {
      fill(200);
    }
    stroke(0);
    if (gameOver) {
      rect(x, y, s, s);
    } else if (open) {
      stroke(1);
      fill(100);
      rect(x, y, s, s);
    } else if (mousePressed && mouseX>=x && mouseX<x+s && mouseY>=y && mouseY<y+s) {
      button(x, y, s, s, true, 2);
    } else {
      button(x, y, s, s, false, 2);
    }
    fill(0);
    if (!open && marked) {
      if (marked) {
        fill(255, 255, 0);
        stroke(0);
        circle(x+s/2, y+s/2, 10);
      }
    }
    if (open || gameOver) {
      textAlign(CENTER, CENTER);
      fill(0);
      if (num!=-1 && (!marked || open)) {
        text(num, x+s/2, y+s/2);
      }
    }
  }
}

void button(float x, float y, float w, float h, boolean isDown, float thickness) {
  if (!isDown) {
    noStroke();
    fill(150);
    rect(x+thickness/2, y+thickness/2, w-thickness/2-1, h-thickness/2-1);
    strokeWeight(thickness);
    stroke(0);
    line(x+thickness/2+1, y+h-thickness/2, x+w-thickness/2-1, y+h-thickness/2);
    line(x+w-thickness/2, y+thickness/2+1, x+w-thickness/2, y+h-thickness/2-1);
    stroke(200);
    line(x+thickness/2+1, y+thickness/2, x+w-thickness/2-1, y+thickness/2);
    line(x+thickness/2-1, y+thickness/2+1, x+thickness/2-1, y+h-thickness/2-1);
  } else {
    noStroke();
    fill(100);
    rect(x+1, y+1, w-2, h-2);
    strokeWeight(thickness);
    stroke(150);
    line(x+1, y+h-1, x+w-2, y+h-1);
    line(x+w-1, y+1, x+w-1, y+h-2);
    stroke(0);
    line(x+1, y, x+w-2, y);
    line(x, y+1, x, y+h-2);
  }
}
