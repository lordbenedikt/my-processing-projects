float roomWidth = 100;

PImage room_UDRL;
PImage room_UDR;
PImage room_UD;
PImage room_UR;
PImage room_U;
PImage room_no_exit;

Dungeon dungeon = new Dungeon(300,300);

void setup() {
  size(600, 600);
  room_UDRL = loadImage("room_UDRL.png");
  room_UDR = loadImage("room_UDR.png");
  room_UD = loadImage("room_UD.png");
  room_UR = loadImage("room_UR.png");
  room_U = loadImage("room_U.png");
  room_no_exit = loadImage("room_no_exit.png");

  //dungeon.rooms.add(new Room(100, 100, new int[]{0, 1, 0, 0}));
}

void draw() {
  background(255);
  dungeon.draw();
}

class Dungeon {
  float x;
  float y;
  Element start;
  //ArrayList<Element> rooms = new ArrayList<Element>();
  Dungeon(float x, float y) {
    this.x = x;
    this.y = y;
    start = new Room(x,y,new int[4]);
  }
  void draw() {
    start.drawSelfAndChildren();
  }
}

class Room extends Element {
  Room(float x, float y, int[] openings) {
    this.x = x;
    this.y = y;
    this.openings = openings;
  }
}

class Element {
  float x;
  float y;
  float s = 100;
  int[] openings = new int[4];
  ArrayList<Element> children = new ArrayList<Element>();
  void draw() {
    strokeWeight(3);

    for (int i = 0; i<4; i++) {
      pushMatrix();
      translate(x, y);
      rotate(HALF_PI*i);
      if (openings[i]==0) {
        //opening
        line(-s*0.4, -s*0.4, +s*0.4, -s*0.4);
      } else {
        //no opening
        line(-s*0.4, -s*0.4, -s*0.1, -s*0.4);
        line(-s*0.1, -s*0.4, -s*0.1, -s*0.5);
        line(+s*0.1, -s*0.5, +s*0.1, -s*0.4);
        line(+s*0.1, -s*0.4, +s*0.4, -s*0.4);
      }
      popMatrix();
    }
  }
  void addRoom(int side) {
    if (side==0) {
      children.add(new Room(x,y-s,new int[]{0,0,1,0}));
      openings[0] = 1;
    }
    if (side==1) {
      children.add(new Room(x+s,y,new int[]{0,0,0,1}));
      openings[1] = 1;
    }
    if (side==2) {
      children.add(new Room(x,y+s,new int[]{1,0,0,0}));
      openings[2] = 1;
    }
    if (side==3) {
      children.add(new Room(x-s,y,new int[]{0,1,0,0}));
      openings[3] = 1;
    }
  }
  void drawSelfAndChildren() {
    draw();
    for(Element child : children) {
      child.drawSelfAndChildren();
    }
  }
}
