import processing.core.PApplet;
import processing.core.PImage;
import java.util.Random;
import java.io.*;

PImage[] runImage = new PImage[8];
PImage[] standImage = new PImage[1];
PImage forestBG;
PImage mountainsBG;
PImage tableIMG;

PImage grassImage;

float lastXSpeed;

void mouseReleased() {
  //MENU
  if (state==GM.MENU) {
    int clickedButton = clickedButton(menuButtons);
    if (clickedButton!=-1) {
      //PLAY button
      if (clickedButton==0) {
        state = GM.PLAY;
      }
      //EDITOR button
      if (clickedButton==1) {
        state = GM.EDITOR;
      }
      return;
    }
  }

  //EDITOR
  if (mouseButton==LEFT) {
    if (state==GM.EDITOR) {
      clickEditor();
    }
  }
  if (mouseButton==RIGHT) {
    createRect.visible = false;

    //Selecting Object
    //SELECT LASER
    for (Laser las : lasers) {
      if (las.isColliding(mouseX+cam.pos.x, mouseY+cam.pos.y)) {
        selection = las;
        editorSliders.clear();
        editorSliders.add(new Slider("Interval", 200, 10, 100, las.interval, 0, 200));
        editorSliders.add(new Slider("Direction", 350, 10, 100, las.directionOrigin, 0, 359));
        editorSliders.add(new Slider("On-Time:", 500, 10, 100, las.onTime, 0, 100));
        editorSliders.add(new Slider("Delay", 650, 10, 100, las.delay, 0, 100));
        for(int i = 0; i<las.keyPositions.length; i++) {
          if (las.keyPositions[0].time == -1) break;
          editorSliders.add(new Slider("KeyPos"+i, 200+150*i, 40, 100, las.keyPositions[i].dir, -359, 359,i)); 
        }
        break;
      }
    }
  }
  if (mouseButton==CENTER) {
    int i = 0;
    while (i<solidRects.size()) {
      if (solidRects.get(i).isColliding(mouseX+cam.pos.x, mouseY+cam.pos.y)) solidRects.remove(i);
      else i++;
    }
    i = 0;
    while (i<lasers.size()) {
      if (lasers.get(i).isColliding(mouseX+cam.pos.x, mouseY+cam.pos.y)) lasers.remove(i);
      else i++;
    }
  }
}

