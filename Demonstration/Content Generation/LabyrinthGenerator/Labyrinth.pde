//class Mesh {
//  Line[] lines;
//  Mesh() {
//  }
//}

//class Line {
//  float x1;
//  float y1;
//  float y2;
//  float x2;
//  Line(float x1, float y1, float x2, float y2) {
//    this.x1 = x1;
//    this.y1 = y1;
//    this.x2 = x2;
//    this.y2 = y2;
//  }
//}

class Labyrinth {
  ArrayList<Edge> passages = new ArrayList<Edge>();
  ArrayList<Node> nodes = new ArrayList<Node>();
  ArrayList<Node> visited = new ArrayList<Node>();
  ArrayList<Node> path = new ArrayList<Node>();
  float edgeLength;
  PVector min;
  PVector max;
  Graph base;
  Graph walls;

  Labyrinth(float x, float y, float s, int rows) {
    base = newSquareGraph(x, y, s, rows);
    edgeLength = s/(rows-1);
    walls = newSquareGraph(x-edgeLength/2, y-edgeLength/2, s+edgeLength, rows+1);
    mazeDFS(base.nodes.get(0));
    min = new PVector(x, y);
    max = new PVector(x+s, y+s);
    for (Edge e : walls.edges) {
      boolean visible = true;
      for (Edge p : passages) {
        if (e.intersecting(p)) {
          visible = false;
        }
      }
      if (visible) 
        walls.visible.add(e);
      if (walls.edges.indexOf(e)==0 || walls.edges.indexOf(e)==walls.edges.size()-1)
        walls.visible.remove(e);
    }
    for (Edge e : passages) {
      e.n1.reachables.add(e.n2);
      e.n2.reachables.add(e.n1);
    }
  }

  void mazeDFS(Node origin) {
    visited.add(origin);
    Collections.shuffle(origin.reachables);
    for (Node destination : origin.reachables) {
      if (!visited.contains(destination)) {
        passages.add(new Edge(origin, destination));
        mazeDFS(destination);
      }
    }
    for (Node n : nodes) {
      n.reachables.clear();
    }
  }
  void solveBFS(ArrayList<Node> nodes) {
    ArrayList<Node> visited = new ArrayList<Node>();
    ArrayList<Node> todo = new ArrayList<Node>();
    //todo.add();
  }

  void draw() {
    stroke(255, 0, 0);
    noStroke();
    fill(255, 100, 100);
    for (Node n : base.nodes) {
      rect(n.pos.x-edgeLength/2-0.5, n.pos.y-edgeLength/2-0.5, edgeLength+1, edgeLength+1);
    }
    fill(0, 0, 255);
    for (Node n : nodes) {
      circle(n.pos.x, n.pos.y, 10);
    }
    fill(255);
    walls.draw();
    stroke(255,255,0);
    aStar(base.nodes.get(0),base.nodes.get(base.nodes.size()-1),path);
    for(int i = 0; i< path.size()-1; i++) {
      Edge newEdge = new Edge(path.get(i),path.get(i+1));
      circle(newEdge.n1.pos.x,newEdge.n1.pos.y,500);
      newEdge.draw();
    }
    
}
}
