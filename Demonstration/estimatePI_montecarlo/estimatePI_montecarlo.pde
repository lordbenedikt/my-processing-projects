int hits = 0;
int misses = 0;
void setup() {
  size(600, 600);
  noStroke();
  background(255);
  circle(300, 300, 600);
  frameRate(60);
}

void draw() {
  for (int i = 0; i<6; i++) {
    float x = random(0,599);
    float y = random(0,599);
    if(dist(299.5,299.5,x,y)<299.5) {
      fill(255,0,0);
      hits++;
    }
    else {
      fill(0, 255, 0);
      misses++;
    }
    circle(x, y,1);
  }
  fill(0);
  rect(0,0,200,60);
  fill(255);
  text("Hits: " + hits,10,20);
  text("Misses: " + misses,10,30);
  text("Pi: " + ((float)hits*4*pow(300,2))/(((float)hits+(float)misses)*pow(300,2)),10,50);
}

/*surface area = 
    PI * r^2
  screen SA = 
    2r * 2r = 4r^2
  -->
     PI * r^2          hits
    ----------  =  ------------- 
       4r^2         hits+misses
    
    PI =     hits * 4r^2
         -------------------
          r^2*(hits+misses)
*/
