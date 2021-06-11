// Anfangsposition
float x = 300;
float y = 100;

// Anfangsgeschwindigkeit
float ySpeed = 0;
float xSpeed = 12;

// Ballradius
float radius = 40;

void setup() {
  size(600, 600);    // Fenstergröße festlegen
  noStroke();        // Keine Outlines
}

void draw() {
  background(100);   // Hintergrund zeichnen

  // Fallbeschleunigung  (Erhöhe Geschwindigkeit nach unten)
  ySpeed += 1;

  // Position je nach Geschwindigkeit verändern, um Bewegung zu simulieren
  x += xSpeed;
  y += ySpeed;
  
  // Geschwindigkeit verringern, um Reibung zu simulieren
  xSpeed *= 0.99;
  ySpeed *= 0.99;

  // Abprallen vom Boden
  if (y>height - radius) { // Wenn in Berührung mit Boden
    y = height - radius;   // Korrigiere Position, falls Ball "im" Boden ist
    if (ySpeed>0)          // Falls Geschwindigkeit noch nicht invertiert
      ySpeed *= -0.8;      // Invertiere horizontale Geschwindigkeit(gleichzeitig wird die Geschwindigkeit reduziert)
  }
  // Abprallen von der rechten Wand
  if (x>width - radius) {  // Wenn in Berührung mit rechter Wand
    x = width-radius;      // Korrigiere Position, falls Ball "in" der Wand ist
    if (xSpeed>0)          // Falls Geschwindigkeit noch nicht invertiert
      xSpeed *= -0.8;      // Invertiere horizontale Geschwindigkeit(gleichzeitig wird die Geschwindigkeit reduziert)
  }
  // Abprallen von der linken Wand
  if (x< radius) {         // Wenn in Berührung mit linker Wand
    x = radius;            // Korrigiere Position, falls Ball "in" der Wand ist
    if (xSpeed<0)          // Falls Geschwindigkeit noch nicht invertiert
      xSpeed *= -0.8;      // Invertiere horizontale Geschwindigkeit(gleichzeitig wird die Geschwindigkeit reduziert)
  }

  // Falls Maustaste gedrückt ist
  if (mousePressed && mouseButton==LEFT) {
    // In Richtung Maus beschleunigen
    xSpeed = (mouseX - x)/3;
    ySpeed = (mouseY - y)/3;
  }

  // Ball an aktueller Position zeichnen
  circle(x, y, 2*radius);
}
