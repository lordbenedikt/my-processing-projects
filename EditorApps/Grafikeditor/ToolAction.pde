enum Tool {
  LINE, 
    CIRCLE, 
    RECT, 
    ELLIPSE, 
    FILL_BACKGROUND
}

void toolDrag() {
  if (drawables.size()>0) {
    Drawable lastElement = drawables.get(drawables.size()-1);
    lastElement.drag();
  }
}

void toolCreate(boolean switchColors) {
  color c1 = switchColors ? selectedStrokeColor : selectedFillColor;
  color c2 = switchColors ? selectedFillColor : selectedStrokeColor;
  redoStack.clear();
  switch(selectedTool) {
  case LINE:
    drawables.add(new Line(mouseX, mouseY, mouseX, mouseY, c1, selectedStrWeight));
    break;
  case CIRCLE:
    drawables.add(new Circle(mouseX, mouseY, 0, c1, c2, selectedStrWeight));
    break;
  case RECT:
    drawables.add(new Rect(mouseX, mouseY, 0, 0, c1, c2, selectedStrWeight));
    break;
  case ELLIPSE:
    drawables.add(new Ellipse(mouseX, mouseY, 0, 0, c1, c2, selectedStrWeight));
    break;
  default:
  }
}
