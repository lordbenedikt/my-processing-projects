var keys = [];
var knoten = [];
var kanten = [];
var selection = [];
var path = [];
var ants = [];
var updateAnts = [];
var antSpeed = 100;
var antTimer = antSpeed;
var pathLength = -1;

var start;
var ziel;

var moving = false;
var antIMG;

class Dictionary {
  constructor() {
    this.keys = [];
    this.values = [];
  }
  getValue(keyy) {
    for (let i = 0; i<this.keys.length; i++) {
      if (this.keys[i] === keyy) {
        return this.values[i];
      }
    }
  }
  getKey(value) {
    for (let i = 0; i<this.values.length; i++) {
      if (this.values[i] === value) {
        return this.keys[i];
      }
    }
  }
  containsKey(keyy) {
    for (const k of this.keys) {
      if (k === keyy) {
        return true;
      }
    }
    return false;
  }
  put(keyy, value) {
    let index = this.keys.indexOf(keyy);
    if (index >= 0) {
      this.values[index] = value;
    } else {
      this.keys.push(keyy);
      this.values.push(value);
    }
  }
  remove(keyy) {
    for (let i = 0; i<this.keys.length; i++) {
      if (this.keys === keyy) {
        this.keys.splice(i, 1);
        this.values.splice(i, 1);
      }
    }
  }
}

function setup() {
  createCanvas(1200, 800);

  imageMode(CENTER);
  antIMG = loadImage('data/ant.png');

  let cols = 11;
  let rows = 8;
  for (var j = 0; j<rows; j++) {
    for (let i = 0; i<cols; i++) {
      knoten.push(new Knoten(50+i*50 +random(-20, 20), 180+j*50 +random(-20, 20)));
      if (i>0) {
        kanten.push(new Kante(knoten[j*cols+i-1], knoten[j*cols+i]));
      }
      if (j>0) {
        kanten.push(new Kante(knoten[(j-1)*cols+i], knoten[j*cols+i]));
      }
    }
  }
}

function draw() {  
  background(100);
  
  document.body.style.background = "#646464";

  if (moving) {
    pathLength = aStar(start, ziel, path);
  }

  fill(0);
  // instructions
  text("MOUSE_LEFT: Knoten auswählen", 10, 15);
  text("SHIFT + MOUSE_LEFT: Knoten zur Auswahl hinzufügen", 10, 30);
  text("CTRL + MOUSE_LEFT: Knoten erstellen(inkl. Kanten zu allen ausgewählten Knoten)", 10, 45);
  text("G: Ausgewählte Knoten bewegen(absetzen mit MOUSE_LEFT)", 10, 60);
  text("X: Ausgewählte Knoten löschen", 10, 75);
  text("A: Ausgewählten Knoten zum Startknoten machen", 10, 90);
  text("Z: Ausgewählten Knoten zum Zielknoten machen", 10, 105);
  text("L: Ausgewählten Knoten verbinden", 10, 120);
  // path length
  text("Pfadlänge: " + pathLength, 10, 135);

  //editor action
  //move knoten
  if (moving) {
    selection.forEach((k) => {
      k.x += mouseX-mouseLastX;
      k.y += mouseY-mouseLastY;
    }
    );
  }

  //spawn ants
  antTimer--;
  if (antTimer <= 0) {
    antTimer = floor(antSpeed * random(0.1, 1));
    if (start !== null && path.length>=2) {
      console.log("Path: " + path[1]);
      console.log("Length: " + path.length);
      ants.push(new Ant(path[0], path[1]));
    }
  }
  updateAnts = updateAnts.concat(ants);
  for (const a of updateAnts) {
    a.update();
  }
  arrayClear(updateAnts);

  //draw selection
  for (const k of selection) {
    noStroke();
    fill(255, 230, 200, 100);
    circle(k.x, k.y, 50);
  }

  for (const k of kanten) {
    stroke(255);
    k.draw();
  }

  for (const k of knoten) {
    stroke(255);
    k.draw();
  }
  for (const a of ants) {
    a.draw();
  }

  //draw path length
  //for (int i = 0; i<path.length; i++) {
  //  text(i, path[i].x, path[i].y);
  //}
  //draw path ids
  //for(int i = 0; i<path.length; i++) {
  //  text(""+path[i],20,100+i*20);
  //}

  mouseLastX = mouseX;
  mouseLastY = mouseY;
}

function rest(a, b) {
  return dist(a.x, a.y, b.x, b.y);
}

