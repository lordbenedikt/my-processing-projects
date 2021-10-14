class Graph {
  Node start;
  int count;
  int speed = 5;
  ArrayList<Node> nodes = new ArrayList<Node>();
  ArrayList<Node> todo = new ArrayList<Node>();
  ArrayList<Node> visited = new ArrayList<Node>();
  void bfs() {
    for (Node n : g.nodes) {
      n.col = color(255);
    }
    todo.clear();
    visited.clear();
    todo.add(start);
    bfsRek();
  }
  void bfsRek() {
    for (Node n : visited) {
      n.col = color(0, 255, 0);
    }
    if (todo.size()==0) {
      for (Node n : g.nodes) {
        if (visited.contains(n)) {
          n.col = color(255, 255, 100);
        } else {
          n.col = color(255);
        }
      }
    }
    int size = todo.size();
    for (int i = 0; i<size; i++) {
      Node cur = todo.get(0);
      if (visited.contains(cur)) {
        continue;
      }
      cur.col = color(255, 0, 0);
      todo.remove(cur);
      visited.add(cur);
      for (Node n : cur.connectedTo) {
        if (!visited.contains(n) && !todo.contains(n)) {
          todo.add(n);
        }
      }
    }
  }
  void addNode(Node node) {
    if (nodes.size()==0) {
      start = node;
    }
    nodes.add(node);
  }
  void removeNode(Node node) {
    for (Node n : node.connectedTo) {
      if (n.connectedTo.contains(node)) {
        n.connectedTo.remove(node);
      }
    }
    nodes.remove(node);
  }
  void drawThis() {
    if (count>0) {
      count--;
    }
    if (count==0) {
      count = 100/speed;
      if (algorithm.equals("BFS")) {
        bfsRek();
      } else if (algorithm.equals("BFS")) {
        //dfsRek();
      }
    }
    stroke(0);
    strokeWeight(1);
    for (Node n : nodes) {
      n.drawThis();
    }
  }
  ArrayList<Node> selectedNodes() {
    ArrayList<Node> selectedNodes = new ArrayList<Node>();
    for (Node n : nodes) {
      if (n.selected) {
        selectedNodes.add(n);
      }
    }
    return selectedNodes;
  }
  void connect(char a, char b, boolean bidirectional) {
    Node nodeA = null;
    Node nodeB = null;
    for (Node n : nodes) {
      if (n.name == a) {
        nodeA = n;
      }
      if (n.name == b) {
        nodeB = n;
      }
    }
    if (nodeA!=null & nodeB!=null) {
      nodeA.connectedTo.add(nodeB);
      if (bidirectional) {
        nodeB.connectedTo.add(nodeA);
      }
    }
  }
}
