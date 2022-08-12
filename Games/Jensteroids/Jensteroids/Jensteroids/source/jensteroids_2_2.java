import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Random; 
import java.math.*; 
import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class jensteroids_2_2 extends PApplet {





enum GameModes { 
  MENU, PLAY, GAME_OVER, PAUSE
};
GameModes state = GameModes.MENU;

//audios
Minim minim;
AudioPlayer explosion;
AudioPlayer gameover;
AudioPlayer restart;
AudioPlayer backgroundmusic;

//images
PImage jens; 
PImage space;
PImage asteroid;
PImage explosionpng;
PImage rocketIMG;
PImage UFOIMG;
PImage menu_background;
PImage stats_bar;

PGraphics pC;

public void setup() {
  
  viewWidth = width - 200;
  viewHeight = height;  
  pC = createGraphics(width, height);
  minim = new Minim(this);

  //load images
  jens = loadImage("data/images/smiley.png", "png");
  jens.resize(60, 60);
  space = loadImage("data/images/space.jpg", "jpg");
  asteroid = loadImage("data/images/asteroid2_small.png", "png");
  explosionpng = loadImage("data/images/explosion.png", "png");
  rocketIMG = loadImage("data/images/rocket_small.png", "png");
  UFOIMG = loadImage("data/images/UFO_small.png", "png");
  menu_background = loadImage("data/images/menu_background.jpg", "jpg");
  stats_bar = loadImage("data/images/stats_bar.jpg", "jpg");

  //load sounds
  explosion = minim.loadFile("data/sounds/explosion.mp3");
  gameover = minim.loadFile("data/sounds/gameover.mp3");
  restart = minim.loadFile("data/sounds/restart.mp3");
  backgroundmusic = minim.loadFile("data/sounds/backgroundmusic.mp3");
  
  for (int i = 0 ; i<stars.length ; i++){
    stars[i] = new Star();
  }
}

int viewWidth;
int viewHeight;

Random r = new Random();
float jens_x = 400;
float jens_y = 300;
float startButton_x = 400;
float startButton_y = 300;
float score_x = 620;
float randomizer = 0;

int hp = 100; //health points
int count = 4; //timer for the asteroids
int score = 0;
int scoreByTime = 0;
int liveTime = 100;
int level = 1;

boolean keyA = false;
boolean keyS = false;
boolean keyW = false;
boolean keyD = false;
boolean hasRun = false;
boolean hasRunPause = true;


ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
ArrayList<Rocket> rockets = new ArrayList<Rocket>();
ArrayList<UFO> UFOs = new ArrayList<UFO>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();

public void draw() {
  level = liveTime/20 + 1;
  if (state != GameModes.GAME_OVER) {
    if (scoreByTime==30) {
      scoreByTime = 0;
      score++;
      liveTime++;
    }
    scoreByTime++;
  }

  if ( state == GameModes.MENU) {
    Menu();
  }


  if (state == GameModes.GAME_OVER) {
    gameOver();
  }

  if (state == GameModes.PAUSE) {
    fill(255);
    textSize(80);
    text("GAME PAUSED", 145, 300);
  }

  if (state == GameModes.PLAY) {
    //score++;
    cursor(ARROW);
    hasRun = false;
    
    // background
    //image(space, 400, 300);
    drawStars();
    
    gameover.pause();
    if (!(backgroundmusic.isPlaying())) {
      backgroundmusic.play(0);
    } 
    backgroundmusic.play();

    if (count==0) {
      //spawnAsteroid();
      count = 4;
    } else count--;
    //println(millis() % 500);
    //if (millis() % 1000 < 400) spawnAsteroid();

    moveJens();
    checkEdgesJens();
    drawJens();

    removeAsteroids();
    drawAsteroids();
    moveAsteroids();

    removeCrashedAsteroids();

    drawRockets();
    moveRockets();

    drawUFOs();
    moveUFOs();

    spawnStuff();

    drawExplosions();

    if (hp <= 0) state = GameModes.GAME_OVER;


    //stats_bar
    image(stats_bar, 900, 300);
    //Health points
    fill(255);
    if (hp < 40) fill(255, 0, 0);
    if (hp < 20) fill (random(255), random(255), random(255)) ;

    textSize(30);
    textAlign(CENTER, CENTER);

    text(liveTime, viewWidth+100, 340);
    text(score, viewWidth+100, 220);
    text(hp, viewWidth+100, 100);
  }
}

public void spawnStuff() {
  if (level==0) level = 1;

  if (level>=1) {
    if (frameCount % (30) == 0) {  
      spawnAsteroid();
    }
  }
  if (level>=2) {
    //if ((frameCount% 1==0)) {
    if ((frameCount% (int)(100 - 90*pow(0.3f, 2f/(level-1))))==0) {
      spawnRocket();
    }
  }
  if (level>=10) {
    if ((frameCount% (int)(200 - 180*pow(0.05f, 1f/(level-9))))==0) {
      spawnUFO();
    }
  }

}

public void keyReleased() {
  if (key=='w') keyW = false;
  if (key=='a') keyA = false;
  if (key=='s') keyS = false;
  if (key=='d') keyD = false;
  //if (key == 'p' & state == GameModes.PAUSE) state = GameModes.PLAY;
}

public void keyPressed() {
  if (key=='w') keyW = true;
  if (key=='a') keyA = true;
  if (key=='s') keyS = true;
  if (key=='d') keyD = true;
  if (key=='r' & state == GameModes.GAME_OVER) {
    restart();
  }
  if (key == 'p' & state != GameModes.MENU & state != GameModes.GAME_OVER ) pause();
  if (key == 'q') hp = 1000;
}

//Game Modes as functions

public void gameOver() {
  //int player = 1;
  //if (player == 1) gameover.play(0);
  backgroundmusic.pause();
  background(0);

  textAlign(CENTER, CENTER);
  textSize(100);

  fill(random(255), random(255), random(255));
  text("GAME OVER", width/2, 250);
  fill(255);
  textSize(40);
  text("YOUR SCORE WAS: ", width/2, 360);
  text(score, width/2, 415);
  if (!(gameover.isPlaying())) {
    gameover.play(0);
  } 
  gameover.play();
}

public void restart() {
  rockets.clear();
  UFOs.clear();
  asteroids.clear();
  explosions.clear();

  hp = 100;
  score = 0;
  liveTime = 0;
  restart.play(0);
  state = GameModes.PLAY;
  jens_x = 400;
  jens_y = 300;
  if (hasRun == false) {
    backgroundmusic.rewind();
    hasRun = true;
  }
}

public void pause() {
  if (hasRunPause) {
    state = GameModes.PAUSE;
  } else { 
    state = GameModes.PLAY;
  }
  hasRunPause = !hasRunPause;
}

public float[] posOutsideRoom() {
  float[] pos = {0, 0};
  int side = r.nextInt(2);

  if (side==0) {
    if (r.nextInt(2)==0) {
      pos[0] = -100;
    } else {
      pos[0] = width+100;
    }
    pos[1] = random(0, height);
  } else {
    if (r.nextInt(2)==0) {
      pos[1] = -100;
    } else {
      pos[1] = height+100;
    }
    pos[0] = random(0, width);
  }

  return pos;
}
public float[] posTopOrBottom() {
  float[] pos = {0, 0};

  pos[0] = random(100, viewWidth-100);
  if (r.nextInt(2)==0) {
    pos[1] = -100;
  } else {
    pos[1] = viewHeight+100;
  }

  return pos;
}
public float[] posLeftOrRight() {
  float[] pos = {0, 0};

  pos[1] = random(0, viewHeight);
  if (r.nextInt(2)==0) {
    pos[0] = -100;
  } else {
    pos[0] = viewWidth+100;
  }

  return pos;
}

public boolean insideBox(float x, float y, float xMin, float yMin, float xMax, float yMax) {
  if (x < xMin || x > xMax || y < yMin || y > yMax)
    return false;
  return true;
}
class Asteroid {
  float x;
  float y;
  float r;
  float xSpeed;
  float ySpeed;
  Asteroid(float x, float y, float r, float xSpeed, float ySpeed) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.xSpeed = xSpeed;
    this.ySpeed = ySpeed;
  }
}

