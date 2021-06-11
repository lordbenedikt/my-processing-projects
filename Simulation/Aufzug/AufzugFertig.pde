int stockwerke = 10;
float houseWidth = 200;
float houseHeight = 500;
float aufzugPos = 0;
float bottomHeight = 100;

float yAufzugHendrik;

Person person = new Person(400, 100+houseHeight/stockwerke*0.4, houseHeight/stockwerke*0.6);
Aufzug aufzugBen = new Aufzug(300, 100, 500);

//Hendrik
int floors = 10; //anzahl stockwerke, EG = 0, 1. Stock = 1, etc
boolean keyUp = false;
boolean keyDown = false;
int waitTime = 100;
int liftHeight = 50;
Lift aufzug = new Lift();

void setup() {
  size(1000, 700);
  frameRate(100);
}

void draw() {
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
