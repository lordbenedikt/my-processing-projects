import java.util.Random;
import java.math.*;
import ddf.minim.* ;

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

void setup() {
  size(1000, 600, P3D);
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

void draw() {
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

void spawnStuff() {
  if (level==0) level = 1;

  if (level>=1) {
    if (frameCount % (30) == 0) {  
      spawnAsteroid();
    }
  }
  if (level>=2) {
    //if ((frameCount% 1==0)) {
    if ((frameCount% (int)(100 - 90*pow(0.3, 2f/(level-1))))==0) {
      spawnRocket();
    }
  }
  if (level>=10) {
    if ((frameCount% (int)(200 - 180*pow(0.05, 1f/(level-9))))==0) {
      spawnUFO();
    }
  }

}

void keyReleased() {
  if (key=='w') keyW = false;
  if (key=='a') keyA = false;
  if (key=='s') keyS = false;
  if (key=='d') keyD = false;
  //if (key == 'p' & state == GameModes.PAUSE) state = GameModes.PLAY;
}

void keyPressed() {
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

void gameOver() {
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

void restart() {
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

void pause() {
  if (hasRunPause) {
    state = GameModes.PAUSE;
  } else { 
    state = GameModes.PLAY;
  }
  hasRunPause = !hasRunPause;
}

float[] posOutsideRoom() {
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
float[] posTopOrBottom() {
  float[] pos = {0, 0};

  pos[0] = random(100, viewWidth-100);
  if (r.nextInt(2)==0) {
    pos[1] = -100;
  } else {
    pos[1] = viewHeight+100;
  }

  return pos;
}
float[] posLeftOrRight() {
  float[] pos = {0, 0};

  pos[1] = random(0, viewHeight);
  if (r.nextInt(2)==0) {
    pos[0] = -100;
  } else {
    pos[0] = viewWidth+100;
  }

  return pos;
}

boolean insideBox(float x, float y, float xMin, float yMin, float xMax, float yMax) {
  if (x < xMin || x > xMax || y < yMin || y > yMax)
    return false;
  return true;
}
