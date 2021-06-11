PImage colorPickerIMG;
ColorPicker colorPicker = new ColorPicker(0, 0, 200, 180);

class ColorPicker {
  int x;
  int y;
  int w;
  int h;
  ColorPicker(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  void pickFillColor() {
    loadPixels();
    selectedFillColor = pixels[mouseY*width + mouseX];
  }
  void pickStrokeColor() {
    loadPixels();
    selectedStrokeColor = pixels[mouseY*width + mouseX];
  }
  boolean mouseIsTouching() {
    if (mouseX>=x && mouseX<=x+w && mouseY>=y && mouseY<=y+h) {
      return true;
    }
    return false;
  }
  void click() {
    if (mouseInRect(x,y,w,h)) {
      toolbarAction = true;
      if (mouseButton==LEFT) {
        colorPicker.pickFillColor();
      }
      if (mouseButton==RIGHT) {
        colorPicker.pickStrokeColor();
      }
    }
  }
  void drawThis() {
    fill(selectedFillColor);
    stroke(selectedStrokeColor);
    strokeWeight(4);
    rect(x+2, y+2, w-4, h-4);
    image(colorPickerIMG, x+7, y+7, w-14, h-14);
  }
}

//class ColorPicker {
//  int x;
//  int y;
//  int w;
//  int h;
//  color col[][];
//  ColorPicker(int x, int y, int w, int h) {
//    this.x = x;
//    this.y = y;
//    this.w = w;
//    this.h = h;
//    this.col = new color[h][w];
//    for (int i = 0; i<col.length; i++) {
//      for (int j = 0; j<col[0].length; j++) {
//        col[i][j] = color(j,i*2,0);
//      }
//    }
//  }
//  void pickColor() {
//    selectedColor = pixels[mouseY*width + mouseX];
//  }
//  boolean mouseIsTouching() {
//    if(mouseX>=x && mouseX<=x+w && mouseY>=y && mouseY<=y+h) {
//      return true;
//    }
//    return false;
//  }
//  void drawThis() {
//    loadPixels();
//    for (int i = 0; i<col.length; i++) {
//      for (int j = 0; j<col[0].length; j++) {
//        pixels[(y+i)*width + x+j] = col[i][j];
//      }
//    }
//    updatePixels();
//  }
//}
