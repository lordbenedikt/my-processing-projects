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
PImage rocket;


public void setup() {
  size(800, 600);
  background(255);
  minim = new Minim(this);
  
  //load images
  jens = loadImage("data/images/smiley.png", "png");
  space = loadImage("data/images/space.jpg", "jpg");
  asteroid = loadImage("data/images/asteroid2.png", "png");
  explosionpng = loadImage("data/images/explosion.png", "png");
  rocket = loadImage("data/images/rockets.png", "png");
  
  //load sounds
  explosion = minim.loadFile("data/sounds/explosion.mp3");
  gameover = minim.loadFile("data/sounds/gameover.mp3");
  restart = minim.loadFile("data/sounds/restart.mp3");
  backgroundmusic = minim.loadFile("data/sounds/backgroundmusic.mp3");
}

Random r = new Random();
float jens_x = 400;
float jens_y = 300;
float startButton_x = 400;
float startButton_y = 300;
float score_x = 620;
int hp = 100; //health points
int count = 4; //timer for the asteroids
int score = 0;

boolean keyA = false;
boolean keyS = false;
boolean keyW = false;
boolean keyD = false;
boolean hasRun = false;
boolean hasRunPause = true;


ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
ArrayList<Rocket> rockets = new ArrayList<Rocket>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();

void draw() {

  if ( state == GameModes.MENU) {
    Menu();
  }


  if (state == GameModes.GAME_OVER) {
    gameOver();
    restart();
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
    background(space);
    gameover.pause();
    if (!(backgroundmusic.isPlaying())) {
      backgroundmusic.play(0);
    } 
    backgroundmusic.play();

    if (count==0) {
      spawnAsteroid();
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

    drawExplosions();

    if (hp <= 0) state = GameModes.GAME_OVER;

    //Health points
    fill(255);
    if (hp < 40) fill(255, 0, 0);
    if (hp < 20) fill (random(255), random(255), random(255)) ;
    textSize(30);
    text("HP: " + hp, 670, 30);
    //textSize(23);
    //text ("Asteroids: " + asteroids.size(), 610, 60);
    text("Score: " + score*10, score_x, 60);
    if (score*10 >999) score_x = 615-6;
    if (score*10 >9999) score_x = 610-6;
    if (score*10 >99999) score_x = 605-6;
    if (score*10 >999999) score_x = 605-14;
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
    hp = 100;
    score = 0;
    restart.play(0);
    state = GameModes.PLAY;
  }
  if (key == 'p' & state != GameModes.MENU & state != GameModes.GAME_OVER ) pause();
}

//Game Modes as functions

void gameOver() {
  //int player = 1;
  //if (player == 1) gameover.play(0);
  backgroundmusic.pause();
  background(0);
  textSize(100);
  fill(random(255), random(255), random(255));
  text("GAME OVER", 120, 250);
  fill(255);
  textSize(40);
  text("YOUR SCORE WAS: ", 240, 360);
  text(score*10, 375, 415);
  if (!(gameover.isPlaying())) {
    gameover.play(0);
  } 
  gameover.play();
}

void restart() {
  jens_x = 400;
  jens_y = 300;
  asteroids.removeAll(asteroids);
  explosions.removeAll(explosions);
  hp = 100;
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