public void spawnAsteroid() {
  float[] pos = posOutsideRoom();
  randomizer = pow(random(0, 1), 2);
  PVector speed = new PVector(random(0, viewWidth)-pos[0], random(0, viewHeight)-pos[1]).setMag(1+3*randomizer);
  randomizer = pow(random(0, 1), 7);
  float radius = 20 + random(0, level*10)*randomizer;
  asteroids.add(new Asteroid( pos[0], pos[1], radius, speed.x, speed.y));
}
public void drawAsteroids() {
  for (Asteroid a : asteroids) {
    imageMode(CENTER);
    image(asteroid, a.x, a.y, a.r*2, a.r*2);
  }
}
public void moveAsteroids() {
  for (Asteroid a : asteroids) {
    a.x += a.xSpeed; 
    a.y += a.ySpeed;
  }
}

public void removeCrashedAsteroids() {
  int i = 0;
  while (i < asteroids.size()) {
    Asteroid a = asteroids.get(i);
    if (collisionDetector( a, jens_x, jens_y )) {
      hp -= (int)pow(asteroids.get(i).r/7,2);
      //explosion.rewind();
      explosion.play(0);
      asteroids.remove(a);
      score++;
      spawnExplosion( a.x, a.y, a.r);
      continue;
    }
    i++;
  }
}

