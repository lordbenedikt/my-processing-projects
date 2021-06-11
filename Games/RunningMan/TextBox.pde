class TextBox {
  int state = 0; 
  String result=""; 
  float x;
  float y;
  float w;
  float h;
  String value = "";
  Object obj;
  String field;
  TextBox(float x,float y,float w,float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.obj = runner;
    this.field = "x";
  }
  void setValue() {
  }
  void update() {
    if (activeTextBox==this) fill(255);
    else fill(200);
    rect(x,y,w,h);
    fill(0);
    textAlign(CENTER,CENTER);
    textSize(h/2);
    text(value,x+w/2,y+h/2);
  }
}
