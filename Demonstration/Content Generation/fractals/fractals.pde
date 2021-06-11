Fractal plant;
String sternMuster = "F-F++F-F";
String pflanze = "F[-F]F[+F][F]F";

void setup() {
  size(800, 600);
}

void draw() {
  
}

void mousePressed() {
  int iterations = mouseX/100;
  float s = iterations==0 ? 400 : 400/(pow(iterations,3f));
  plant = new Fractal(width/2, height-50, s, iterations, pflanze);
  background(1,44,70);
  stroke(255);
  plant.drawThis();
  print(plant.str);
}

class Fractal {
  float s;
  float x = 100;
  float y = height/2;
  String str = "F";
  String replaceF;
  char steps[];
  float dir = -HALF_PI;
  float minAngle = PI/8;
  float maxAngle = PI/3;
  float strWeight = 4;
  int iterations;
  Fractal(float x, float y, float s, int iterations, String replaceF) {
    this.x = x;
    this.y = y;
    this.replaceF = replaceF;
    this.s = s;
    this.iterations = iterations;
    for (int i = 0; i<iterations; i++) {
      String res = "";
      for (char c : str.toCharArray()) {
        if (c=='F') {
          res += replaceF;
        } else {
          res += c;
        }
      }
      str = res;
    }
    steps = str.toCharArray();
  }
  void drawThis() {
    float _x = x;
    float _y = y;
    float prevX = _x;
    float prevY = _y;
    ArrayList<State> posStack = new ArrayList<State>();
    for (char step : steps) {
      dir += random(-PI/20/iterations,PI/20/iterations);
      switch(step) {
      case 'F':
        PVector v = PVector.fromAngle(dir);
        prevX = _x;
        prevY = _y;
        _x += v.x * s * random(0,1);
        _y += v.y * s * random(0,1);
        stroke(129,93,38);
        strokeWeight(strWeight);
        line(prevX, prevY, _x, _y);
        break;
      case '-':
        dir -= random(minAngle,maxAngle);
        break;
      case '+':
        dir += random(minAngle,maxAngle);
        break;
      case '[':
        posStack.add(new State(_x, _y, dir, strWeight));
        strWeight *= 0.7f;
        break;
      case ']':
        if(random(1)<1f) {
          noStroke();
          fill(136,255,3);
          circle(_x,_y,random(s/7,s/6));
        }
        State pos = posStack.get(posStack.size()-1);
        posStack.remove(posStack.size()-1);
        _x = pos.x;
        _y = pos.y;
        dir = pos.dir;
        strWeight = pos.strWeight;
        break;
      default:
        break;
      }
    }
  }
}

class State {
  float x;
  float y;
  float dir;
  float strWeight;
  State(float x, float y, float dir, float strWeight) {
    this.x = x;
    this.y = y;
    this.dir = dir;
    this.strWeight = strWeight;
  }
}
