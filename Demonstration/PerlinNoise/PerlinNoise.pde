float groundHeights[]; //<>//
float angles[];

void mouseClicked() {
  angles = randomAngles(width/200+2);
}

void setup() {
  size(800, 600);
  angles = randomAngles(width/200+2);
}

float[] randomAngles(int l) {
  float angles[] = new float[l];
  for (int i = 0; i<angles.length; i++) {
    angles[i] = random(TWO_PI);
  }
  return angles;
}

float[] generateHeights(float baseLevel, float[] angles, int distance) {
  float[] res = new float[width];
  for (int i = 0; i<width; i++) {
    int n = i/distance;
    float w = (float)(i%distance) / distance;

    float a = PVector.fromAngle(angles[n]).y;
    float b = PVector.fromAngle(angles[n + 1]).y;
    float aValue = a*(i%distance);
    float bValue = b*(i%distance-distance);
    res[i] = baseLevel + smoothlerp(aValue, bValue, w);
  }
  return res;
}

void draw() {
  background(50);
  groundHeights = generateHeights(400, angles, 200);
  for (int i = 0; i<groundHeights.length; i++) {
    line(i, groundHeights[i], i, height);
  }
}

float smoothlerp(float a, float b, float w) {
  return lerp(a, b, 3*pow(w, 2) - 2*pow(w, 3));
}
