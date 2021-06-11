boolean mouseInRect(float x, float y, float w, float h) {
  return (mouseX>=x && mouseX<=x+w && mouseY>=y && mouseY<=y+h);
}

void loadImages() {
  colorPickerIMG = loadImage("color_picker2.png", "png");
  toolbarCircle = loadImage("toolbar_circle.png");
  toolbarRect = loadImage("toolbar_rect.png");
  toolbarLine = loadImage("toolbar_line.png");
  toolbarEllipse = loadImage("toolbar_ellipse.png");
  toolbarBucket = loadImage("toolbar_bucket.png");
}

void button(float x, float y, float w, float h, boolean isDown, float thickness) {
  if (!isDown) {
    noStroke();
    fill(100);
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
    fill(80);
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

void drawPoint(float x, float y) {
  stroke(255,0,0);
  strokeWeight(1);
  line(x-5,y-5,x+5,y+5);
  line(x-5,y+5,x+5,y-5);
}