public void removeAsteroids() {
  int i = 0;
  while (i < asteroids.size()) {
    Asteroid a = asteroids.get(i);
    if (a.x < -150  || a.x > viewWidth+150 || a.y < -150 || a.y > viewHeight+150) {
      asteroids.remove(i);
      score++;
      continue;
    }
    i++;
  }
}


public float getDistance(float x1, float y1, float x2, float y2 ) {
  return (float) Math.sqrt( (Math.pow( x1-x2, 2)) + (Math.pow( y1-y2, 2)) );
}

public boolean collisionDetector(Asteroid a, float jens_x, float jens_y) {
  float distance = getDistance(jens_x, jens_y, a.x, a.y);
  if (distance < 40 + a.r)
    return true;
  else 
  return false;
}
class Explosion {
  float x;
  float y;
  float r;

  Explosion(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
  }
}

public void spawnExplosion(float x, float y, float r) {
  explosions.add(new Explosion( x, y, r));
}

public void drawExplosions() {
  int i = 0;
  while ( i < explosions.size()) {
    Explosion expl = explosions.get(i);
    imageMode(CENTER);
    image(explosionpng, expl.x, expl.y, expl.r*2*2, expl.r*2*2);
    if (expl.r < 0) {
      explosions.remove(expl);
      continue;
    }
    expl.r = expl.r*0.9f - 0.2f;
    i++;
  }
}
public void jens(float x, float y) {
  fill(242, 216, 159);                     
  ellipse(x, y, 80, 80);
  fill(255);
  ellipse(x+15, y, 15, 15);
  ellipse(x-15, y, 15, 15);
  fill(0);
  ellipse(x+15, y+3, 5, 5);
  ellipse(x-15, y+3, 5, 5);
  noFill();
  line(x-10, y+15, x+10, y+15);

  //line(x,y+50,x,y+250);
} 

public void drawJens() {
  drawJens(g);
}
public void drawJens(PGraphics pG) {
  pG.imageMode(CENTER);
  pG.image(jens,jens_x,jens_y);
}

public void moveJens() {
  if (keyS) jens_y += 8;
  if (keyW) jens_y -= 8;
  if (keyA) jens_x -= 8;
  if (keyD) jens_x += 8;
}

public void checkEdgesJens() {
  if (jens_x < 40) jens_x = 40;
  if (jens_x > 760) jens_x = 760;
  if (jens_y < 40 ) jens_y = 40;
  if (jens_y > 560) jens_y = 560;
}
public void Menu() {
  image(menu_background, 0, 0);
  fill(255);

  textAlign(CENTER, CENTER);
  textSize(100);

  text("JENSTEROIDS!", width/2, 150);
  rectMode(CENTER);
  fill(255, 0, 0);
  rect(width/2, startButton_y, 100, 50 );
  fill(255);
  textSize(25);
  text("START", width/2, startButton_y);
  textSize(15);
  text("Ben&Jens Corporation BETA version 2.1", 695, height-20 );

  boolean onButton = insideBox(mouseX, mouseY, width/2-50, startButton_y-25, width/2+50, startButton_y+25);
  if (mousePressed && onButton) state = GameModes.PLAY; 
  if (!onButton) cursor(ARROW);
  if (onButton) {
    cursor(HAND);
    rectMode(CENTER);
    fill(255);
    rect(width/2, startButton_y, 100, 50);
    fill(255, 0, 0);
    textSize(25);
    text("START", width/2, startButton_y);
  }
}
//boolean isCollidingPixels(Rocket r) {
//  int rX = (int) ((r.pos.x-rocketIMG.width/2) - (jens_x-jens.width/2));
//  int rY = (int) ((r.pos.y-rocketIMG.height/2) - (jens_y-jens.height/2));

//  if (rX>jens.width || rX+rocketIMG.width<0 || rY>jens.height || rY+rocketIMG.height<0) {
//    return false;
//  }

//  int rLeft = 0;
//  int rRight = rocketIMG.width;
//  int rTop = 0;
//  int rBottom = rocketIMG.height;

//  int jLeft = rX;
//  int jRight = rX+rocketIMG.width;
//  int jTop = rY;
//  int jBottom = rY+rocketIMG.height;

