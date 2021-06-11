Rope rope = new Rope(30);

void setup() {
  size(400, 400);
}

void draw() {
  background(100);
  rope.update();
}

class Rope {
  float x = 0;
  float y = 0;
  float xSpeed = 0;
  float ySpeed = 0;
  ArrayList<Node> nodes = new ArrayList<Node>();
  Rope(int n) {
    for (int i = 0; i<n; i++) {
      addNode(200, 100+10*i);
    }
  }
  void update() {
    nodes.get(0).x = mouseX;
    nodes.get(0).y = mouseY;
    for (int i =0; i<nodes.size(); i++) {
      nodes.get(i).update();
    }
  }
  void addNode(float x, float y) {
    Node newNode = new Node(x,y);
    if (nodes.size()!=0) {
      newNode.previous.add(nodes.get(nodes.size()-1));
    }
    nodes.add(newNode);
  }
}

class Node {
  float x;
  float y;
  ArrayList<Node> previous = new ArrayList<Node>();
  Node(float x, float y) {
    this.x = x;
    this.y = y;
  }
  void update() {
    if (previous!=null)
      for (Node n : previous) {
        PVector diff = new PVector(x-n.x,y-n.y);
        diff.div(diff.mag());
        x = n.x+diff.x*5;
        y = n.y+diff.y*5;
        System.out.println(n);
    }
    ellipse(x, y, 10, 10);
  }
}
