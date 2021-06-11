import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class aufzug_kombo_2 extends PApplet {

int stockwerke = 10;
float houseWidth = 200;
float houseHeight = 500;
float aufzugPos = 0;
float bottomHeight = 100;

float yAufzugHendrik;

Person person = new Person(400, 100+houseHeight/stockwerke*0.4f, houseHeight/stockwerke*0.6f);
Aufzug aufzugBen = new Aufzug(300, 100, 500);

//Hendrik
int floors = 10; //anzahl stockwerke, EG = 0, 1. Stock = 1, etc
boolean keyUp = false;
boolean keyDown = false;
int waitTime = 100;
int liftHeight = 50;
Lift aufzug = new Lift();

public void setup() {
  
  frameRate(100);
}

public void draw() {
  background(0, 0, 40);

  aufzug.update();

  fill(50);
  stroke(0);
  strokeWeight(3);
  rect(0, height, 1000, -bottomHeight); //boden
  drawHouse(300, 100);
  aufzugBen.draw(yAufzugHendrik);

  //draw Person
  person.draw();

  //draw Mond
  fill(255);
  noStroke();
  circle(width-150, 100, 150);

  fill(255);
  for (int i = 0; floors > i; i++) {
    text(i + ": " + aufzug.aufrufe[i], 10, (10*i));
    println(i + ": " + aufzug.aufrufe[i]);
  }
}
class Aufzug {
  float x;
  float y;
  float schachtHeight;
  float yCurrent;
  float h;
  Aufzug(float x, float y, float schachtHeight) {
    this.x = x;
    this.y = y;
    this.schachtHeight = schachtHeight;
    this.yCurrent = schachtHeight;
    this.h = schachtHeight/stockwerke;
  }
  public void draw(float yCurrent) {
    fill(30);
    strokeWeight(3);
    rect(x, y, 50, schachtHeight);
    fill(60);
    line(x+20, y, x+20, y+yCurrent);
    line(x+30, y, x+30, y+yCurrent);
    rect(x, y+yCurrent, 50, h);
  }
}
class Lift {
  boolean goingUp;                  //true = up, false = down
  boolean isMoving = false;
  boolean goUp;
  boolean goDown;

  int floor = 0;                       //derzeitige position
  int nextFloor;
  float moveProgress;              //fortschritt der Bewegung in %

  int wait;                        //Wartezeit in frames

  boolean[] aufrufe = new boolean[floors]; 

  float vy;            //y-speed
  float d;             //diameter



  public void update() {
    if (isMoving) {
      moveProgress++;
      if (moveProgress >= 100) {
        floor = nextFloor;
        moveProgress = 0;
        isMoving = false;


        if (aufrufe[floor]) {
          wait = waitTime;
          aufrufe[floor] = false;
        }
      }
    } else if (wait <= 0) {
      getNextDestination();
      wait = 0;
    } else { 
      wait--;
    }

    yAufzugHendrik = (height-bottomHeight)-(((floor+2)*aufzugBen.h)+(aufzugBen.h+visualMove()));
  }

  public float visualMove() {
    float move = moveProgress/2;
    if (!goingUp) { 
      move *= -1;
    }    
    return move;
  }

  public void getNextDestination() {
    if (goingUp) {
      for (int i = floor+1; i<floors; i++) {
        if (aufrufe[i]) {
          nextFloor = floor + 1;
          isMoving = true;
          break;
        }
      }
    } else {
      for (int i = floor-1; i>=0; i--) {
        if (aufrufe[i]) {
          nextFloor = floor - 1;
          isMoving = true;
          break;
        }
      }
    }
    if (nextFloor == floor) {
      goingUp = !goingUp;
    }
  }
}
class Person {
  float x, y, h;
  Person(float x, float y, float h) {
    this.x = x;
    this.y = y;
    this.h = h;
  }
  public void draw() {
    float w = h/3;

    //body
    strokeWeight(3);
    line(x+w/2, y+w/4, x+w/2, y+h/2);

    //feet
    strokeWeight(3);
    line(x+w/2, y+h/2, x, y+h);
    line(x+w/2, y+h/2, x+w, y+h);

    //arms
    strokeWeight(3);
    line(x+w/2, y+h/8, x, y+h/2.5f);
    line(x+w/2, y+h/8, x+w, y+h/2.5f);

    //head
    strokeWeight(1);
    circle(x+w/2, y, w/1.5f);
  }
}
public void drawHouse(float x, float y) {
  fill(100);
  strokeWeight(3);
  rect(x, y, 200, 500);
  for (int i = 1; i<stockwerke; i++) {
    line(x, y+houseHeight/stockwerke*i, x+houseWidth, y+houseHeight/stockwerke*i);
  }
}
public void keyPressed() {
  aufzug.aufrufe[PApplet.parseInt(str(key))] = true;
}

  public void settings() {  size(1000, 700); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "aufzug_kombo_2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
