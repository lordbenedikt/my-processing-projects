ArrayList<Integer> pressedKeys = new ArrayList<Integer>();

PVector prevMouse = new PVector(0, 0);
int mouseWasPressed = -1;
int mouseWasReleased = -1;

void mousePressed() {
  if (mouseButton==LEFT) {
    mouseWasPressed = 0;
  }
  if (mouseButton==RIGHT) {
    mouseWasPressed = 1;
  }
  if (mouseButton==CENTER) {
    mouseWasPressed = 2;
  }
}

void mouseReleased() {
  if (mouseButton==LEFT) {
    mouseWasReleased = 0;
  }
  if (mouseButton==RIGHT) {
    mouseWasReleased = 1;
  }
  if (mouseButton==CENTER) {
    mouseWasReleased = 2;
  }
}

void keyPressed() {
  if (!pressedKeys.contains(keyCode)) {
    pressedKeys.add(keyCode);
  }
  if (keyCode=='S') {
    if (keyIsDown(CONTROL)) {
      saveToFile();
    } else {
      if (g.selectedNodes().size()>0) {
        g.start = g.selectedNodes().get(0);
      }
      if (algorithm.equals("BFS")) {
        g.bfs();
      } else if(algorithm.equals("DFS")) {
        //g.dfs();
      }
    }
  }
  if (keyCode=='L') {
    if (keyIsDown(CONTROL)) {
      loadFile("Graph.txt");
    }
  }
  if (keyCode==DELETE) {
    for (Node n : g.selectedNodes()) {
      g.removeNode(n);
    }
  }
  if (key=='+') {
    g.speed = constrain(g.speed + 1, 1, 10);
  }
  if (key=='-') {
    g.speed = constrain(g.speed - 1, 1, 10);
  }
}

void keyReleased() {
  if (pressedKeys.contains(keyCode)) {
    pressedKeys.remove((Integer)keyCode);
  }
}

boolean keyIsDown(int code) {
  return pressedKeys.contains(code);
}

boolean keyIsDown(char c) {
  return pressedKeys.contains((int)Character.toUpperCase(c));
}

void handleInput() {
  // Add Node
  if (keyIsDown(ALT) && mouseWasPressed==0) {
    char name = (char)(65+g.nodes.size());
    g.addNode(new Node(mouseX, mouseY, name, g.selectedNodes()));
  }

  // Switch to directional edges and back
  if (mouseWasPressed==2) {
    directional = !directional;
  }

  // Rubber band
  if (mouseWasPressed==0) {
    rubberBand = new PVector(mouseX, mouseY);
  }
  if (mouseWasReleased==0) {
    if (dist(mouseX, mouseY, rubberBand.x, rubberBand.y)>30) {
      for (Node n : g.nodes) {
        if ((n.x<mouseX && n.x<rubberBand.x) || (n.x>mouseX && n.x>rubberBand.x) || 
          (n.y<mouseY && n.y<rubberBand.y) || (n.y>mouseY && n.y>rubberBand.y)) {
          n.selected = false;
        } else {
          n.selected = true;
        }
      }
    }
    rubberBand = null;
  }
}

void resetInputVariables() {
  mouseWasPressed = -1;
  mouseWasReleased = -1;

  // Remember previous mouse position
  prevMouse.x = mouseX;
  prevMouse.y = mouseY;
}
