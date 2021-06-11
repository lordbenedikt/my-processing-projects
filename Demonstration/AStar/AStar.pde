ArrayList<Integer> keys = new ArrayList<Integer>();
ArrayList<Knoten> knoten = new ArrayList<Knoten>();
ArrayList<Kante> kanten = new ArrayList<Kante>();
ArrayList<Knoten> selection = new ArrayList<Knoten>();
ArrayList<Knoten> path = new ArrayList<Knoten>();
ArrayList<Ant> ants = new ArrayList<Ant>();
ArrayList<Ant> updateAnts = new ArrayList<Ant>();
int antSpeed = 100;
int antTimer = antSpeed;

Knoten start;
Knoten ziel;

boolean moving = false;
PImage antIMG;

void setup() {
  size(600, 600);

  imageMode(CENTER);
  antIMG = loadImage("ant.png");

  int cols = 11;
  int rows = 8;
  for(int j = 0; j<rows; j++) {
    for(int i = 0; i<cols; i++) {
      knoten.add(new Knoten(50+i*50 +random(-20,20), 180+j*50 +random(-20,20)));
      if(i>0) {
        kanten.add(new Kante(knoten.get(j*cols+i-1),knoten.get(j*cols+i)));
      }
      if(j>0) {
        kanten.add(new Kante(knoten.get((j-1)*cols+i),knoten.get(j*cols+i)));
      }
    }
  }
}

void draw() {  
  background(100);

  fill(255);
  // instructions
  text("MOUSE_LEFT: Knoten auswählen", 10, 15);
  text("SHIFT + MOUSE_LEFT: Knoten zur Auswahl hinzufügen", 10, 30);
  text("CTRL + MOUSE_LEFT: Knoten erstellen(inkl. Kanten zu allen ausgewählten Knoten)", 10, 45);
  text("G: Ausgewählte Knoten bewegen(absetzen mit MOUSE_LEFT)", 10, 60);
  text("X: Ausgewählte Knoten löschen", 10, 75);
  text("CTRL + S: Ausgewählten Knoten zum Startknoten machen", 10, 90);
  text("CTRL + Z: Ausgewählten Knoten zum Zielknoten machen", 10, 105);
  // path length
  text("Pfadlänge: " + aStar(start, ziel, path), 10, 130);

  //editor action
  //move knoten
  if (moving) {
    for (Knoten k : selection) {
      k.x += mouseX-mouseLastX;
      k.y += mouseY-mouseLastY;
    }
  }

  //spawn ants
  antTimer--;
  if (antTimer <= 0) {
    antTimer = (int)(antSpeed * random(0.1f, 1f));
    if (start != null && path.size()>=2) {
      ants.add(new Ant(start, path.get(1)));
    }
  }
  updateAnts.addAll(ants);
  for (Ant a : updateAnts) {
    a.update();
  }
  updateAnts.clear();

  //draw selection
  for (Knoten k : selection) {
    noStroke();
    fill(255, 230, 200, 100);
    circle(k.x, k.y, 50);
  }

  for (Kante k : kanten) {
    stroke(255);
    k.draw();
  }
  for (Knoten k : knoten) {
    stroke(255);
    k.draw();
  }
  for (Ant a : ants) {
    a.draw();
  }
  //draw path length
  //for (int i = 0; i<path.size(); i++) {
  //  text(i, path.get(i).x, path.get(i).y);
  //}
  //draw path ids
  //for(int i = 0; i<path.size(); i++) {
  //  text(""+path.get(i),20,100+i*20);
  //}

  mouseLastX = mouseX;
  mouseLastY = mouseY;
}

float rest(Knoten a, Knoten b) {
  return dist(a.x, a.y, b.x, b.y);
}

float aStar(Knoten s, Knoten z, ArrayList<Knoten> path) {
  if (s==null || z==null) {
    path.clear();
    return -1f;
  }
  HashMap<Knoten, Float> distance = new HashMap<Knoten, Float>();
  distance.put(s, 0f);
  ArrayList<Knoten> order = new ArrayList<Knoten>();
  ArrayList<Knoten> todo = new ArrayList<Knoten>();
  todo.add(s);
  order.add(s);
  while (!todo.isEmpty()) {
    Knoten v = todo.get(0);
    float minScore = distance.get(v) + rest(v, z);
    for (int i = 1; i<todo.size(); i++) {
      Knoten current = todo.get(i);
      float currentScore = distance.get(current) + rest(current, z);
      if (currentScore < minScore) {
        minScore = currentScore;
        v = current;
      }
    }
    if (v == z) {
      path.clear();
      Knoten current = z;
      path.add(z);
      while (current != s) {
        for (Knoten n : current.neighbours()) {
          if (distance.containsKey(n)) {
            if (distance.get(n) < distance.get(current) &&
              distance.get(n)+dist(n.x, n.y, current.x, current.y)==distance.get(current)) {
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
    for (Knoten u : v.neighbours()) {
      if (!distance.containsKey(u) || distance.get(u) > distance.get(v) + dist(v.x, v.y, u.x, u.y)) {
        distance.put(u, distance.get(v)+dist(v.x, v.y, u.x, u.y));
        todo.add(u);
        order.add(u);
      }
    }
  }

  path.clear();
  return -1f;
}