void clickEditor() {
  int clickedButton = clickedButton(editorButtons);
  if (clickedButton!=-1) {
    //BUTTON ACTIONS
    //Player button
    if (tool==2 && clickedButton==2) { //Laser Button
      System.out.println(laserDirection);
      laserDirection = (laserDirection+90) % 360;
      if (laserDirection==270) editorButtons[2].name = "Laser:UP";
      if (laserDirection==0) editorButtons[2].name = "Laser:RIGHT";
      if (laserDirection==90) editorButtons[2].name = "Laser:DOWN";
      if (laserDirection==180) editorButtons[2].name = "Laser:LEFT";
    }
    tool = clickedButton;
    return;
  } 
  //CLICK MAP NUMBER
  clickedButton = clickedButton(mapButtons);
  if (clickedButton!=-1) {
    mapNum = clickedButton;
    return;
  }
  //CLICK SLIDER
  for (int i = 0; i<editorSliders.size(); i++) {
    Slider s = editorSliders.get(i);
    //change value
    if (s.isColliding(mouseX, mouseY)) {
      if (mouseX<s.pos.x-6) {  //decrease by 1
        float selVal = selection.getValue(i);
        if (selVal>s.minVal+1) selection.setValue(i, (float)Math.ceil(selVal-1));
        else selection.setValue(i, s.minVal);
      } else if (mouseX<s.pos.x) selection.setValue(i, s.minVal); //s.value = s.minVal;
      else if (mouseX>s.pos.x+s.l+6) {  //increase by 1
        float selVal = selection.getValue(i);
        if (selVal<s.maxVal-1) selection.setValue(i, (float)Math.floor(selVal+1));
        else selection.setValue(i, s.maxVal);
      } else if (mouseX>s.pos.x+s.l) selection.setValue(i, s.maxVal); //s.value = s.maxVal;
      else selection.setValue(i, (s.minVal + (s.maxVal-s.minVal)*((mouseX-s.pos.x)/s.l)) );
      s.value = selection.getValue(i);
      return;
    }
  }
  //CLICK TEXTBOX
  for (TextBox tb : textBoxes) {
    if (insideBox(tb.x,tb.y,tb.w,tb.h,mouseX, mouseY)) {
      if (activeTextBox!=tb) activeTextBox = tb;
      else activeTextBox = null;
      return;
    }
    else {
      if(activeTextBox!=null) {
        activeTextBox = null;
        return;
      }
    }
  }
  //Save button
  if (insideBox(saveButton.pos.x, saveButton.pos.y, saveButton.w, saveButton.h, mouseX, mouseY)) {
    saveMap("map0"+mapNum+".txt");
    return;
  }
  //Load button
  if (insideBox(loadButton.pos.x, loadButton.pos.y, loadButton.w, loadButton.h, mouseX, mouseY)) {
    loadMap("map0"+mapNum+".txt");
    return;
  }

  //If no button was clicked
  //TOOL ACTION
  if (tool==0) {
    runner.x = mouseX+cam.pos.x;
    runner.y = mouseY+cam.pos.y;
  }
  //SOLID RECT
  if (tool==1) {
    if (!createRect.visible) {
      createRect.visible = true;
      createRect.pos.x = mouseX+cam.pos.x;
      createRect.pos.y = mouseY+cam.pos.y;
    } else {
      solidRects.add(new SolidRect(
        createRect.pos.x, createRect.pos.y, 
        mouseX-createRect.pos.x+cam.pos.x, mouseY-createRect.pos.y+cam.pos.y, true));
      createRect.visible = false;
    }
  }
  if (tool==2) {
    lasers.add(new Laser(mouseX+cam.pos.x, mouseY+cam.pos.y, laserDirection));
  }
  if (tool==3) {
    prefabs.add(new Table(mouseX+cam.pos.x, mouseY+cam.pos.y));
  }
}

class Button {
  PVector pos;
  String name;
  float w;
  float h;
  float fontsize;
  int col;
  Button(String name, float x, float y, float w, float h, int col, float fontsize) {
    this.pos = new PVector(x, y);
    this.name = name;
    this.fontsize = fontsize;
    this.w = w;
    this.h = h;
    this.col = col;
  }
  void update() {
    fill(col);
    rect(pos.x, pos.y, w, h);
    fill(0);
    textSize(fontsize);
    textAlign(CENTER, CENTER);
    text(name, pos.x+w/2, pos.y+h/2);
  }
}

