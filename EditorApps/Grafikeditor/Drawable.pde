List<Drawable> drawables = new ArrayList<Drawable>();
List<Drawable> redoStack = new ArrayList<Drawable>();
float pivotX = 0;
float pivotY = 0;

interface Drawable {
  color fillColor = 255;
  color strokeColor = 0;
  float strWeight = 1;

  color getFillColor();
  color getStrokeColor();
  float getStrWeight();
  String toString();

  void drag();
  void drawThis();
}

class Line implements Drawable {
  float x1;
  float y1;
  float x2;
  float y2;
  color strokeColor;
  float strWeight;
  Line(float x1, float y1, float x2, float y2, color strokeColor, float strWeight) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.strokeColor = strokeColor;
    this.strWeight = strWeight;
  }
  color getFillColor() {
    return fillColor;
  }
  color getStrokeColor() {
    return strokeColor;
  }
  float getStrWeight() {
    return strWeight;
  }
  String toString() {
    return "line(" + (x1-pivotX) + ", " + (y1-pivotY) + ", " + (x2-pivotX) + ", " + (y2-pivotY) + ");\n";
  }
  void drag() {
      x2 = mouseX;
      y2 = mouseY;
  }
  void drawThis() {
    stroke(strokeColor);
    strokeWeight(strWeight);
    line(x1, y1, x2, y2);
  }
}

class Circle implements Drawable {
  float x;
  float y;
  float r;
  color fillColor;
  color strokeColor;
  float strWeight;
  Circle(float x, float y, float r, color fillColor, color strokeColor, float strWeight) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.fillColor = fillColor;
    this.strokeColor = strokeColor;
    this.strWeight = strWeight;
  }
  color getFillColor() {
    return fillColor;
  }
  color getStrokeColor() {
    return strokeColor;
  }
  float getStrWeight() {
    return strWeight;
  }
  String toString() {
    return "circle(" + (x-pivotX) + ", " + (y-pivotY) + ", " + (2*r) + ");\n";
  }
  void drag() {
    r = dist(x, y, mouseX, mouseY);
  }
  void drawThis() {
    fill(fillColor);
    stroke(strokeColor);
    strokeWeight(strWeight);
    circle(x, y, 2*r);
  }
}

class Rect implements Drawable {
  float x;
  float y;
  float w;
  float h;
  color fillColor;
  color strokeColor;
  float strWeight;
  Tool tool;
  Rect(float x, float y, float w, float h, color fillColor, color strokeColor, float strWeight) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.fillColor = fillColor;
    this.strokeColor = strokeColor;
    this.strWeight = strWeight;
  }
  color getFillColor() {
    return fillColor;
  }
  color getStrokeColor() {
    return strokeColor;
  }
  float getStrWeight() {
    return strWeight;
  }
  String toString() {
    // if w or h is negativ fix
    float _y = y;
    float _x = x;
    float _w = w;
    float _h = h;
    if (_w<0) {
      _w = abs(_w);
      _x -= _w;
    }
    if (_h<0) {
      _h = abs(_h);
      _y -= _h;
    }
    return "rect(" + (_x-pivotX) + ", " + (_y-pivotY) + ", " + _w + ", " + _h + ");\n";
  }
  void drag() {
    w = mouseX-x;
    h = mouseY-y;
  }
  void drawThis() {
    fill(fillColor);
    stroke(strokeColor);
    strokeWeight(strWeight);
    rect(x, y, w, h);
  }
}

class Ellipse implements Drawable {
  float x;
  float y;
  float w;
  float h;
  color fillColor;
  color strokeColor;
  float strWeight;
  Ellipse(float x, float y, float w, float h, color fillColor, color strokeColor, float strWeight) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.fillColor = fillColor;
    this.strokeColor = strokeColor;
    this.strWeight = strWeight;
  }
  color getFillColor() {
    return fillColor;
  }
  color getStrokeColor() {
    return strokeColor;
  }
  float getStrWeight() {
    return strWeight;
  }
  String toString() {
    return "ellipse(" + (x-pivotX) + ", " + (y-pivotY) + ", " + w + ", " + h + ");\n";
  }
  void drag() {
    x = (mouseX+dragFromX)/2;
    y = (mouseY+dragFromY)/2;
    w = abs(mouseX-dragFromX);
    h = abs(mouseY-dragFromY);
  }
  void drawThis() {
    fill(fillColor);
    stroke(strokeColor);
    strokeWeight(strWeight);
    ellipse(x, y, w, h);
  }
}

String colorToRGB(color col) {
  if (col==color(0)) return "0";
  if (col==color(255))return "255";
  return red(col) + ", " + green(col) + ", " + blue(col);
}