function aStar(s, z, path) {
  if (s==null || z==null) {
    arrayClear(path);
    return -1;
  }
  let distance = new Dictionary();
  distance.put(s, 0);
  let order = [];
  let todo = [];
  todo.push(s);
  order.push(s);
  while (todo.length !== 0) {
    let v = todo[0];
    let minScore = distance.getValue(v) + rest(v, z);
    for (let i = 1; i<todo.length; i++) {
      let current = todo[i];
      let currentScore = distance.getValue(current) + rest(current, z);
      if (currentScore < minScore) {
        minScore = currentScore;
        v = current;
      }
    }
    if (v == z) {
      arrayClear(path);
      let current = z;
      let temp = [];
      temp.push(z);
      while (current != s) {
        for (const n of current.neighbours()) {
          if (distance.containsKey(n)) {
            if (distance.getValue(n) < distance.getValue(current) &&
              distance.getValue(n)+dist(n.x, n.y, current.x, current.y) == distance.getValue(current)) {
              temp.push(n);
              current = n;
              break;
            }
          }
        }
      }
      for(let i = 0; i<temp.length; i++) {
        path[temp.length-1-i] = temp[i];
      }
      return distance.getValue(z);
    }
    arrayRemove(todo, v);
    for (const u of v.neighbours()) {
      if (!distance.containsKey(u) || distance.getValue(u) > distance.getValue(v) + dist(v.x, v.y, u.x, u.y)) {
        distance.put(u, distance.getValue(v)+dist(v.x, v.y, u.x, u.y));
        todo.push(u);
        order.push(u);
      }
    }
  }

  arrayClear(path);
  return -1;
}

class Ant {
  constructor(v, u) {
    this.x = v.x;
    this.y = v.y;
    this.v = v;
    this.u = u;
    this.dir = 0;
    this.speed = 1;
    this.progress = 0;
    this.isAtNode = 0;
    let newVector = new p5.Vector(v.x, v.y);
    this.dir = newVector.angleBetween(new p5.Vector(u.x, u.y));
  }
  update() {
    if (!knoten.includes(this.v) || !knoten.includes(this.u)) {
      arrayRemove(ants, this);
      return;
    }
    let distance = dist(this.v.x, this.v.y, this.u.x, this.u.y);
    this.progress += this.speed/distance;
    if (this.progress > 1) {
      this.progress = 0;
      this.isAtNode++;
      if (this.isAtNode >= path.length-1) {
        arrayRemove(ants, this);
        return;
      }
      this.v = this.u;
      this.u = path[this.isAtNode+1];
    }
    this.dir = angle(this.u.x-this.v.x, this.u.y-this.v.y);
    this.x = this.v.x + (this.progress*(this.u.x-this.v.x));
    this.y = this.v.y + (this.progress*(this.u.y-this.v.y));
  }
  draw() {
    applyMatrix();
    translate(this.x, this.y);
    rotate(this.dir);
    image(antIMG, 0, 0);
    resetMatrix();
  }
}

function angle(x, y) {
  let res; 
  if (x>0) {
    res = atan(y/x) + HALF_PI;
  } else {
    res = atan(y/x) + 3*HALF_PI;
  }
  return res;
}

class Kante {
  constructor(a, b) {
    this.a = a;
    this.b = b;
  }
  equals(k) {
    if (this.a==k.a && this.b==k.b) {
      return true;
    }
    if (this.b==k.a && this.a==k.b) {
      return true;
    }
    return false;
  }
  draw() {
    strokeWeight(2);
    if (path.includes(this.a) && path.includes(this.b)) {
      strokeWeight(5);
      stroke(255, 255, 0);
    }
    line(this.a.x, this.a.y, this.b.x, this.b.y);
  }
}

function getKante(a, b) {
  let wanted = new Kante(a, b);
  for (const k of kanten) {
    if (k.equals(wanted)) {
      return k;
    }
  }
  return null;
}

function removeKante(a, b) {
  let k = getKante(a, b);
  if (k!=null) {
    arrayRemove(kanten, k);
  }
}

function arrayRemove(arr, val) {
  let i = arr.indexOf(val);
  if (i != -1) {
    arr.splice(i, 1);
  }
}

function arrayRemoveAll(arr, vals) {
  vals.forEach(val => {
    arrayRemove(arr, val);
  }
  );
}

function arrayClear(arr) {
  arr.splice(0, arr.length);
}


