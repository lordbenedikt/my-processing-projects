int number = 10;    //Die darzustellende Zahl
String roman;       //Die römische Zahl als String

void setup() {
  //Fenstergröße
  size(600, 600);  
  
  //Setzt Textart auf Serif
  PFont serif = createFont("serif",200);
  textFont(serif);
  textAlign(CENTER, CENTER);  //TextAlign(Ausrichtung) auf CENTER,CENTER
}

void draw() {
  //Setzt den String zusammen, welcher die römische Zahl enthält
  //Dazu wird zwischen folgenden Zahlenbereiche unterschieden: 1-3, 4-5, 6-8, 9-10
  //Das ist so, weil Zahlen im jeweiligen Bereich "ähnlich" aussehen
  roman = "";
  if (number <= 3) {
    for (int i = 1; i<=number; i++) {
      roman += "I";
    }
  } else if (number <= 5) {
    if (number==4) {
      roman += "I";
    }
    roman += "V";
  } else if (number <= 8) {
    roman += "V";
    for (int i = 6; i <= number; i++) {
      roman += "I";
    }
  } else if (number <= 10) {
    if (number==9) {
      roman += "I";
    }
    roman += "X";
  }

  background(0);  //Schwarzer Hintergrund
  
  fill(255);  //Textfarbe auf weiß
  textSize(100);  //Textgröße auf 100
  text(number, width/2, height/2-200);
  textSize(300);  //Textgröße auf 300
  text(roman, width/2, height/2);  //römische Zahl
}

//Mit den Pfeiltasten(Hoch/Runter) lässt sich die Zahl vergrößern/verkleinern
void keyPressed() {
  if (keyCode==UP && number<10) {
    number++;
  }
  if (keyCode==DOWN && number>1) {
    number--;
  }
}