class SolidRect {
  float x1;
  float y1;
  float x2;
  float y2;
  PVector grassPivot = new PVector(60,30);
  boolean visible = true;
  void update() {
    //draw
    if (visible) {
      fill(groundColor);
      rect(x1, y1, x2-x1, y2-y1);
      drawGrass();
    } else {
      if (state==GM.EDITOR) {
      fill(0, 0);
      rect(x1, y1, x2-x1, y2-y1);
      }
    }
    noStroke();
  }
  SolidRect(float x1, float y1, float rectWidth, float rectHeight) {
    this.x1 = (rectWidth>=0) ? x1 : x1+rectWidth;
    this.y1 = (rectHeight>=0) ? y1 : y1+rectHeight;
    this.x2 = (rectWidth>=0) ? x1+rectWidth : x1;
    this.y2 = (rectHeight>=0) ? y1+rectHeight : y1;
  }
  SolidRect(float x1, float y1, float rectWidth, float rectHeight, boolean visible) {
    this(x1,y1,rectWidth,rectHeight);
    this.visible = visible;
  }
  boolean isColliding(float x, float y) {
    return insideBox(x1, y1, x2-x1, y2-y1, x, y);
  }
  boolean isBoxColliding(float x1, float y1, float x2, float y2) {
    if ( (isBetween(y1, this.y1, this.y2)||isBetween(y2, this.y1, this.y2)||isBetween(this.y1, y1, y2)) && (isBetween(x1, this.x1, this.x2)||isBetween(x2, this.x1, this.x2)) ) return true; //top&bottom
    //if ( isBetween(y2,this.y1,this.y2) && (isBetween(x1,this.x1,this.x2)||isBetween(x2,this.x1,this.x2)) ) return true; //bottom
    if ( (isBetween(x1, this.x1, this.x2)||isBetween(x2, this.x1, this.x2)||isBetween(this.x1, x1, x2)) && (isBetween(y1, this.y1, this.y2)||isBetween(y2, this.y1, this.y2)) ) return true; //left&right
    //if ( isBetween(x2,this.x1,this.x2) && (isBetween(y1,this.y1,this.y2)||isBetween(y2,this.y1,this.y2)) ) return true; //right
    return false;
  }
  void drawGrass() {
    float rectLength = x2-x1;
    int reps = (int)rectLength/100 + 1;
    float rem = rectLength%100;
    for(int i = 0; i<reps; i++) {
      if (i==reps-1 && i!=0)
        image(grassImage,x1 + 50-grassPivot.x + 100*i - (100-rem),y1-grassPivot.y);
      else if (reps!=1)
        image(grassImage,x1 + 50-grassPivot.x + 100*i,y1-grassPivot.y);
    }
  }
}

class CreateRect {
  PVector pos;
  float w = 100;
  float h = 100;
  boolean visible = false;
  CreateRect(float x, float y, float w, float h) {
    pos = new PVector(x, y);
    this.w = w;
    this.h = h;
  }
  void update() {
    fill(color(groundColor));
    if (visible)
      rect(pos.x, pos.y,-100, mouseX+cam.pos.x-pos.x, mouseY+cam.pos.y-pos.y);
  }
}

class Camera {
  PVector pos = new PVector(-200, -200);
  float top = 200f;
  float bottom = 200f;
  float left = 350f;
  float right = 350f;
  int speed = 8;
  //Camera(float top, float bottom, float left, float right) {
  //  this.top = top;
  //  this.bottom = bottom;
  //  this.left = left;
  //  this right = right;
  //}
  void keyAction() {
    if (state==GM.PLAY) {
      if (keyW && bottom>0) {
        bottom = bottom - speed;
        top = top + speed;
      }
      if (keyS && top>0) {
        top = top - speed;
        bottom = bottom + speed;
      }
      if (keyA && right>0) {
        right = right - speed;
        left = left + speed;
      }
      if (keyD && left>0) {
        left = left - speed;
        right = right + speed;
      }
    }
    if (state==GM.EDITOR) {
      if (keyW) cam.pos.y -= speed;
      if (keyS) cam.pos.y += speed;
      if (keyA) cam.pos.x -= speed;
      if (keyD) cam.pos.x += speed;
    }
  }
  void update() {
    keyAction();
    if (state==GM.PLAY) {
      if (runner.x < pos.x+left) pos.x = runner.x-left;
      if (runner.x > pos.x+width-right) pos.x = runner.x-width+right;
      if (runner.y < pos.y+top) pos.y = runner.y-top;
      if (runner.y > pos.y+height-bottom) pos.y = runner.y-height+bottom;
    }
  }
}


//check wether point is inside any solid rectangle
boolean collWithRects(float x, float y) {
  for (SolidRect rect : solidRects) {
    if (rect.isColliding(x, y)) 
      return true;
  }
  return false;
}

boolean collBoxWithRects(float x1, float y1, float x2, float y2) {

  for (SolidRect rect : solidRects) {

    if (rect.isBoxColliding(x1, y1, x2, y2)) 
      return true;
  }

  return false;
}

void keyActionEditor() {
  if (keyDel) {
    if (selection!=null) {
      selection.remove();
      selection = null;
    }
  }
}
