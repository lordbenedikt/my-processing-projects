PVector rubberBand = null;

void drawRubberBand() {
  if (rubberBand!=null) {
    stroke(0, 120);
    fill(0, 30);
    rect(rubberBand.x, rubberBand.y, mouseX-rubberBand.x, mouseY-rubberBand.y);
    stroke(0);
  }
}

boolean insideRect(float _x, float _y, float x1, float y1, float x2, float y2) {
  boolean outside = (_x<x1 && _x<x2) || (_x>x1 && _x>x2) || (_y<y1 && _y<y2) || (_y>y1 && _y>y2);
  return !outside;
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
