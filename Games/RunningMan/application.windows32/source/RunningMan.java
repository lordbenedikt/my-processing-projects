import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.core.PApplet; 
import processing.core.PImage; 
import java.util.Random; 
import java.io.*; 
import java.lang.reflect.Field; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class RunningMan extends PApplet {






PImage[] runImage = new PImage[8];
PImage[] standImage = new PImage[1];
PImage forestBG;
PImage mountainsBG;
PImage tableIMG;

PImage grassImage;

float lastXSpeed;

public void mouseReleased() {
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

public void clickEditor() {
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
  public void update() {
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
  public void update() {
    //draw
    if (visible) {
      fill(groundColor);
      rect(x1, y1, x2-x1, y2-y1);
      //drawGrass();
    } else {
      if (state==GM.EDITOR) {
      fill(0, 0);
      rect(x1, y1, x2-x1, y2-y1);
      }
    }
    strokeWeight(1);
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
  public boolean isColliding(float x, float y) {
    return insideBox(x1, y1, x2-x1, y2-y1, x, y);
  }
  public boolean isBoxColliding(float x1, float y1, float x2, float y2) {
    if ( (isBetween(y1, this.y1, this.y2)||isBetween(y2, this.y1, this.y2)||isBetween(this.y1, y1, y2)) && (isBetween(x1, this.x1, this.x2)||isBetween(x2, this.x1, this.x2)) ) return true; //top&bottom
    //if ( isBetween(y2,this.y1,this.y2) && (isBetween(x1,this.x1,this.x2)||isBetween(x2,this.x1,this.x2)) ) return true; //bottom
    if ( (isBetween(x1, this.x1, this.x2)||isBetween(x2, this.x1, this.x2)||isBetween(this.x1, x1, x2)) && (isBetween(y1, this.y1, this.y2)||isBetween(y2, this.y1, this.y2)) ) return true; //left&right
    //if ( isBetween(x2,this.x1,this.x2) && (isBetween(y1,this.y1,this.y2)||isBetween(y2,this.y1,this.y2)) ) return true; //right
    return false;
  }
  public void drawGrass() {
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
  public void update() {
    fill(color(groundColor));
    if (visible)
      rect(pos.x, pos.y, mouseX+cam.pos.x-pos.x, mouseY+cam.pos.y-pos.y);
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
  public void keyAction() {
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
  public void update() {
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
public boolean collWithRects(float x, float y) {
  for (SolidRect rect : solidRects) {
    if (rect.isColliding(x, y)) 
      return true;
  }
  return false;
}

public boolean collBoxWithRects(float x1, float y1, float x2, float y2) {

  for (SolidRect rect : solidRects) {

    if (rect.isBoxColliding(x1, y1, x2, y2)) 
      return true;
  }

  return false;
}

public void keyActionEditor() {
  if (keyDel) {
    if (selection!=null) {
      selection.remove();
      selection = null;
    }
  }
}
public void draw() {
  
  background(200);
  image(mountainsBG, -300-(int)cam.pos.x/8, -300-(int)cam.pos.y/8);
  //draw all
  //GAME OVER BLACK
  if (state==GM.GAME_OVER) {
    background(0);
  }


  //draw RELATIVE to camera
  pushMatrix();
  translate(-cam.pos.x, -cam.pos.y);

  //move camera
  if(true)
    cam.update();

  //draw all objects

  for (Prefab prefab : prefabs) {
    prefab.update();
  }
  
  runner.update();
  
  for (Laser laser : lasers) {
    laser.update();
  }

  for (SolidRect rect : solidRects) {
    rect.update();
  }
  
  //only in editor
  if (state==GM.EDITOR) {
    if (selection!=null) selection.drawSelection();
    createRect.update();
  }
  popMatrix();


  //draw with FIXED position
  for(TextBox tb : textBoxes) {
    tb.update();
  }
  if (state==GM.MENU) {
    for (Button b : menuButtons) {
      b.update();
    }
  }
  if (state==GM.EDITOR) {
    keyActionEditor();
    for (int i = 0; i<editorButtons.length; i++) {
      Button b = editorButtons[i];
      if (tool==i) b.col = WHITE;
      else b.col = GREY;
      b.update();
    }
    for (Slider s : editorSliders) {
      s.update();
    } 
    //Save & Load
    saveButton.update();
    loadButton.update();
    for (int i = 0; i<mapButtons.length; i++) {
      Button b = mapButtons[i];
      if (mapNum==i) b.col = WHITE;
      else b.col = GREY;
      b.update();
    }
  }

  //open menu
  if (keyEsc) {
    if (state!=GM.MENU)
      state = GM.MENU;
    else
      state = GM.PLAY;
  }
  keyEsc = false;
  //RESTART
  if (keyR) {
    runner.health = 100;
    state = GM.PLAY;
    loadMap("map0"+mapNum+".txt");
  }
  //GAME OVER
  if (state==GM.GAME_OVER) {
    textAlign(CENTER, CENTER);
    textSize(100);
    fill(255);
    text("GAME OVER", width/2, height/4);
  }
  //stats
  fill(0);
  textSize(10);
  textAlign(LEFT, BOTTOM);
  text("x-Pos: " + runner.x, 10, height-10);
  text("y-Pos: " + runner.y, 10, height-20);
  text("x-Speed: " + runner.speed.x, 10, height-30);
  text("y-Speed: " + runner.speed.y, 10, height-40);
  text("lastXSpeed: " + lastXSpeed, 10, height-50);
  text("selected: " + selection, 10, height-60);
    text("mouseX: " + (mouseX+cam.pos.x), 10, height-70);
  text("mouseY: " + (mouseY+cam.pos.y), 10, height-80);
  textSize(20);
  textAlign(LEFT, TOP);
  text("Health: " + runner.health, 10, 10);
  if (runner.speed.x!=0) lastXSpeed = runner.speed.x;
}
class Laser implements Configurable {
  PVector pos;
  PVector target;
  PVector dir;
  float directionOrigin;
  float direction;
  float interval = 100;
  float countdown;
  float countdown2;
  float onTime = 50;
  float delay = 0;
  KeyPos[] keyPositions = {new KeyPos(0,-1)};
  int keyPhase = 0;
  boolean on = false;
  Laser(float x, float y, float directionOrigin, float interval, float onTime, float delay) {
    pos = new PVector(x, y);
    target = new PVector(x, y);
    dir = PVector.fromAngle(TWO_PI*directionOrigin/360);
    this.directionOrigin = directionOrigin;
    direction = directionOrigin;
    this.interval = interval;
    this.onTime = onTime;
    this.delay = delay;
    countdown = interval*onTime/100 + delay;
  }
  Laser(float x, float y, float directionOrigin, float interval, float onTime, float delay, KeyPos[] keyPositions) {
    this(x, y, directionOrigin, interval, onTime, delay);
    this.keyPositions = keyPositions;
    countdown2 = keyPositions[0].time;
  }
  Laser(float x, float y, float directionOrigin, float interval, float onTime, float delay, int keyPosNum) {
    this(x, y, directionOrigin, interval, onTime, delay);
    keyPositions = new KeyPos[keyPosNum];
    for(int i = 0; i<keyPosNum; i++) {
      keyPositions[i] = new KeyPos(0,50);
    }
  }
  Laser(float x, float y, int direction) {
    this(x, y, direction, 100, 50, 0);
  }
  public void drawSelection() {
    fill(0, 0);
    stroke(255, 255, 255);
    ellipse(pos.x, pos.y, 20, 20);
    stroke(0);
  }
  public void update() {
    //ON/OFF
    if (countdown>1) {
      countdown--;
    } else {
      if (on) {
        countdown = (100-onTime)/100*interval;
        on = false;
      } else {
        countdown = onTime/100*interval;
        on = true;
      }
    }

    //ROTATE Laser
    if (keyPositions[0].time!=-1) {
      float lastAngle = directionOrigin + keyPositions[keyPhase].dir;
      float nextAngle = directionOrigin + keyPositions[(keyPhase+1)%keyPositions.length].dir;
      direction = lastAngle + (nextAngle-lastAngle)*(keyPositions[keyPhase].time-countdown2)/keyPositions[keyPhase].time;
      if (countdown2>1) countdown2--;
      else {
        keyPhase = (keyPhase+1) % keyPositions.length;
        countdown2 = keyPositions[keyPhase].time;
      }
    }

    //Draw when on
    if (on) {
      //shoot and draw laser
      laser(pos.x, pos.y, direction, false);
    }

    //DRAW METAL
    strokeWeight(2);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(direction/360*TWO_PI);
    fill(groundColor);
    rect(5, -3, 10, 6);
    ellipse(0, 0, 10, 10);
    popMatrix();
    strokeWeight(1);
  }
  public boolean isColliding(float x, float y) {
    return insideCircle(pos.x, pos.y, 12, mouseX+cam.pos.x, mouseY+cam.pos.y);
  }
  public void remove() {
    lasers.remove(this);
  }
  public void setValue(int num, float value) {
    if (num==0) interval = (int)value;
    if (num==1) {
      directionOrigin = (int)value;
      direction = (int)value;
      dir = PVector.fromAngle(TWO_PI*directionOrigin/360);
    }
    if (num==2) onTime = (int)value;
    if (num==3) delay = (int)value;
    if (num>=4) keyPositions[num-4].dir = value;
    if (num>=10 && num<20) keyPositions[num%10].dir = value;
    if (num>=20 && num<30) keyPositions[num%10].time = value;
  }
  public float getValue(int num) {
    if (num==0) return interval;
    if (num==1) return directionOrigin;
    if (num==2) return onTime;
    if (num==3) return delay;
    if (num>=4) return keyPositions[num-4].dir;
    if (num>=10 && num<20) return keyPositions[num%10].dir;
    if (num>=20 && num<30) return keyPositions[num%10].time;
    return -1;
  }
}

class KeyPos implements Savable {
  float dir;
  float time;
  KeyPos(float dir, float time) {
    this.dir = dir;
    this.time = time;
  }
}
public interface Configurable {
  public void setValue(int num, float value);
  public float getValue(int num);
  public void drawSelection();
  public void remove();
}
public interface Savable {
  //void setVal(int num, float value);
  //float getVal(int num);
}
//Keys
boolean keyW = false;
boolean keyS = false;
boolean keyA = false;
boolean keyD = false;
boolean keyUp = false;
boolean keyDown = false;
boolean keyLeft = false;
boolean keyRight = false;
boolean keyEsc = false;
boolean keySpace = false;
boolean keyR = false;
boolean keyShift = false;
boolean keyDel = false;

public void keyPressed() {
  if (keyCode == ESC) {
    key = 0;
    keyEsc = true;
  }
  if (state==GM.EDITOR) {
    if (activeTextBox!=null) {
      handleInput(key);
      return;
    }
  }
  if (keyCode == UP) keyUp = true;
  if (keyCode == DOWN) keyDown = true;
  if (keyCode == LEFT) keyLeft = true;
  if (keyCode == RIGHT) keyRight = true;
  if (keyCode == SHIFT) keyShift = true;
  if (keyCode == DELETE) keyDel = true;
  if (Character.toUpperCase(key) == 'W') keyW = true;
  if (Character.toUpperCase(key) == 'S') keyS = true;
  if (Character.toUpperCase(key) == 'A') keyA = true;
  if (Character.toUpperCase(key) == 'D') keyD = true;
  if (key == ' ') keySpace = true;
  if (Character.toUpperCase(key) == 'R') keyR = true;
}

public void keyReleased() {
  //if (keyCode == ESC) keyEsc = false;
  if (keyCode == UP) keyUp = false;
  if (keyCode == DOWN) keyDown = false;
  if (keyCode == LEFT) keyLeft = false;
  if (keyCode == RIGHT) keyRight = false;
  if (keyCode == SHIFT) keyShift = false;
  if (keyCode == DELETE) keyDel = false;
  if (Character.toUpperCase(key) =='W') keyW = false;
  if (Character.toUpperCase(key) == 'S') keyS = false;
  if (Character.toUpperCase(key) == 'A') keyA = false;
  if (Character.toUpperCase(key) == 'D') keyD = false;
  if (key == ' ') keySpace = false;
  if (Character.toUpperCase(key) == 'R') keyR = false;
}
public void handleInput(char key) {
  if (key==BACKSPACE) {
    if(activeTextBox.value.length()>0) {
      System.out.println(activeTextBox.value.length());
      activeTextBox.value = activeTextBox.value.substring(0,activeTextBox.value.length()-1);
    }
    return;
  }
  if (key==ENTER) {
    activeTextBox.setValue();
    activeTextBox = null;
    return;
  }
    activeTextBox.value = activeTextBox.value + key;
}


//@SuppressWarnings("rawtypes")
public Object getValueOf(Object clazz, String lookingForValue) {
    try {
    Field field = clazz.getClass().getField(lookingForValue);
    Class clazzType = field.getType();
    if (clazzType.toString().equals("double"))
      return field.getDouble(clazz);
    else if (clazzType.toString().equals("float"))
      return field.getFloat(clazz);
    else if (clazzType.toString().equals("int"))
      return field.getInt(clazz);
    // else other type ...
    // and finally
    return field.get(clazz);
    } catch(Exception e) {
    return null;
  }
}

public void setFloatField(String fieldName, float value)
        /*throws NoSuchFieldException, IllegalAccessException*/ {
          try {
    Field field = getClass().getDeclaredField(fieldName);
    field.setFloat(this, value);
          } catch(Exception e) {}
}

public Object getValueFromString(String s) {
  String[] aspects0 = s.split(".");
  //if (aspects0.length==1) return getValueOf()
  Object res;
  for(String a : aspects0) {
    String temp;
    if (a.contains("[")) temp = a.split("[")[1];
  }
  return null;
}

public void imageMirrored(PImage img, float x, float y) {
  //in draw()
  //store scale, translation, etc
  pushMatrix();

  //flip across x axis
  scale(-1, 1);

  //The x position is negative because we flipped
  image(img, -x-img.width, y);

  //restore previous translation,etc
  popMatrix();
}

public int clickedButton(Button[] buttons) {
  int clickedButton = -1;

  for (int i =0; i<buttons.length; i++) {
    Button b = buttons[i];
    if (insideBox(b.pos.x, b.pos.y, b.w, b.h, mouseX, mouseY))
      clickedButton = i;
  }
  return clickedButton;
}

public boolean isBetween(float num, float beginning, float end) {

  if (num>=beginning && num<=end) return true;

  if (num>=end && num<=beginning) return true;

  return false;
}

public boolean insideCircle(float x, float y, float r, float xThis, float yThis) {
  return (Math.sqrt(Math.pow(xThis-x, 2)+Math.pow(yThis-y, 2))<=r);
}

public boolean insideBox(float x1, float y1, float w, float h, float xThis, float yThis) {
  float x2 = x1+w;
  float y2 = y1+h;
  if (xThis<x1 && xThis<x2) return false;
  if (xThis>x1 && xThis>x2) return false;
  if (yThis<y1 && yThis<y2) return false;
  if (yThis>y1 && yThis>y2) return false;
  return true;
}

public void laser(float x1, float y1, float direction, boolean friendly) {
  //reset target
  PVector dir = PVector.fromAngle(TWO_PI*direction/360);
  float x2 = x1;
  float y2 = y1;

  int i = 0;
  while (i < 10000) {
    if (collWithRects(x2, y2)) {
      break;
    }
    if (runner.isColliding(x2, y2) && !friendly) {
      if (state==GM.PLAY) runner.health -= 2f;
      break;
    }
    x2 += dir.x;
    y2 += dir.y;
    i++;
  }

  stroke(color(255, 0, 0), 100);
  strokeWeight(5);
  line(x1, y1, x2, y2);
  strokeWeight(3);
  line(x1, y1, x2, y2);
  stroke(color(255, 255, 255), 100);
  strokeWeight(1);
  line(x1, y1, x2, y2);
  stroke(color(255, 0, 0), 100);
  fill(color(255, 0, 0), 100);
  noStroke();
  ellipse(x2, y2, 8, 8);
  ellipse(x2, y2, 12, 12);
  ellipse(x2, y2, 16, 16);
  fill(color(100));
  stroke(0);
  strokeWeight(1);
  fill(groundColor);
}
interface Prefab {
  public void update();
}

class Table implements Prefab {
  float x;
  float y;
  PVector pivot = new PVector(50,48);
  SolidRect[] collisionBoxes;
  Table(float x, float y) {
    this.x = x;
    this.y = y;
    solidRects.add(new SolidRect(x-45, y-38, 90, 38, false));
  }
  public void update() {
    image(tableIMG,x-pivot.x,y-pivot.y);
  }
}
class Runner {
  float x;
  float y;
  PVector pivot = new PVector(29, 65);
  PVector[] gunPoint = {
    new PVector(22, -34), 
    new PVector(22, -39.5f), 
    new PVector(22, -39), 
    new PVector(22, -33.5f), 
    new PVector(15, -36)};
  int h = 60;
  int w = 14;
  boolean running = false;
  boolean mirrored = false;
  float health = 100;
  int count = 0;
  int subimage = 0;
  PVector speed = new PVector(0, 0);
  Runner(float x, float y) {
    this.x = x;
    this.y = y;
  }
  public void keyAction() {
    if (state!=GM.PLAY) return;
    if (keyUp) {
      if (collBoxWithRects(x-w/2, y-h+1, x+w/2, y+1)) {
        speed.y = -16;
      }
    }
    if (keyLeft) {
      if (speed.x>-plySpeed)
        speed.x--; // = -plySpeed;
      mirrored = false;
      running = true;
    } else if (keyRight) {
      if (speed.x<plySpeed)
        speed.x++; // = plySpeed;
      mirrored = true;
    } else {
      if (speed.x<0) speed.x++;
      else if (speed.x>0) speed.x--;
      else running = false;
    }
    if (keyShift) {
      int posNeg = mirrored?1:-1;
      if (running==true)
        laser(x+gunPoint[subimage%4].x*posNeg, y+gunPoint[subimage%4].y, mirrored?0:180, true);
      else
        laser(x+gunPoint[4].x*posNeg, y+gunPoint[4].y, mirrored?0:180, true);
    }
  }
  public boolean isColliding(float x, float y) {
    return insideBox(this.x-w/2, this.y-h, w, h, x, y);
  }

  public boolean isCollWithSolid(float Xrel, float Yrel) {
    for (SolidRect rect : solidRects) {
      //rect(x-w/2+Xrel, y-h+Yrel, w, h);
      if (rect.isBoxColliding(x-w/2+Xrel, y-h+Yrel, x+w/2+Xrel, y+Yrel)) 
        return true;
    }

    return false;
  }

  public void update() {

    keyAction();
    
    //check wether running
    if (speed.x!=0) running = true;
    else {
      running = false;
      subimage = 0;
    }
    //chose correct frame
    PImage currentImage;
    if (running) {
      subimage = count/5 % 8;
      currentImage = runImage[subimage%4];
    } else currentImage = standImage[0];

    //draw
    pushMatrix();
    translate(runner.x, runner.y);
    scale(0.5f, 0.5f);
    if (!mirrored)
      image(currentImage, -pivot.x*2, -pivot.y*2);
    else
      imageMirrored(currentImage, -pivot.x*2, -pivot.y*2);
    popMatrix();

    if (state==GM.PLAY) {
      if (health<=0) {
        health = 0;
        state = GM.GAME_OVER;
      }
      //gravity
      speed.y += gravity;

      float posNeg = (speed.y<0) ? -1 : 1;
      //check for collision in y-direction to prevent moving into wall
      if (speed.y!=0 && isCollWithSolid(0, speed.y)) {
        posNeg = (speed.y<0) ? -1 : 1;
        for (float temp = 1; temp<=(speed.y*posNeg)+1; temp++) {
          if (temp!=1)
            System.out.println(temp);
          if (isCollWithSolid(speed.x, temp*posNeg)) {
            if (temp>1) speed.y = temp*posNeg - 1*posNeg;
            else {
              speed.y = 0;
            }
            break;
          }
        }
      }
      //check for collision in x-direction to prevent moving into wall
      posNeg = (speed.x<0) ? -1 : 1;
      if (speed.x!=0 && isCollWithSolid(speed.x, speed.y) && isCollWithSolid(speed.x, -20)) {     
        for (float temp = 1; temp<=(speed.x*posNeg)+1; temp++) {
          if (isCollWithSolid(temp*posNeg, 0)) {
            if (temp>1) speed.x = temp*posNeg - 1*posNeg;
            else speed.x = 0;
            break;
          }
        }
      }
      //move up when walking on stairs
      if (isCollWithSolid(speed.x, speed.y)) {
        if (!isCollWithSolid(speed.x, -20)) {
          System.out.println("Hi");
          float aboveGround = -20;
          while (Math.abs(aboveGround)>0.1f) {
            //System.out.println(aboveGround);
            y = y+aboveGround;
            aboveGround = (isCollWithSolid(speed.x, 0)) ? -Math.abs(aboveGround/2) : Math.abs(aboveGround/2);
          }
          if (aboveGround<0) y = y-aboveGround;
        }
      }

      //rect(x-15,y-120,30,120);  //draw collision box

      //update position
      x += speed.x;
      y += speed.y;
      count++;  //is used to choose right subimage
    }
  }
}
KeyPos[] keyPositions = {new KeyPos(0, 0)};

public void saveMap(String name) {
  System.out.println("Saved to "+name);
  saveMapClear(name);
  saveMapAdd(name, String.format("player:%d,%d\n", (int)runner.x, (int)Math.floor(runner.y)));
  saveMapAdd(name, String.format("cam:%d,%d\n", (int)cam.pos.x, (int)cam.pos.y));
  for (SolidRect r : solidRects) {
    String line = String.format("rect:%d,%d,%d,%d,%d\n", (int)r.x1, (int)r.y1, (int)(r.x2-r.x1), (int)(r.y2-r.y1), r.visible?1:0);
    saveMapAdd(name, line);
  }
  for (Laser las : lasers) {
    String line = String.format("laser:%f,%f,%f,%f,%f,%f,keyPos=", las.pos.x, las.pos.y, las.directionOrigin, las.interval, las.onTime, las.delay);
    for (int i = 0; i<las.keyPositions.length; i++) {
      line += String.format("%f/%f;", las.keyPositions[i].dir, las.keyPositions[i].time);
    }
    line += "\n";
    saveMapAdd(name, line);
  }
}
public void saveMapClear(String name) {
  try {
    FileWriter writer = new FileWriter(name, false);
    writer.close();
  }  
  catch (IOException e) {
    e.printStackTrace();
  }
}
public void saveMapAdd(String name, String content) {
  try {
    FileWriter writer = new FileWriter(name, true);
    writer.write(content);
    writer.close();
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
}
public void loadMap(String name) {
  solidRects.clear();
  lasers.clear();
  prefabs.clear();
  try {
    FileReader reader = new FileReader(name);
    BufferedReader bufferedReader = new BufferedReader(reader);

    String type;
    float v[];

    String line;
    while ((line = bufferedReader.readLine()) != null) {
      String[] aspects = line.split(":");
      
      //If line is valid
      if (aspects.length>1) {
        type = aspects[0];
        String valuesString[] = aspects[1].split(",");
        v = new float[valuesString.length];
        
        for (int i = 0; i<valuesString.length; i++) {
                   //System.out.println(valuesString[i]);
          if (isNumber(valuesString[i]))
            v[i] = Float.parseFloat(valuesString[i]);
            
          if (valuesString[i].contains("keyPos")) {
            String[] keyPosString = (valuesString[i].split("="))[1].split(";");
            keyPositions = new KeyPos[keyPosString.length];
            for (int j = 0; j<keyPosString.length; j++) {
              String[] temp = keyPosString[j].split("/");
              keyPositions[j] = new KeyPos(Float.parseFloat(temp[0]), Float.parseFloat(temp[1]));
            }
          }
          
        }
        
        loadObject(type,v);
        
      }
      currentMap = mapNum;
    }
    System.out.println("Loaded "+name);
    reader.close();
  }
  catch (IOException e) {
    System.out.println("File not Found!");
    e.printStackTrace();
  }
}

public boolean isNumber(String s) {
  if (s == null) {
    return false;
  }
  try {
    double d = Double.parseDouble(s);
  } 
  catch (NumberFormatException nfe) {
    return false;
  }
  return true;
}
public boolean isBoolean(String s) {
  if (s.equals("true")||s.equals("false")) return true;
  return false;
}  
public Savable objectFromString() {
  Savable res = new KeyPos(0, 0);
  return res;
}
public void loadObject(String type, float[] v) {
  if (type.equals("rect")) {
          solidRects.add(new SolidRect(v[0], v[1], v[2], v[3], v[4]==1?true:false));
        }
        if (type.equals("player")) {
          runner.x = v[0];
          runner.y = v[1];
        }
        if (type.equals("cam")) {
          cam.pos.x = v[0];
          cam.pos.y = v[1];
        }
        if (type.equals("laser")) {
          lasers.add(new Laser(v[0], v[1], v[2], v[3], v[4], v[5], keyPositions));
        }
}
public void settings() {
  size(1000, 600);
}

class TestClass {
  public float firstValue = 3.1416f;
  public int secondValue = 42;
  public String thirdValue = "Hello world";
}

float hey = 5;

public void setup() {
  
  //setFloatField("hey",11);
  //System.out.println(hey);
  //TestClass test = new TestClass();
  //try {
  //  System.out.println(getValueOf(runner,"x"));
  //  System.out.println(getValueOf(test, "firstValue"));
  //  System.out.println(getValueOf(test, "secondValue"));
  //  System.out.println(getValueOf(test, "thirdValue"));
  //} 
  //catch(Exception e) {
  //}
  textBoxes.add(new TextBox(100, 100, 100, 30));
  textBoxes.add(new TextBox(300, 100, 100, 30));

  //load map
  loadMap("map00.txt");

  //load images
  for (int i = 0; i<8; i++) {
    runImage[i] = loadImage("run0" + i + ".png");
  }
  standImage[0] = loadImage("stand00.png");
  forestBG = loadImage("forest_night.jpg");
  mountainsBG = loadImage("mountains.jpg");
  grassImage = loadImage("grass.png");
  tableIMG = loadImage("table.png");
  tableIMG.resize(100,50);

  ////border of level
  //solidRects.add(new SolidRect(-10000, -1500, 20000, 1000));     //top 
  //solidRects.add(new SolidRect(-10000, 1700, 20000, 1000));      //bottom 
  //solidRects.add(new SolidRect(10000, -1500, 1000, 21000));      //left 
  //solidRects.add(new SolidRect(-11000, -1500, 1000, 21000));     //right 

  //create buttons and sliders
  menuButtons[0] = new Button("PLAY", width/2-80, 190, 160, 50, color(255), 30);
  menuButtons[1] = new Button("EDITOR", width/2-80, 260, 160, 50, color(255), 30);
  editorButtons[0] = new Button("Player", 10, 40, 80, 30, color(255), 10);
  editorButtons[1] = new Button("Rectangle", 10, 70, 80, 30, color(255), 10);
  editorButtons[2] = new Button("Laser:DOWN", 10, 100, 80, 30, color(255), 10);
  editorButtons[3] = new Button("Table", 10, 130, 80, 30, color(255), 10);
  saveButton = new Button("Save", width-125, 20, 50, 20, color(255), 8);
  loadButton = new Button("Load", width-75, 20, 50, 20, color(255), 8);
  for (int i = 0; i<2; i++) {
    for (int j = 0; j<5; j++) {
      mapButtons[i*5+j] = new Button(""+(i*5+j), width-100+30*i, 60+30*j, 20, 20, WHITE, 8);
    }
  }
}

//Level setup
//Camera
Camera cam = new Camera();
//Buttons, Sliders
Button[] menuButtons = new Button[2];
Button[] editorButtons = new Button[4];
Button saveButton;
Button loadButton;
Button[] mapButtons = new Button[10];
ArrayList<Slider> editorSliders = new ArrayList<Slider>();

//Player character
Runner runner = new Runner(50, 99);
//Landscape
//SOLID RECTS
//Positions of rects is specified in setup method
ArrayList<SolidRect> solidRects = new ArrayList<SolidRect>();
//LASERS
ArrayList<Laser> lasers = new ArrayList<Laser>();
//PREFABS
ArrayList<Prefab> prefabs = new ArrayList<Prefab>();


//Editor necessities
CreateRect createRect = new CreateRect(0, 0, 9999, 9999);
ArrayList<TextBox> textBoxes = new ArrayList<TextBox>();
TextBox activeTextBox;
int laserDirection = 90;
Configurable selection = null;

//Settings
float plySpeed = 8;
int groundColor = color(100, 100, 100);
float gravity = 0.8f;
GM state = GM.MENU;

//necessary variables
int tool = 0;
int mapNum = 0;
int currentMap = 0;

//COLORS
final int WHITE = color(255);
final int GREY = color(100);

enum GM { 
  MENU, PLAY, EDITOR, GAME_OVER, PAUSE
};
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
  public boolean isColliding(float x,float y) {
    return insideBox(pos.x-6-15, pos.y-6+sliderY, l+12+30, 12, mouseX, mouseY);
  }
  public void update() {
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
  public void setValue() {
  }
  public void update() {
    if (activeTextBox==this) fill(255);
    else fill(200);
    rect(x,y,w,h);
    fill(0);
    textAlign(CENTER,CENTER);
    textSize(h/2);
    text(value,x+w/2,y+h/2);
  }
}
/*
Story mode
Prefabs
Decorations
Block alternative designs

Dialouge box
Enemies
Aim and Shoot
Moving platforms
*/
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "RunningMan" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
