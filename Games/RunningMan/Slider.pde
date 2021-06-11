class Slider {
  PVector pos;
  int l;
  float minVal = 0;
  float maxVal = 200;
  float value = 0;
  float[] args;
  String label;
  int sliderY = 20;
  int serialNumber = 0;
  Slider(String label, float x,float y,int l,float value,float minVal,float maxVal) {
    pos = new PVector(x,y);
    this.l = l;
    this.value = value;
    this.label = label;
    this.minVal = minVal;
    this.maxVal = maxVal;
  }
  Slider(String label, float x,float y,int l,float value,float minVal,float maxVal,int serialNumber) {
    this(label,x,y,l,value,minVal,maxVal);
    this.serialNumber = serialNumber;
  }
  boolean isColliding(float x,float y) {
    return insideBox(pos.x-6-15, pos.y-6+sliderY, l+12+30, 12, mouseX, mouseY);
  }
  void update() {
  //draw
  fill(0);
  textAlign(CENTER,TOP);
  text(label+": "+value,pos.x+l/2,pos.y);
  fill(100);
  triangle(pos.x-20,pos.y+sliderY,pos.x-10,pos.y-6+sliderY,pos.x-10,pos.y+6+sliderY);
  triangle(pos.x+l+20,pos.y+sliderY,pos.x+l+10,pos.y-6+sliderY,pos.x+l+10,pos.y+6+sliderY);
  strokeWeight(3);
  textSize(10);
  line(pos.x,pos.y+sliderY,pos.x+l,pos.y+sliderY);
  ellipse(pos.x,pos.y+sliderY,6,6);
  ellipse(pos.x+l,pos.y+sliderY,6,6);
  ellipse(pos.x+(value-minVal)*(l/(maxVal-minVal)),pos.y+sliderY,12,12);
  strokeWeight(1);
  }
}
