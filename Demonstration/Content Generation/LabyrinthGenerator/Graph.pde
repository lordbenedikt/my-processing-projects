class Graph {
  //PVector min;
  //PVector max;
  ArrayList<Node> nodes = new ArrayList<Node>();
  ArrayList<Edge> edges = new ArrayList<Edge>();
  ArrayList<Edge> visible = new ArrayList<Edge>();

  Graph(List<Node> _nodes, List<Edge> _edges) {
    nodes.addAll(_nodes);
    edges.addAll(_edges);
  }
  Graph() {
  }


  void draw() {
    //for (Node n : nodes) {
    //  circle(n.pos.x, n.pos.y, 5);
    //}
    stroke(0);
    strokeWeight(5);
    for (Edge e : edges) {
      if (visible.contains(e)) {
        e.draw();
      }
    }
  }
}

class Edge {
  Node n1;
  Node n2;
  Edge(Node _n1, Node _n2) {
    n1 = _n1;
    n2 = _n2;
  }
  boolean intersecting(Edge e) {
    float x1 = n1.pos.x;
    float y1 = n1.pos.y;
    float x2 = n2.pos.x;
    float y2 = n2.pos.y;
    float x3 = e.n1.pos.x;
    float y3 = e.n1.pos.y;
    float x4 = e.n2.pos.x;
    float y4 = e.n2.pos.y;
    float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
    float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
    if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
    return true;
}
return false;
  }
  void draw() {
    line(n1.pos.x, n1.pos.y, 
      n2.pos.x, n2.pos.y);
  }
}

class Node {
  PVector pos;
  ArrayList<Node> reachables = new ArrayList<Node>();
  Node(PVector _pos, ArrayList<Node> _reachables) {
    pos = _pos;
    reachables.addAll(_reachables);
  }
  Node(PVector _pos) {
    pos = _pos;
  }
  ArrayList<Edge> getLinks() {
    ArrayList<Edge> links = new ArrayList<Edge>();
    for(Edge e : l1.passages) {
      if(e.n1==this || e.n2==this) {
        links.add(e);
      }
    }
    return links;
  }
  ArrayList<Node> neighbours() {
    ArrayList<Node> neighbours = new ArrayList<Node>();
    
    return neighbours;
  }
}

Graph newRectGraph(float x, float y, float w, float h, int columns, int rows) {
  float edgeWidth = w/(columns-1);
  float edgeHeight = h/(rows-1);

  Node[] nodes = new Node[columns*rows];
  ArrayList<Edge> edges = new ArrayList();

  for (int i = 0; i< nodes.length; i++) {
    nodes[i] = new Node(new PVector(x+edgeHeight*(i/columns), y+edgeWidth*(i%columns)));
  }
  for (int i = 0; i< nodes.length; i++) {
    //not at right border
    if ((i+1)%columns != 0) {  
      edges.add(new Edge(nodes[i], nodes[i+1]));
    }
    //not at bottom border
    if (i+columns < nodes.length) {  
      edges.add(new Edge(nodes[i], nodes[i+columns]));
    }
  }
  for (Edge e : edges) {
    e.n1.reachables.add(e.n2);
    e.n2.reachables.add(e.n1);
  }

  return new Graph(Arrays.asList(nodes), edges);
}

Graph newSquareGraph(float x, float y, float s, int rows) {
  Graph newGraph = newRectGraph(x, y, s, s, rows, rows);
  return  newGraph;
}
