class Node {
  float x;
  float y;
  float r;
  color col = color(255);
  char name;
  boolean selected;
  ArrayList<Node> connectedTo = new ArrayList<Node>();
  Node(float x, float y, char name) {
    this.x = x;
    this.y = y;
    this.r = 15;
    this.name = name;
  }
  Node(float x, float y, char name, Node ... nodes) {
    this(x, y, name);
    for (Node n : nodes) {
      if (!directional) {
        connectedTo.add(n);
      }
      n.connectedTo.add(this);
    }
  }
  Node(float x, float y, char name, ArrayList<Node> nodes) {
    this(x, y, name);
    for (Node n : nodes) {
      if (!directional) {
        connectedTo.add(n);
      }
      n.connectedTo.add(this);
    }
  }
  void drawThis() {
        // Select
    if (mouseWasPressed==0) {
      if (!selected) {
        if (dist(x, y, mouseX, mouseY)<r) {
          selected = true;
        } else {
          selected = false;
        }
      } else {
        if (keyIsDown(SHIFT)) {
          if (dist(x, y, mouseX, mouseY)<r) {
            selected = false;
          }
        } else {
          selected = false;
        }
      }
    }

    // Connect
    if (mouseWasPressed==1) {
      if (dist(x, y, mouseX, mouseY)<r) {
        for (Node n : g.selectedNodes()) {
          if (!n.connectedTo.contains(this)) {
            n.connectedTo.add(this);
          } else {
            n.connectedTo.remove(this);
          }
        }
      }
    }

    // Update Position
    if (selected==true && keyIsDown(CONTROL)) {
      x += mouseX - prevMouse.x;
      y += mouseY - prevMouse.y;
    }

    // Draw Node
    fill(selected ? color(255, 150, 0) : col);
    circle(x, y, r*2);
    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
    text(name, x+0.5f, y-3);

    // Draw Edges
    fill(0);
    for (Node n : connectedTo) {
      // Draw Edge only if nodes aren't touching
      float distance = dist(x, y, n.x, n.y);
      if (distance > r*2) {
        float angle = PVector.angleBetween(new PVector(0, 1), new PVector(n.x-x, n.y-y));
        if (n.x-x > 0) {
          angle = TWO_PI - angle;
        }
        float _x = 0;
        if (n.connectedTo.contains(this)) {
          _x = -3;
        }
        pushMatrix();
        translate(x, y);
        rotate(angle);
        float l = distance - r - n.r;
        line(_x, r, _x, l+r);
        line(_x-6, l+r-6, _x, l+r);
        line(_x+6, l+r-6, _x, l+r);
        popMatrix();
      }

      // Draw Edge to self
      if (n == this) {
        fill(0, 0);
        arc(x, y-11, 20, 100, PI, TWO_PI);
        line(x-10, y-11, x-10-6, y-11-6);
        line(x-10, y-11, x-10+6, y-11-6);
      }
    }
  }
}
