import java.util.List;

List<Character> schonGeraten = new ArrayList<Character>();

int fehler = 0;
boolean gameOver = false;
boolean wortErraten = false;
boolean keyboard = false;
String woerter[] = {"Affe", "Giraffe", "Elefant", "Tiger", "Lokomotive", "Krankenhaus", "Taxi", "Pizza", "Furz", "Streich", 
  "Bart", "Diskussion", "Traum", "Schminken", "Strand", "Igel", "Chirurg", "Facebook", "Verstopfung", "Autounfall", "Verbrecher", 
  "Präsident", "Petze", "Schluckauf", "Detektiv", "Keks", "Scherz", "Perücke", "Schwarzes Schaf", "Flugzeug", "Baby", "Sonnenschein", "Stepptanz", 
  "Windel", "Lotto", "Zehennagel", "Toilette", "Krater", "Dosenöffner", "Skulptur", "Armdrücken", "Magie", "Clown", "Meerjungfrau", "Fette Katze", 
  "Milchmann", "Rockband", "Safari", "Alufolie", "Glasauge", "Ufo", "Donut", "Brainfreeze", "Schlafwandeln", "Chemiker", "Ketchup", "Moonwalk", 
  "Einbrecher", "Nasenhaare", "Spion", "Pirat", "Mundgeruch", "Höhlenmensch", "Das Weiße Haus", "Sensenmann", "Winnie Puh", "Karl der Große"};
String wort;
char buchstaben[] = new char[8];

void restart() {
  fehler = 0;
  gameOver = false;
  wortErraten = false;
  schonGeraten.clear();
  schonGeraten.add(' ');
  wort = woerter[(int)random(woerter.length)];
  buchstaben = new char[wort.length()];
  for (int i = 0; i<wort.length(); i++) {
    buchstaben[i] = Character.toUpperCase(wort.charAt(i));
  }
}

void setup() {
  size(800, 600);
  restart();
}

void keyPressed() {
  if (keyCode==ENTER) {
    restart();
    return;
  }
  if (key==CODED || key==' ' || key==BACKSPACE) {
    return;
  }
  if(wortErraten || gameOver) {
    return;
  }
  boolean falsch = true;
  for (int i = 0; i<buchstaben.length; i++) {
    if (buchstaben[i]==Character.toUpperCase(key)) {
      schonGeraten.add(Character.toUpperCase(key));
      falsch = false;
    }
  }
  if (falsch) {
    fehler += 1;
    if (fehler>=11) {
      gameOver = true;
    }
  }
}

void draw() {
  if (gameOver) {
    background(0);
  } else if (wortErraten) {
    background(100, 255, 100);
  } else {
    background(255);
  }
  fill(0);
  textSize(80);
  for (int i = 0; i<buchstaben.length; i++) {
    if (buchstaben[i]!=' ') {
      if (gameOver) {
        fill(100);
      } else {
        fill(0);
      }
      text('_', 100 + i*50, 110);
    }
  }
  boolean erraten = true;
  for (int i = 0; i<buchstaben.length; i++) {
    textSize(40);
    if (schonGeraten.contains(buchstaben[i])) {
      if (gameOver) {
        fill(200);
      } else {
        fill(0);
      }
      text(buchstaben[i], 100 + i*50, 100);
    } else {
      erraten = false;
      if (gameOver) {
        fill(255, 0, 0);
        text(buchstaben[i], 100 + i*50, 100);
      }
    }
  }
  if(erraten) {
    wortErraten = true;
  }
  zeichneGalgenmaennchen();
}

void zeichneGalgenmaennchen() {
  if (wortErraten) {
    strokeWeight(5);
    stroke(0);
    fill(0);
    circle(width/2, 325, 50);
    line(width/2, 350, width/2, 410);
    line(width/2, 360, width/2-70, 330);
    line(width/2, 360, width/2+70, 330);
    line(width/2, 410, width/2-30, 500);
    line(width/2, 410, width/2+30, 500);
    noStroke();
    fill(200);
    circle(width/2-8,320,8);
    circle(width/2+8,320,8);
    arc(width/2,330,20,20,0,PI);
  } else {
    if (gameOver) {
      fill(200);
      stroke(255);
      strokeWeight(5);
    } else {
      fill(0);
      stroke(0);
      strokeWeight(5);
    }

    // Galgen
    if (fehler>=1) {
      line(100, 500, 300, 500);
    }
    if (fehler>=2) {
      line(200, 500, 200, 200);
    }
    if (fehler>=3) {
      line(200, 200, 500, 200);
    }
    if (fehler>=4) {
      line(200, 250, 250, 200);
    }
    if (fehler>=5) {
      line(500, 200, 500, 250);
    }

    // Strichmaennchen
    if (gameOver) {
      stroke(200);
    }
    if (fehler>=6) { 
      circle(500, 275, 50);
    }
    if (fehler>=7) {
      line(500, 300, 500, 360);
    }
    if (fehler>=8) {
      line(500, 300, 470, 370);
    }
    if (fehler>=9) {
      line(500, 300, 530, 370);
    }
    if (fehler>=10) {
      line(500, 360, 470, 450);
    }
    if (fehler>=11) {
      line(500, 360, 530, 450);
    }
    if (gameOver) {
      stroke(0);
      strokeWeight(2);
      line(485, 270, 497, 280);
      line(485, 280, 497, 270);
      line(503, 270, 515, 280);
      line(503, 280, 515, 270);
    }
  }
}