//  if (rX<0) {
//    rLeft = -rX;
//    jLeft = 0;
//  }
//  if (rX+rocketIMG.width>jens.width) {
//    rRight = jens.width-rX;
//    jRight = jens.width;
//  }
//  if (rY<0) {
//    rTop = -rY;
//    jTop = 0;
//  }
//  if (rY+rocketIMG.height>jens.height) {
//    rBottom = jens.height-rY;
//    jBottom = jens.height;
//  }

//  int numOfPixels = (jRight-jLeft)*(jBottom-jTop);
//  color[] jensPixels = new color[numOfPixels];
//  color[] rocketPixels = new color[numOfPixels];
//  color[] collidingPixels = new color[numOfPixels];

//  int snippetWidth = jRight-jLeft;
//  int snippetHeight = jBottom-jTop;


//  color[] rocketPixelsMirrored = new int[rocketIMG.pixels.length];
//  for (int i = 0; i<rocketIMG.pixels.length; i++) {
//    if (r.speed.x>0) {
//      rocketPixelsMirrored[i] = rocketIMG.pixels[i];
//    } else {
//      rocketPixelsMirrored[i] = rocketIMG.pixels[rocketIMG.pixels.length-1-i];
//    }
//  }

//  for (int i = 0; i<numOfPixels; i++) {
//    jensPixels[i] = jens.pixels[jens.width*(jTop+i/snippetWidth)+(jLeft+i%snippetWidth)];
//    rocketPixels[i] = rocketPixelsMirrored[rocketIMG.width*(rTop+i/snippetWidth)+rLeft+i%snippetWidth];
//    if ((alpha(jensPixels[i])>0 && alpha(rocketPixels[i])>0)) {
//       collidingPixels[i] = 1;
//       //return true;
//    } 
//  }

//  //draw snippet box
//  strokeWeight(3);
//  noFill();
//  rectMode(CORNER);
//  rect(jens_x-jens.width/2+jLeft, jens_y-jens.height/2+jTop, jRight-jLeft, jBottom-jTop);

//  for (int i = 0; i<collidingPixels.length; i++) {
//    if (collidingPixels[i]==1) {
//      fill(1);
//      text("COLLISION DETECTED!!!", 200, 200);
//      break;
//    }
//  }

//  //draw colliding pixels
//  for (int i = 0; i<collidingPixels.length; i++) {
//    if (collidingPixels[i]==1) {
//      rectMode(CORNER);
//      noStroke();
//      fill(1);
//      rect(r.pos.x-rocketIMG.width/2+rLeft+(i%snippetWidth), r.pos.y-rocketIMG.height/2+rTop+(i/snippetWidth), 1, 1);
//    }
//  }

//  return false;
//}
class Rocket {
  PVector pos;
  PVector speed;
  Rocket(float x, float y, float xSpeed, float ySpeed) {
    pos = new PVector(x, y);
    speed = new PVector(xSpeed, ySpeed);
  }
  public void update() {
    if (pos.x < -500 || pos.x > viewWidth+500 || pos.y < -500 || pos.y > viewHeight+500)
      rockets.remove(this);
    pos.add(speed);
    if (collWithPlayer()) {
      hp -= 20;
      spawnExplosion(pos.x, pos.y, 50);
      rockets.remove(this);
    }
  }
  public void draw() {
    draw(g);
  }
  public void draw(PGraphics pG) {
    pG.pushMatrix();
    pG.translate(pos.x, pos.y);
    pG.rotate(speed.x<0 ? PI : 0);
    pG.imageMode(CENTER);
    pG.image(rocketIMG, 0, 0);
    pG.popMatrix();
  }
  public boolean collWithPlayer() {
    if (dist(pos.x,pos.y,jens_x,jens_y) > rocketIMG.width/2 + jens.width/2)
      return false;
    pC.beginDraw();
    pC.clear();
    pC.tint(0, 255, 0, 200);
    drawJens(pC);
    pC.tint(255, 0, 0, 200);
    draw(pC);
    pC.endDraw();

    int xMin = (int)(pos.x-rocketIMG.width/2);
    int xMax = (int)(pos.x+rocketIMG.width/2);
    int yMin = (int)(pos.y-rocketIMG.height/2);
    int yMax = (int)(pos.y+rocketIMG.height/2);
    for (int y = yMin; y<yMax; y++) {
      if (y<0 || y>=viewHeight) continue;
      for (int x = xMin; x<xMax; x++) {
        if (x<0 || x>=viewWidth) continue;
        int c = pC.pixels[y*width+x];
        if ((red(c)>0)&&(green(c)>0))
          return true;
      }
    }
    pC.updatePixels();  

    return false;
  }
}

