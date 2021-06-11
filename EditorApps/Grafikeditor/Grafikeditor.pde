import java.util.List;

Tool selectedTool = Tool.CIRCLE;
color backgroundColor = color(255);
color selectedFillColor = color(255);
color selectedStrokeColor = color(0);
float selectedStrWeight = 3;
boolean toolbarAction = false;
TextBox strokeWeightInput = new TextBox(202, 0, 200, 30, "" + selectedStrWeight, "strWeight:");

void setup() {
  size(800, 600);
  loadImages();
  createToolbar();
}

void draw() {
  background(backgroundColor);
  stroke(5);
  strokeWeight(100);
  for (Drawable element : drawables) {
    element.drawThis();
  }
  if (mousePressed && (mouseButton==LEFT || mouseButton==RIGHT)) {
    // Falls nicht die Toolbar angeklickt wurde (sondern die Leinwand)
    if (!toolbarAction) {
      toolDrag();
    }
  }
  toolbar.drawThis();
  colorPicker.drawThis();
  strokeWeightInput.drawThis();
  drawPoint(pivotX, pivotY);
}

boolean mouseIsTouchingToolbar() {
  if (colorPicker.mouseIsTouching()) return true;
  return false;
}