function keyPressed() {
  //add key to list
  if (!keys.includes(keyCode)) {
    keys.push(keyCode);
  }

  //delete Knoten
  if (key.toUpperCase()=='X') {
    for (const k of selection) {
      k.delete();
    }
    arrayClear(selection);
  }

  //assign start/ziel Knoten
	if (key.toUpperCase()=='A') {
    	if (selection.length !== 0) {
    	start = selection[selection.length-1];
    	}
	}
	if (key.toUpperCase()=='Z') {
    	if (selection.length !== 0) {
    	ziel = selection[selection.length-1];
    	}
	}
	//link all selected Knoten
	if (key.toUpperCase()=='L') {
    	for (let i = 0; i<selection.length; i++) {
    	for (let j = i+1; j<selection.length; j++) {
        	selection[i].link(selection[j]);
    	}
    	}
	}
	//unlink all selected Knoten
	if (key.toUpperCase()=='K') {
    	for (let i = 0; i<selection.lenght; i++) {
    	for (let j = i+1; j<selection.lenght; j++) {
        	removeKante(selection[i], selection[j]);
    	}
    	}
	}

  //move selection
  if (key.toUpperCase()=='G') {
    moving = true;
  }

  pathLength = aStar(start, ziel, path);
}

function keyReleased() {
	console.log(keys);
  if (keys.includes(keyCode)) {
    arrayRemove(keys, keyCode);
  }
}

function keyIsDown(c) {
  return keys.includes(c.toUpperCase());
}

class Knoten {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
  link(knoten) {
    let newKante = new Kante(this, knoten);
    kanten.forEach(k => {
      if (k.equals(newKante)) {
        return;
      }
    }
    );
    kanten.push(newKante);
  }
  getKanten() {
    var attached = [];
    kanten.forEach(kante => {
      if (kante.a == this || kante.b == this) {
        attached.push(kante);
      }
    }
    );
    return attached;
  }
  delete() {
    arrayRemoveAll(kanten, this.getKanten());
    arrayRemove(knoten, this);
  }

  neighbours() {
    let neighbours = [];
    for (const k of this.getKanten()) {
      if (!neighbours.includes(k.a) && k.a !== this) {
        neighbours.push(k.a);
      }
      if (!neighbours.includes(k.b) && k.b !== this) {
        neighbours.push(k.b);
      }
    }
    return neighbours;
  }
  draw() {
    noStroke();
    fill(255);
    if (path.includes(this)) {
      fill(255, 255, 0);
    }
    if (this === start) {
      fill(0, 255, 0);
    }
    if (this === ziel) {
      fill(255, 0, 0);
    }
    circle(this.x, this.y, 10);
  }
}
/*
function getKanten(multipleKnoten) {
 let result = [];
 for (const k of multipleKnoten) {
 for (const kk of k.getKanten()) {
 if (!result.includes(kk)) {
 result.push(kk);
 }
 }
 }
 return result;
 }
 */

var mouseLastX;
var mouseLastY;

function mousePressed() {
  if (keyIsDown(CONTROL)) {
    if (mouseButton==LEFT) {
      let newKnoten = new Knoten(mouseX, mouseY);
      knoten.push(newKnoten);
      for (const k of selection) {
        kanten.push(new Kante(k, newKnoten));
      }
      arrayClear(selection);
      selection.push(newKnoten);
    }
  } else if (keyIsDown(SHIFT)) {
    if (mouseButton==LEFT) {
      let closest = getClosestToMouse();
      if (closest != null) {
        if (!selection.includes(closest)) {
          selection.push(closest);
        } else {
          arrayRemove(selection, closest);
        }
      }
    }
  } else if (mouseButton==LEFT) {
    if (!moving) {
      //select
      arrayClear(selection);
      let shortestDistance = 50;
      for (const k of knoten) {
        let currentDistance = dist(k.x, k.y, mouseX, mouseY);
        if (currentDistance < shortestDistance) {
          shortestDistance = currentDistance;
          arrayClear(selection);
          selection.push(k);
        }
      }
    } else {
      if (!moving) {
        arrayClear(selection);
      } else {
        moving = false;
      }
    }
  } else if (mouseButton==RIGHT) {
    if (!moving) {
      arrayClear(selection);
    } else {
      moving = false;
    }
  }
}

function getClosestToMouse() {
  let shortestDistance = 50;
  let closest = null;
  for (const k of knoten) {
    let currentDistance = dist(k.x, k.y, mouseX, mouseY);
    if (currentDistance < shortestDistance) {
      shortestDistance = currentDistance;
      closest = k;
    }
  }
  return closest;
}