public void spawnRocket() {
    float[] pos = posLeftOrRight();
    rockets.add(new Rocket(pos[0], pos[1], pos[0]<0?10:-10, 0));
}
public void drawRockets() {
  for (Rocket r : rockets) {
    r.draw();
  }
}

public void moveRockets() {
  int i = 0;
  while (i<rockets.size()) {
    int prevSize = rockets.size();
    rockets.get(i).update();
    if (rockets.size()==prevSize) {
      i++;
    }
  }
}
Star[] stars = new Star[700];
float starSpeed = 20;

public void drawStars(){
  //starSpeed = map(mouseX , 0 , width , 0 , 40);
  background(0);
  pushMatrix();
  translate(viewWidth/2 , height/2, -10);
  for (int i = 0 ; i < stars.length ; i++){
    stars[i].update();
    stars[i].show();
  }
  popMatrix();
}

class Star {
  float x;
  float y;
  float z;
  float pz;
  Star() {
    x = random(-width, width);
    y = random(-height, height);
    z = random(width);
    pz = z;
  }
  public void update() {
    z -= starSpeed;
    if (z<1) {
      z = width;
      x = random(-width, width);
      y = random(-height, height);
      pz = z;
    }
  }
  
  public void show() {
    fill(255);
    noStroke();
    float sx = map(x/z, 0, 1, 0, width);
    float sy = map(y/z, 0, 1, 0, height);
    float r = map(z, 0, width, 16, 0);
    //ellipse(sx, sy, r, r);
    float px = map(x/pz, 0, 1, 0, width);
    float py = map(y/pz, 0, 1, 0, height);
    pz=z;
    stroke(255);
    line(px, py, sx, sy);
  }
}
class UFO {
  PVector pos;
  PVector revolveCenter;
  PVector speed;
  float startingAngle;

  UFO(float x, float y, float xSpeed, float ySpeed) {
    revolveCenter = new PVector(x, y);
    pos = new PVector(x, y);
    speed = new PVector(xSpeed, ySpeed);
    startingAngle = random(TWO_PI);
  }
  public void update() {
    if (pos.x < -500 || pos.x > viewWidth+500 || pos.y < -500 || pos.y > viewHeight+500)
      rockets.remove(this);
    revolveCenter.add(speed);
    pos = revolveCenter.copy();
    pos.x += 200*sin(startingAngle+frameCount/30f);
    if (collWithPlayer()) {
      hp -= 20;
      spawnExplosion(pos.x, pos.y, 50);
      UFOs.remove(this);
    }
  }
  public void draw() {
    draw(g);
  }
  public void draw(PGraphics pG) {
    pG.pushMatrix();
    pG.translate(pos.x, pos.y);
    pG.imageMode(CENTER);
    pG.image(UFOIMG, 0, 0);
    pG.popMatrix();
  }
  public boolean collWithPlayer() {
    if (dist(pos.x, pos.y, jens_x, jens_y) > UFOIMG.width/2 + jens.width/2)
      return false;
    pC.beginDraw();
    pC.clear();
    pC.tint(0, 255, 0, 200);
    drawJens(pC);
    pC.tint(255, 0, 0, 200);
    draw(pC);
    pC.endDraw();

    int xMin = (int)(pos.x-UFOIMG.width/2);
    int xMax = (int)(pos.x+UFOIMG.width/2);
    int yMin = (int)(pos.y-UFOIMG.height/2);
    int yMax = (int)(pos.y+UFOIMG.height/2);
    for (int y = yMin; y<yMax; y++) {
      if (y<0 || y>=viewHeight) continue;
      for (int x = xMin; x<xMax; x++) {
        if (x<0 || x>=viewWidth) continue;
        int c = pC.pixels[y*width+x];
        if ((red(c)>0)&&(green(c)>0))
          return true;
      }
    }
    pC.updatePixels();  

    return false;
  }
}

public void spawnUFO() {
  float[] pos = posTopOrBottom();
  UFOs.add(new UFO(pos[0], pos[1], 0, pos[1]<0?3:-3));
}
public void drawUFOs() {
  for (UFO u : UFOs) {
    u.draw();
  }
}

public void moveUFOs() {
  int i = 0;
  while (i<UFOs.size()) {
    int prevSize = UFOs.size();
    UFOs.get(i).update();
    if (UFOs.size()==prevSize) {
      i++;
    }
  }
}
  public void settings() {  size(1000, 600, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#030202", "--hide-stop", "jensteroids_2_2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
