Graph g = new Graph();
boolean directional = false;
String algorithm = "BFS";
Button[] buttons = new Button[2];

void setup() {
  size(800, 600);

  // Setup Buttons
  buttons[0] = new Button(width-200, height-50, 80, 40, "BFS");
  buttons[1] = new Button(width-100, height-50, 80, 40, "DFS");

  // Setup Graph
  g.addNode(new Node(200, 300, 'A'));
  g.addNode(new Node(300, 300, 'B'));
  g.addNode(new Node(400, 300, 'C'));
  g.addNode(new Node(300, 200, 'D'));
  g.addNode(new Node(300, 400, 'E'));
  g.addNode(new Node(450, 450, 'F'));
  g.addNode(new Node(500, 220, 'G'));
  g.addNode(new Node(430, 140, 'H'));
  g.addNode(new Node(130, 200, 'I'));
  g.addNode(new Node(130, 430, 'J'));
  g.addNode(new Node(80, 320, 'K'));
  g.addNode(new Node(80, 40, 'L'));
  g.addNode(new Node(600, 150, 'M'));
  g.connect('A', 'B', true);
  g.connect('B', 'C', true);
  g.connect('B', 'D', true);
  g.connect('B', 'E', true);
  g.connect('E', 'F', true);
  g.connect('F', 'G', true);
  g.connect('G', 'H', true);
  g.connect('H', 'B', true);
  g.connect('A', 'I', false);
  g.connect('E', 'J', true);
  g.connect('I', 'K', false);
  g.connect('K', 'J', false);
  g.connect('I', 'L', false);
  g.connect('M', 'G', false);
}

void draw() {
  background(255);

  handleInput();
  g.drawThis();
  drawRubberBand();

  drawButtons();
  showInfo();

  resetInputVariables();
}

void showInfo() {
  fill(0);
  textAlign(LEFT, TOP);
  if (g.selectedNodes().size()>0) {
    Node cur = g.selectedNodes().get(0);
    textAlign(LEFT, TOP);
    text("Points to: ", 10, 10);
    for (int i = 0; i< cur.connectedTo.size(); i++) {
      text(cur.connectedTo.get(i).name, 110+i*15, 10);
    }
  }
  text("Directial: " + (directional ? "Yes" : "No"), width-310, 10);
  text("Speed: " + g.speed, width-110, 10);
}

void drawButtons() {
  for (Button b : buttons) {
    b.drawThis();
  }
}
