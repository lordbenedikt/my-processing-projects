import java.lang.reflect.Field;

//@SuppressWarnings("rawtypes")
Object getValueOf(Object clazz, String lookingForValue) {
    try {
    Field field = clazz.getClass().getField(lookingForValue);
    Class clazzType = field.getType();
    if (clazzType.toString().equals("double"))
      return field.getDouble(clazz);
    else if (clazzType.toString().equals("float"))
      return field.getFloat(clazz);
    else if (clazzType.toString().equals("int"))
      return field.getInt(clazz);
    // else other type ...
    // and finally
    return field.get(clazz);
    } catch(Exception e) {
    return null;
  }
}

public void setFloatField(String fieldName, float value)
        /*throws NoSuchFieldException, IllegalAccessException*/ {
          try {
    Field field = getClass().getDeclaredField(fieldName);
    field.setFloat(this, value);
          } catch(Exception e) {}
}

Object getValueFromString(String s) {
  String[] aspects0 = s.split(".");
  //if (aspects0.length==1) return getValueOf()
  Object res;
  for(String a : aspects0) {
    String temp;
    if (a.contains("[")) temp = a.split("[")[1];
  }
  return null;
}

void imageMirrored(PImage img, float x, float y) {
  //in draw()
  //store scale, translation, etc
  pushMatrix();

  //flip across x axis
  scale(-1, 1);

  //The x position is negative because we flipped
  image(img, -x-img.width, y);

  //restore previous translation,etc
  popMatrix();
}

int clickedButton(Button[] buttons) {
  int clickedButton = -1;

  for (int i =0; i<buttons.length; i++) {
    Button b = buttons[i];
    if (insideBox(b.pos.x, b.pos.y, b.w, b.h, mouseX, mouseY))
      clickedButton = i;
  }
  return clickedButton;
}

boolean isBetween(float num, float beginning, float end) {

  if (num>=beginning && num<=end) return true;

  if (num>=end && num<=beginning) return true;

  return false;
}

boolean insideCircle(float x, float y, float r, float xThis, float yThis) {
  return (Math.sqrt(Math.pow(xThis-x, 2)+Math.pow(yThis-y, 2))<=r);
}

boolean insideBox(float x1, float y1, float w, float h, float xThis, float yThis) {
  float x2 = x1+w;
  float y2 = y1+h;
  if (xThis<x1 && xThis<x2) return false;
  if (xThis>x1 && xThis>x2) return false;
  if (yThis<y1 && yThis<y2) return false;
  if (yThis>y1 && yThis>y2) return false;
  return true;
}

void laser(float x1, float y1, float direction, boolean friendly) {
  //reset target
  PVector dir = PVector.fromAngle(TWO_PI*direction/360);
  float x2 = x1;
  float y2 = y1;

  int i = 0;
  while (i < 10000) {
    if (collWithRects(x2, y2)) {
      break;
    }
    if (runner.isColliding(x2, y2) && !friendly) {
      if (state==GM.PLAY) runner.health -= 2f;
      break;
    }
    x2 += dir.x;
    y2 += dir.y;
    i++;
  }

  stroke(color(255, 0, 0), 100);
  strokeWeight(5);
  line(x1, y1, x2, y2);
  strokeWeight(3);
  line(x1, y1, x2, y2);
  stroke(color(255, 255, 255), 100);
  strokeWeight(1);
  line(x1, y1, x2, y2);
  stroke(color(255, 0, 0), 100);
  fill(color(255, 0, 0), 100);
  noStroke();
  ellipse(x2, y2, 8, 8);
  ellipse(x2, y2, 12, 12);
  ellipse(x2, y2, 16, 16);
  fill(color(100));
  stroke(0);
  strokeWeight(1);
  fill(groundColor);
}
