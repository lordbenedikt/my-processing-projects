float aStar(Node s, Node z, ArrayList<Node> path) {
  if (s==null || z==null) {
    path.clear();
    return -1f;
  }
  HashMap<Node, Float> distance = new HashMap<Node, Float>();
  distance.put(s, 0f);
  ArrayList<Node> order = new ArrayList<Node>();
  ArrayList<Node> todo = new ArrayList<Node>();
  todo.add(s);
  order.add(s);
  while (!todo.isEmpty()) {
    Node v = todo.get(0);
    float minScore = distance.get(v) + rest(v, z);
    for (int i = 1; i<todo.size(); i++) {
      Node current = todo.get(i);
      float currentScore = distance.get(current) + rest(v, z);
      if (currentScore < minScore) {
        minScore = currentScore;
        v = current;
      }
    }
    if (v == z) {
      path.clear();
      Node current = z;
      path.add(z);
      while (current != s) {
        for (Node n : current.neighbours()) {
          if (distance.containsKey(n)) {
            if (distance.get(n) < distance.get(current) &&
                distance.get(n)+dist(n.pos.x,n.pos.y,current.pos.x,current.pos.y)==distance.get(current)) {
              path.add(0, n);
              current = n;
              break;
            }
          }
        }
      }
      return distance.get(z);
    }
    todo.remove(v);
    for (Node u : v.neighbours()) {
      if (!distance.containsKey(u) || distance.get(u) > distance.get(v) + dist(v.pos.x, v.pos.y, u.pos.x, u.pos.y)) {
        distance.put(u, distance.get(v)+dist(v.pos.x, v.pos.y, u.pos.x, u.pos.y));
        todo.add(u);
        order.add(u);
      }
    }
  }

  path.clear();
  return -1f;
}

float rest(Node a, Node b) {
  return dist(a.pos.x,a.pos.y,b.pos.x,b.pos.y);
}
