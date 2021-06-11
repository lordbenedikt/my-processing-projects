int insektenAnzahl = 20;
float insektMaxSpeed = 10;

// Dieser Array enthält alle Mueckenobjekte
Insekt insekten[] = new Insekt[insektenAnzahl];

void setup() {
  size(400, 400);
  
  // Erstelle Mücken an zufälligen Positionen
  for (int i = 0; i<insektenAnzahl; i++) {
    insekten[i] = new Insekt(random(width), random(height));
  }
}

void draw() {
  // Hintergrund
  background(160, 160, 250);
  
  // Bewege Muecken und zeichne sie an
  for (int i = 0; i<insekten.length; i++) {
    for(int j = i+1; j<insekten.length; j++) {
      // Die verschachtelte Schleife sorgt dafür, dass jede Muecke sich von jeder anderen abstoßt
      insekten[i].collide(insekten[j]);
    }
    insekten[i].update();
  }
}

class Insekt {
  float x;
  float y;
  float xSpeed;
  float ySpeed;
  float maxSpeed = insektMaxSpeed;
  
  Insekt(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  // bei geringem Abstand beschleunige in entgegengesetzte Richtung
  void collide(Insekt m) {
    if(dist(x,y,m.x,m.y)<10) {
      xSpeed -= (m.x-x)/2/mag(m.x-x,m.y-y)*10;
      ySpeed -= (m.y-y)/2/mag(m.x-x,m.y-y)*10;
      m.xSpeed -= (x-m.x)/2/mag(m.x-x,m.y-y)*10;
      m.ySpeed -= (y-m.y)/2/mag(m.x-x,m.y-y)*10;
    }
  }
  
  void update() {
    // bewege Muecke
    x += xSpeed;
    y += ySpeed;

    // beschleunige in Richtung Mauszeiger
    xSpeed += (mouseX - x) / 100;
    ySpeed += (mouseY - y) / 100;

    // begrenze Geschwindigkeit auf maxSpeed
    xSpeed = constrain(xSpeed, -maxSpeed, maxSpeed);
    ySpeed = constrain(ySpeed, -maxSpeed, maxSpeed);

    // zeichne Muecke
    drawInsekt();
  }
  
  void drawInsekt() {
    fill(0);
    circle(x, y, 5);
  }
}
