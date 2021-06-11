class TextBox {
  String content;
  String label;
  int maxLength = 10;
  int maxValue = 1000;
  float x;
  float y;
  float w;
  float h;
  boolean active = false;
  TextBox(float x, float y, float w, float h, String content, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.content = content;
    this.label = label;
  }
  void click() {
    if (mouseInRect(x, y, w, h)) {
      toolbarAction = true;
      if (active) {
        content = "";
      } else {
        active = true;
      }
    } else {
      active = false;
      confirmInput();
    }
  }
  void input() {
    if (active) {
      if (keyCode==ENTER) {
        confirmInput();
        return;
      }
      if (keyCode==BACKSPACE) {
        if (content.length() > 0) {
          content = content.substring(0, content.length()-1);
        }
      } else {
        if (Character.isDigit(key)) {
          if (parseFloat(content + key)<maxValue) {
            if (content.length() < maxLength) {
              if (content.equals("0")) {
                content = "" + key;
              } else {
                content += key;
              }
            }
          }
        }
        if (key=='.') {
          if (!content.contains(".") && content.length()>0) {
            content += '.';
          }
        }
      }
    }
  }
  void confirmInput() {
    active = false;
    float value = 0;
    try {
      value = Float.parseFloat(content);
    } 
    catch (NumberFormatException nfe) {
      content = ""+selectedStrWeight;
      return;
    }
    content = "" + value;
    //entferne Nachkommanullstellen
    //if (value%1 == 0) {
    //  content = "" + (int)value;
    //}
    selectedStrWeight = value;
  }
  void drawThis() {
    stroke(0);
    strokeWeight(1);
    // drawBox
    fill(active ? 200 : 150);
    rect(x, y, w, h);
    // draw content
    textAlign(RIGHT, CENTER);
    textSize(h/2);
    fill(0);
    text(content, x+w-10, y+h/2);
    // draw label
    textAlign(LEFT, CENTER);
    text(label, x+10, y+h/2);
  }
}
